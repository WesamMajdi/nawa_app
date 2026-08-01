import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/blocs/community/community_bloc.dart';
import 'package:nawa_flutter/core/models/post_model.dart';
import 'package:nawa_flutter/core/models/user_model.dart';
import 'package:nawa_flutter/core/models/user_models.dart';
import 'package:nawa_flutter/core/repositories/user_repository.dart';
import 'package:nawa_flutter/core/widgets/app_bottom_nav.dart';
import 'package:nawa_flutter/core/widgets/app_drawer.dart';
import '../account_settings/edit_profile/edit_profile_screen.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  final _tabs = ['إنجازاتي', 'مساراتي', 'منشوراتي'];
  UserModel? _user;
  List<BadgeModel> _badges = [];
  List<SkillModel> _skills = [];
  List<UserLearningModel> _learning = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final repo = context.read<UserRepository>();
      final results = await Future.wait([
        repo.getMe(),
        repo.getBadges(),
        repo.getSkills(),
        repo.getLearning(),
      ]);
      if (!mounted) return;
      setState(() {
        _user = results[0] as UserModel;
        _badges = results[1] as List<BadgeModel>;
        _skills = results[2] as List<SkillModel>;
        _learning = results[3] as List<UserLearningModel>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'حدث خطأ في تحميل الملف الشخصي';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _isLoading
                    ? const SizedBox(
                        height: 400,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_error!, style: AppTypography.bodyMD),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadData,
                                    child: const Text('إعادة المحاولة'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _buildBody(),
              ),
            ],
          ),
          const _TopBar(),
          AppBottomNav(currentTab: NavTab.profile),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final user = _user!;
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        bottom: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _ProfileHeader(user: user, skills: _skills),
          const SizedBox(height: AppSpacing.stackLG),
          _StatsGrid(
            level: user.level,
            streakDays: user.streakDays,
            xp: user.xp,
            achievementsCount: _badges.length,
          ),
          const SizedBox(height: AppSpacing.stackLG),
          _TabSection(
            tabs: _tabs,
            selectedTab: _selectedTab,
            onTabChanged: (i) => setState(() => _selectedTab = i),
          ),
          const SizedBox(height: AppSpacing.gutter),
          if (_selectedTab == 0)
            _AchievementsList(badges: _badges)
          else if (_selectedTab == 1 && _learning.isNotEmpty)
            _LearningList(learning: _learning)
          else if (_selectedTab == 1)
            const _EmptyLearningList()
          else
            const _MyPostsTab(),
          const SizedBox(height: 24),
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
          Text(
            'نواة',
            style: AppTypography.headlineLG.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => context.push('/notifications'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: const Icon(Icons.notifications_outlined, color: AppColors.onSurface),
                ),
              ),
              const SizedBox(width: AppSpacing.stackSM),
              GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: const Icon(Icons.menu, color: AppColors.onSurface),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  final List<SkillModel> skills;

  const _ProfileHeader({required this.user, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryContainer.withAlpha(40),
            AppColors.surfaceContainerHigh.withAlpha(153),
          ],
        ),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _AvatarSection(
                avatarUrl: user.avatarUrl,
                initials: user.initials,
              ),
              const SizedBox(width: AppSpacing.stackMD),
              Expanded(child: _UserInfo(user: user, skills: skills)),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          if (user.jobTitle != null || user.bio != null) ...[
            if (user.jobTitle != null)
              Row(
                children: [
                  Icon(Icons.work_outline, size: 16, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      user.jobTitle!,
                      style: AppTypography.bodyMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            if (user.jobTitle != null && user.bio != null)
              const SizedBox(height: AppSpacing.unit),
            if (user.bio != null)
              Text(
                user.bio!,
                style: AppTypography.bodyMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: AppSpacing.stackMD),
          ],
          if (skills.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((s) => _TechTag(label: s.name)).toList(),
            ),
            const SizedBox(height: AppSpacing.stackMD),
          ],
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    elevation: 0,
                    textStyle: AppTypography.headlineMD,
                  ).copyWith(
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('تعديل الملف الشخصي'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.gutter),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primaryContainer),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    textStyle: AppTypography.headlineMD,
                  ).copyWith(
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.share, size: 18),
                      SizedBox(width: 8),
                      Text('مشاركة'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String? avatarUrl;
  final String? initials;

  const _AvatarSection({this.avatarUrl, this.initials});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withAlpha(80),
                AppColors.primaryContainer.withAlpha(60),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withAlpha(40), width: 2),
              ),
              child: ClipOval(
                child: avatarUrl != null
                    ? Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildFallback(),
                      )
                    : _buildFallback(),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
            child: const Icon(Icons.code, size: 16, color: AppColors.background),
          ),
        ),
      ],
    );
  }

  Widget _buildFallback() {
    return Container(
      color: AppColors.surfaceContainerHigh,
      alignment: Alignment.center,
      child: Text(
        initials ?? '?',
        style: const TextStyle(
          fontSize: 42,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final UserModel user;
  final List<SkillModel> skills;

  const _UserInfo({required this.user, required this.skills});

  @override
  Widget build(BuildContext context) {
    final handleAndJob = StringBuffer();
    if (user.handle != null) {
      handleAndJob.write('@${user.handle}');
    }
    if (user.handle != null && user.jobTitle != null) {
      handleAndJob.write(' • ');
    }
    if (user.jobTitle != null) {
      handleAndJob.write(user.jobTitle);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: AppTypography.headlineXL.copyWith(color: AppColors.primaryFixed),
        ),
        if (handleAndJob.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            handleAndJob.toString(),
            style: AppTypography.labelMD.copyWith(
              color: AppColors.onSurfaceVariant,
              fontFamily: AppTypography.fontMono,
              fontSize: 12,
            ),
          ),
        ],
        if (user.bio != null) ...[
          const SizedBox(height: AppSpacing.stackMD),
          Text(
            user.bio!,
            style: AppTypography.bodyMD.copyWith(
              color: AppColors.onSurface.withAlpha(204),
            ),
          ),
        ],
        if (skills.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.stackMD),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((s) => _TechTag(label: s.name)).toList(),
          ),
        ],
      ],
    );
  }
}

