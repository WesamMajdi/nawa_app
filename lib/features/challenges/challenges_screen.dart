import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nawa_flutter/core/blocs/challenge/challenge_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/models/challenge_model.dart';
import 'package:nawa_flutter/core/widgets/app_drawer.dart';
import 'package:nawa_flutter/features/leaderboard/leaderboard_screen.dart';
import 'package:nawa_flutter/features/notifications/notifications_screen.dart';
import '../../core/widgets/app_bottom_nav.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  String? _activeCategory;
  List<ChallengeModel> _challenges = [];

  @override
  void initState() {
    super.initState();
    context.read<ChallengeBloc>().add(ChallengeFeedLoadRequested());
  }

  void _onCategoryChanged(String? category) {
    setState(() => _activeCategory = category);
    context.read<ChallengeBloc>().add(ChallengeFeedLoadRequested(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              left: AppSpacing.containerMargin,
              right: AppSpacing.containerMargin,
              top: 88,
              bottom: 120,
            ),
            children: [
              const _Header(),
              const SizedBox(height: AppSpacing.stackLG),
              _CategoryChips(
                activeCategory: _activeCategory,
                onCategoryChanged: _onCategoryChanged,
              ),
              const SizedBox(height: AppSpacing.stackLG),
              BlocBuilder<ChallengeBloc, ChallengeState>(
                builder: (context, state) {
                  if (state is ChallengeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ChallengeFeedLoaded) {
                    _challenges = state.challenges;
                  }
                  if (state is ChallengeError) {
                    return Center(
                      child: Column(
                        children: [
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context.read<ChallengeBloc>().add(
                              ChallengeFeedLoadRequested(category: _activeCategory),
                            ),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildChallengeList();
                },
              ),
            ],
          ),
          const _TopBar(),
          const AppBottomNav(currentTab: NavTab.challenges),
          Positioned(bottom: 100, left: AppSpacing.containerMargin, child: const _Fab()),
        ],
      ),
    );
  }

  Widget _buildChallengeList() {
    if (_challenges.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _ChallengeCard(challenge: _challenges.first, isFeatured: true),
        if (_challenges.length > 1) ...[
          const SizedBox(height: AppSpacing.stackLG),
          const _UpcomingLabel(),
          const SizedBox(height: AppSpacing.stackMD),
          ..._challenges.skip(1).map((c) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
            child: _ChallengeCard(challenge: c, isFeatured: false),
          )),
        ],
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(153),
        border: Border(bottom: BorderSide(color: AppColors.onSurfaceVariant.withAlpha(25))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.full)),
              child: const Icon(Icons.menu, color: AppColors.onSurface),
            ),
          ),
          const Spacer(),
          Text(
            'نواة',
            style: AppTypography.headlineLG.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.full)),
              child: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: AppColors.onSurface),
                  Positioned(
                    top: 4, right: 4,
                    child: Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(128), blurRadius: 8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('التحديات والمسابقات', style: AppTypography.headlineXL),
        const SizedBox(height: AppSpacing.stackSM),
        Text(
          'اختبر مهاراتك، تنافس مع أفضل المطورين، واربح جوائز قيمة.',
          style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final String? activeCategory;
  final ValueChanged<String?> onCategoryChanged;

  const _CategoryChips({required this.activeCategory, required this.onCategoryChanged});

  static const _categories = [
    (label: 'تحديات برمجية', category: 'coding', icon: Icons.local_fire_department),
    (label: 'هاكاثون', category: 'hackathon', icon: null),
    (label: 'مسابقات سريعة', category: 'quick_contest', icon: null),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((c) {
          final isActive = activeCategory == c.category || (activeCategory == null && c.category == 'coding');
          return Padding(
            padding: EdgeInsets.only(left: c != _categories.last ? AppSpacing.gutter : 0),
            child: GestureDetector(
              onTap: () => onCategoryChanged(isActive ? null : c.category),
              child: _Chip(
                icon: c.icon,
                label: c.label,
                isActive: isActive,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool isActive;

  const _Chip({this.icon, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryContainer.withAlpha(38) : AppColors.surfaceContainer.withAlpha(128),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: isActive ? AppColors.primaryContainer.withAlpha(77) : AppColors.outlineVariant.withAlpha(77),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: AppTypography.labelMD.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  final bool isFeatured;

  const _ChallengeCard({required this.challenge, required this.isFeatured});

  String _timeRemaining(DateTime? endsAt) {
    if (endsAt == null) return '';
    final diff = endsAt.difference(DateTime.now());
    if (diff.isNegative) return 'انتهى';
    if (diff.inDays > 0) return '${diff.inDays} يوم';
    if (diff.inHours > 0) return '${diff.inHours} ساعة';
    if (diff.inMinutes > 0) return '${diff.inMinutes} دقيقة';
    return 'أقل من دقيقة';
  }

  @override
  Widget build(BuildContext context) {
    final hasEnded = challenge.endsAt != null && challenge.endsAt!.isBefore(DateTime.now());

    if (isFeatured) {
      return GestureDetector(
        onTap: () => context.go('/challenge/${challenge.id}'),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            color: AppColors.surfaceContainer.withAlpha(102),
            border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColors.primaryContainer.withAlpha(25), Colors.transparent],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (hasEnded)
                    _Badge(icon: Icons.timer_off, label: 'انتهى', color: AppColors.error, bgColor: AppColors.errorContainer)
                  else if (challenge.endsAt != null)
                    _Badge(icon: Icons.timer, label: 'ينتهي ${_timeRemaining(challenge.endsAt)}', color: AppColors.error, bgColor: AppColors.errorContainer),
                  const Spacer(),
                  if (challenge.difficulty != null)
                    _Badge(
                      icon: Icons.military_tech,
                      label: challenge.difficulty!,
                      color: AppColors.primary,
                      bgColor: AppColors.surfaceVariant,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.stackMD),
              Text(challenge.title, style: AppTypography.headlineMD),
              if (challenge.description != null) ...[
                const SizedBox(height: AppSpacing.stackSM),
                Text(challenge.description!, style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant)),
              ],
              const SizedBox(height: AppSpacing.stackMD),
              const Divider(color: AppColors.outlineVariant, height: 1),
              const SizedBox(height: AppSpacing.stackMD),
              Row(
                children: [
                  if (challenge.participantsCount != null) ...[
                    const Icon(Icons.groups, size: 20, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.stackSM),
                    Text(
                      formatNumber(challenge.participantsCount!),
                      style: AppTypography.labelMD.copyWith(color: AppColors.onSurfaceVariant, fontSize: 14),
                    ),
                    const SizedBox(width: AppSpacing.gutter),
                  ],
                  Container(width: 1, height: 16, color: AppColors.outlineVariant.withAlpha(128)),
                  const SizedBox(width: AppSpacing.gutter),
                  if (challenge.xpReward != null) ...[
                    const Icon(Icons.emoji_events, size: 20, color: AppColors.secondary),
                    const SizedBox(width: AppSpacing.stackSM),
                    Text(
                      '${challenge.xpReward!} XP',
                      style: AppTypography.labelMD.copyWith(color: AppColors.secondary, fontSize: 14),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.stackMD),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/challenge/${challenge.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    elevation: 0,
                    textStyle: AppTypography.headlineMD,
                  ).copyWith(
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: Text(challenge.joinedOrSolved ? 'عرض التحدي' : 'انضم للتحدي الآن'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => context.go('/challenge/${challenge.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          color: AppColors.surfaceContainer.withAlpha(77),
          border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                color: AppColors.surfaceVariant,
                border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
              ),
              child: Icon(
                challenge.kind == 'hackathon' ? Icons.group_work : Icons.code,
                color: AppColors.primary, size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(challenge.title, style: AppTypography.headlineMD.copyWith(fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (challenge.difficulty != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.military_tech, size: 14, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(challenge.difficulty!, style: AppTypography.labelMD.copyWith(color: AppColors.onSurfaceVariant, fontSize: 12)),
                          ],
                        ),
                      if (challenge.difficulty != null) const SizedBox(width: AppSpacing.gutter),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.emoji_events, size: 14, color: AppColors.secondary.withAlpha(204)),
                          const SizedBox(width: 4),
                          Text(
                            '${challenge.xpReward ?? challenge.badgeReward ?? ''}',
                            style: AppTypography.labelMD.copyWith(color: AppColors.secondary.withAlpha(204), fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              _timeRemaining(challenge.endsAt),
              style: AppTypography.codeSM.copyWith(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

String formatNumber(int number) {
  if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
  if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
  return number.toString();
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _Badge({required this.icon, required this.label, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: bgColor.withAlpha(51),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.codeSM.copyWith(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}

class _UpcomingLabel extends StatelessWidget {
  const _UpcomingLabel();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text('تحديات قادمة', style: AppTypography.headlineMD),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [BoxShadow(color: AppColors.primaryContainer.withAlpha(102), blurRadius: 20)],
      ),
      child: IconButton(
        icon: const Icon(Icons.leaderboard, color: AppColors.background, size: 28),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
      ),
    );
  }
}
