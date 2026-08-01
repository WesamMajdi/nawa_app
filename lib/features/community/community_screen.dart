import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/blocs/community/community_bloc.dart';
import 'package:nawa_flutter/core/models/post_model.dart';
import 'package:nawa_flutter/core/widgets/app_drawer.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/widgets/app_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    context.read<CommunityBloc>().add(CommunityLoadPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          BlocBuilder<CommunityBloc, CommunityState>(
            builder: (context, state) {
              if (state is CommunityLoading) {
                return const SafeArea(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is CommunityLoaded) {
                return _buildBody(state);
              }
              if (state is CommunityError) {
                return SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, style: AppTypography.bodyMD),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<CommunityBloc>().add(CommunityLoadPosts()),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const AppBottomNav(currentTab: NavTab.community),
          Positioned(
            bottom: 100,
            left: AppSpacing.containerMargin,
            child: _Fab(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CommunityLoaded state) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const _TopBar(),
          const SizedBox(height: AppSpacing.stackLG),
          if (state.trending.isNotEmpty) ...[
            _TrendingTopics(topics: state.trending),
            const SizedBox(height: AppSpacing.gutter),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerMargin,
            ),
            child: _TypeFilter(
              selectedType: _selectedType,
              onChanged: (type) {
                setState(() => _selectedType = type);
                context.read<CommunityBloc>().add(CommunityLoadPosts(type: type));
              },
            ),
          ),
          const SizedBox(height: AppSpacing.gutter),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerMargin,
            ),
            child: _PostFeed(posts: state.posts),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
      ),
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
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
                color: Colors.transparent,
              ),
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
            onTap: () => context.push('/notifications'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeFilter extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onChanged;

  const _TypeFilter({required this.selectedType, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final types = <String?, String>{
      null: 'الكل',
      'question': 'أسئلة',
      'discussion': 'نقاشات',
      'achievement': 'إنجازات',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.entries.map((e) {
          final isSelected = selectedType == e.key;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceVariant.withAlpha(77),
                ),
                child: Text(
                  e.value,
                  style: AppTypography.labelMD.copyWith(
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TrendingTopics extends StatelessWidget {
  final List<TrendingTopicModel> topics;

  const _TrendingTopics({required this.topics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
          child: Text('المواضيع الشائعة', style: AppTypography.headlineMD),
        ),
        const SizedBox(height: AppSpacing.stackSM),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerMargin,
          ),
          child: Row(
            children: topics.map((t) {
              return Padding(
                padding: const EdgeInsets.only(left: AppSpacing.stackSM),
                child: _TopicChip(label: '#${t.name}'),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;

  const _TopicChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withAlpha(38),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelMD.copyWith(
          color: AppColors.primaryFixed,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PostFeed extends StatelessWidget {
  final List<PostModel> posts;

  const _PostFeed({required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('لا توجد منشورات بعد', style: AppTypography.bodyMD),
        ),
      );
    }
    final bloc = context.read<CommunityBloc>();
    return Column(
      children: [
        for (int i = 0; i < posts.length; i++) ...[
          _PostCard(
            post: posts[i],
            onLike: () => bloc.add(
              CommunityToggleLike(
                postId: posts[i].id,
                isLiked: posts[i].isLikedByMe,
              ),
            ),
          ),
          if (i < posts.length - 1) const SizedBox(height: AppSpacing.gutter),
        ],
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;

  const _PostCard({required this.post, required this.onLike});

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          color: AppColors.surfaceContainerHigh.withAlpha(153),
          border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceContainerHigh.withAlpha(204),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.surfaceVariant,
                      backgroundImage: post.authorAvatarUrl != null
                          ? NetworkImage(post.authorAvatarUrl!)
                          : null,
                      child: post.authorAvatarUrl == null
                          ? const Icon(
                              Icons.person,
                              color: AppColors.onSurfaceVariant,
                              size: 28,
                            )
                          : null,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryContainer,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: AppTypography.headlineMD),
                      const SizedBox(height: 2),
                      Text(
                        '${post.authorJobTitle ?? post.authorRole ?? ''} • ${_timeAgo(post.createdAt)}',
                        style: AppTypography.labelMD.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (post.title != null) ...[
              const SizedBox(height: 12),
              Text(
                post.title!,
                style:                 AppTypography.headlineMD.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(post.body, style: AppTypography.bodyMD),
            if (post.imageUrls != null && post.imageUrls!.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.imageUrls!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: Image.network(
                      post.imageUrls![i],
                      width: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Divider(color: AppColors.onSurfaceVariant.withAlpha(25), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _ActionButton(
                  icon: post.isLikedByMe
                      ? Icons.thumb_up
                      : Icons.thumb_up_outlined,
                  label: '${post.likesCount}',
                  isActive: post.isLikedByMe,
                  onTap: onLike,
                ),
                const SizedBox(width: 24),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.repliesCount}',
                  onTap: () {},
                ),
                const Spacer(),
                const _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'مشاركة',
                  onTap: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.onSurfaceVariant;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelMD.copyWith(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withAlpha(77),
            blurRadius: 20,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.add,
          color: AppColors.surfaceContainerLowest,
          size: 32,
        ),
        onPressed: () => _showNewPostSheet(context),
      ),
    );
  }

  void _showNewPostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'إنشاء منشور جديد',
              style: AppTypography.headlineMD,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}