class _TechTag extends StatelessWidget {
  final String label;

  const _TechTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        color: AppColors.primaryContainer.withAlpha(38),
        border: Border.all(color: AppColors.primary.withAlpha(51)),
      ),
      child: Text(
        label,
        style: AppTypography.labelMD.copyWith(
          color: AppColors.primary,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final int level;
  final int streakDays;
  final int xp;
  final int achievementsCount;

  const _StatsGrid({
    required this.level,
    required this.streakDays,
    required this.xp,
    required this.achievementsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.military_tech,
              color: AppColors.primary,
              value: 'Lv. $level',
              label: 'المستوى',
            ),
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: _StatItem(
              icon: Icons.local_fire_department,
              color: AppColors.secondary,
              value: '$streakDays',
              label: 'يوم متتالي',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: color.withAlpha(10),
        border: Border.all(color: color.withAlpha(25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: AppSpacing.stackSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.headlineMD.copyWith(
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSection extends StatefulWidget {
  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const _TabSection({
    required this.tabs,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  State<_TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<_TabSection> {
  late final List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();
    _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant _TabSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withAlpha(80),
        border: Border(
          bottom: BorderSide(color: AppColors.onSurfaceVariant.withAlpha(12)),
        ),
      ),
      child: Row(
        children: List.generate(widget.tabs.length, (i) {
          final isSelected = i == widget.selectedTab;
          return Expanded(
            child: GestureDetector(
              key: _tabKeys[i],
              onTap: () => widget.onTabChanged(i),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.tabs[i],
                      style: AppTypography.headlineMD.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: isSelected ? 3 : 0,
                      width: isSelected ? 32 : 0,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AchievementsList extends StatelessWidget {
  final List<BadgeModel> badges;

  const _AchievementsList({required this.badges});

  Color _parseColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('لا توجد إنجازات بعد', style: AppTypography.bodyMD),
        ),
      );
    }
    return Column(
      children: badges.map((badge) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
          child: _AchievementCard(
            icon: Icons.workspace_premium,
            color: _parseColor(badge.color),
            title: badge.name,
            subtitle: badge.unlocked ? 'تم الإنجاز ✓' : 'لم يتم بعد',
            progress: badge.unlocked ? 1.0 : 0.0,
          ),
        );
      }).toList(),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final double progress;

  const _AchievementCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withAlpha(8),
            Colors.transparent,
          ],
        ),
        border: Border.all(color: color.withAlpha(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              color: color.withAlpha(20),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(15),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headlineMD),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodyMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.stackMD),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLearningList extends StatelessWidget {
  const _EmptyLearningList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 48,
              color: AppColors.onSurfaceVariant.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.stackMD),
            Text(
              'لم تبدأ أي مسار بعد',
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyPostsTab extends StatefulWidget {
  const _MyPostsTab();

  @override
  State<_MyPostsTab> createState() => _MyPostsTabState();
}

class _MyPostsTabState extends State<_MyPostsTab> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityBloc>().add(CommunityLoadMyPosts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is CommunityMyPostsLoading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is CommunityMyPostsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    state.message,
                    style: AppTypography.bodyMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.stackMD),
                  ElevatedButton(
                    onPressed: () => context
                        .read<CommunityBloc>()
                        .add(CommunityLoadMyPosts()),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is CommunityMyPostsLoaded) {
          final posts = state.posts;
          if (posts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 48,
                      color: AppColors.onSurfaceVariant.withAlpha(100),
                    ),
                    const SizedBox(height: AppSpacing.stackMD),
                    Text(
                      'لم تنشر أي منشور بعد',
                      style: AppTypography.bodyMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Column(
            children: [
              for (final post in posts)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
                  child: _MyPostCard(post: post),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _MyPostCard extends StatelessWidget {
  final PostModel post;

  const _MyPostCard({required this.post});

  String get _typeLabel => switch (post.type) {
        'question' => 'سؤال',
        'discussion' => 'نقاش',
        'achievement' => 'إنجاز',
        'project' => 'مشروع',
        _ => post.type,
      };

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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainerHigh.withAlpha(153),
            AppColors.surfaceContainerHigh.withAlpha(80),
          ],
        ),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.primary.withAlpha(20),
                ),
                child: Text(
                  _typeLabel,
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _timeAgo(post.createdAt),
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          Text(post.title ?? post.body, style: AppTypography.headlineMD),
          if (post.title != null && post.body.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.stackSM),
            Text(
              post.body,
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.stackMD),
          Row(
            children: [
              GestureDetector(
                onTap: () => context.read<CommunityBloc>().add(
                      CommunityMyPostsToggleLike(
                        postId: post.id,
                        isLiked: post.isLikedByMe,
                      ),
                    ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      post.isLikedByMe
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 20,
                      color: post.isLikedByMe
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${post.likesCount}',
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.stackLG),
              Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                '${post.repliesCount}',
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _LearningList extends StatelessWidget {
  final List<UserLearningModel> learning;

  const _LearningList({required this.learning});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: learning.map((l) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryContainer.withAlpha(10),
                  Colors.transparent,
                ],
              ),
              border: Border.all(color: AppColors.primaryContainer.withAlpha(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.school_outlined, size: 20, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.stackSM),
                    Expanded(
                      child: Text(l.title, style: AppTypography.headlineMD),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: l.progressPct / 100.0,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${l.lessonsDone}/${l.lessonsTotal} درس',
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
