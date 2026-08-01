import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/blocs/notification/notification_bloc.dart';
import '../../core/constants/constants.dart';
import '../../core/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const NotificationLoadRequested());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final state = context.read<NotificationBloc>().state;
      if (state is NotificationLoaded && state.hasMore) {
        context.read<NotificationBloc>().add(NotificationLoadMore());
      }
    }
  }

  String _emojiForType(String type) {
    switch (type) {
      case 'streak':
        return '\u{1F525}';
      case 'badge':
        return '\u{1F3C5}';
      case 'reply':
        return '\u{1F4AC}';
      case 'review':
        return '\u{2B50}';
      case 'system':
        return '\u{2699}\u{FE0F}';
      case 'hackathon':
        return '\u{1F4BB}';
      case 'billing':
        return '\u{1F4B3}';
      case 'match':
        return '\u{1F91D}';
      case 'mention':
        return '@';
      default:
        return '\u{1F514}';
    }
  }

  Color _iconBgForType(String type) {
    switch (type) {
      case 'streak':
        return AppColors.primaryContainer;
      case 'badge':
        return AppColors.tertiaryContainer;
      case 'reply':
        return AppColors.secondaryContainer;
      case 'review':
        return const Color(0x1AFFD700);
      case 'system':
        return AppColors.surfaceVariant;
      case 'hackathon':
        return AppColors.primaryContainer;
      case 'billing':
        return AppColors.secondaryContainer;
      case 'match':
        return AppColors.tertiaryContainer;
      case 'mention':
        return AppColors.primaryContainer;
      default:
        return AppColors.surfaceVariant;
    }
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    if (diff.inDays == 1) return 'الأمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${date.day}/${date.month}/${date.year}';
  }

  Map<String, List<NotificationModel>> _groupByDate(
      List<NotificationModel> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final Map<String, List<NotificationModel>> groups = {};
    for (final n in notifications) {
      String key;
      if (n.createdAt == null) {
        key = 'سابقاً';
      } else {
        final d = DateTime(n.createdAt!.year, n.createdAt!.month, n.createdAt!.day);
        if (d == today) {
          key = 'اليوم';
        } else if (d == yesterday) {
          key = 'الأمس';
        } else {
          key = 'سابقاً';
        }
      }
      groups.putIfAbsent(key, () => []);
      groups[key]!.add(n);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return _buildLoading();
            }
            if (state is NotificationError) {
              return _buildError(state.message);
            }
            if (state is NotificationLoaded) {
              final grouped = _groupByDate(state.notifications);
              final sectionKeys = ['اليوم', 'الأمس', 'سابقاً'];
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<NotificationBloc>()
                      .add(const NotificationLoadRequested());
                },
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _TopBar(
                      onMarkAllRead: () {
                        context
                            .read<NotificationBloc>()
                            .add(NotificationMarkAllAsRead());
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.containerMargin),
                      child: _ClearAllRow(),
                    ),
                    const SizedBox(height: AppSpacing.stackLG),
                    for (final key in sectionKeys)
                      if (grouped.containsKey(key)) ...[
                        if (key != sectionKeys.first)
                          const SizedBox(height: AppSpacing.stackMD),
                        _SectionHeader(title: key),
                        for (final notification in grouped[key]!)
                          _NotificationCard(
                            emoji: _emojiForType(notification.type),
                            iconBg: _iconBgForType(notification.type),
                            title: notification.title,
                            time: _timeAgo(notification.createdAt),
                            body: notification.text,
                            unread: !notification.isRead,
                            onTap: () {
                              if (!notification.isRead) {
                                context
                                    .read<NotificationBloc>()
                                    .add(NotificationMarkAsRead(notification.id));
                              }
                              if (notification.linkUrl != null) {
                                context.go(notification.linkUrl!);
                              }
                            },
                          ),
                      ],
                    if (state.hasMore)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _TopBar(),
        const Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
          child: _ClearAllRow(),
        ),
        const SizedBox(height: AppSpacing.stackLG),
        for (int i = 0; i < 5; i++) _ShimmerCard(),
      ],
    );
  }

  Widget _buildError(String message) {
    return ListView(
      children: [
        _TopBar(),
        const SizedBox(height: 48),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: AppTypography.bodyMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<NotificationBloc>()
                        .add(const NotificationLoadRequested());
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.stackSM / 2,
      ),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          color: AppColors.surfaceContainerHigh.withAlpha(76),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariant.withAlpha(76),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.surfaceVariant.withAlpha(76),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.surfaceVariant.withAlpha(51),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback? onMarkAllRead;

  const _TopBar({this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(153),
        border: Border(
          bottom: BorderSide(color: AppColors.onSurfaceVariant.withAlpha(25)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Icon(Icons.arrow_forward, color: AppColors.onSurface),
            ),
          ),
          const Spacer(),
          Text(
            'الإشعارات',
            style: AppTypography.headlineLG.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onMarkAllRead,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Icon(Icons.done_all, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClearAllRow extends StatelessWidget {
  const _ClearAllRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            context.read<NotificationBloc>().add(NotificationMarkAllAsRead());
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مسح الكل',
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.primary.withAlpha(204),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.stackSM,
      ),
      child: Text(
        title,
        style: AppTypography.headlineMD.copyWith(
            color: AppColors.onSurfaceVariant),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String emoji;
  final Color iconBg;
  final String title;
  final String time;
  final String body;
  final bool unread;
  final VoidCallback? onTap;

  const _NotificationCard({
    required this.emoji,
    required this.iconBg,
    required this.title,
    required this.time,
    required this.body,
    required this.unread,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.stackSM / 2,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            color: AppColors.surfaceContainerHigh.withAlpha(153),
            border: Border.all(
              color: unread
                  ? AppColors.primary.withAlpha(128)
                  : AppColors.onSurfaceVariant.withAlpha(25),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (unread)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 16, left: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(128),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                if (!unread) const SizedBox(width: 20),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    color: iconBg,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style:
                                  AppTypography.headlineMD.copyWith(
                                color: AppColors.onSurface,
                                fontSize: 16,
                                fontWeight:
                                    unread ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: AppTypography.codeSM.copyWith(
                              color:
                                  AppColors.onSurfaceVariant.withAlpha(153),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: AppTypography.codeSM.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
