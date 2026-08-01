import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/models/user_model.dart';
import 'package:nawa_flutter/core/models/user_models.dart';
import 'package:nawa_flutter/core/repositories/user_repository.dart';
import 'package:nawa_flutter/core/widgets/app_bottom_nav.dart';
import 'package:nawa_flutter/core/widgets/app_drawer.dart';
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
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error!, style: AppTypography.bodyMD),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          else
            _buildBody(),
          const _TopBar(),
          AppBottomNav(currentTab: NavTab.profile),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final user = _user!;
    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: 72,
        bottom: 100,
      ),
      children: [
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
        else
          const SizedBox.shrink(),
        const SizedBox(height: 24),
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
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white.withAlpha(12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        elevation: 0,
                        textStyle: AppTypography.headlineMD,
                      ).copyWith(
                        shadowColor: WidgetStateProperty.all(Colors.transparent),
                        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: const Text('تعديل'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.gutter),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primaryContainer),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        textStyle: AppTypography.headlineMD,
                      ),
                      child: const Icon(Icons.share, size: 20),
                    ),
                  ),
                ],
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
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryContainer, width: 2),
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
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer,
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
          fontSize: 36,
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
    return Row(
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
        const SizedBox(width: AppSpacing.gutter),
        Expanded(
          child: _StatItem(
            icon: Icons.terminal,
            color: AppColors.tertiaryContainer,
            value: '$xp',
            label: 'XP',
          ),
        ),
        const SizedBox(width: AppSpacing.gutter),
        Expanded(
          child: _StatItem(
            icon: Icons.workspace_premium,
            color: AppColors.primaryFixedDim,
            value: '$achievementsCount',
            label: 'إنجازات',
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppSpacing.stackSM),
          Text(value, style: AppTypography.headlineLG),
          Text(
            label,
            style: AppTypography.labelMD.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TabSection extends StatelessWidget {
  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const _TabSection({
    required this.tabs,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceVariant),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = i == selectedTab;
          return GestureDetector(
            onTap: () => onTabChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: isSelected
                  ? const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    )
                  : null,
              child: Text(
                tabs[i],
                style: AppTypography.headlineMD.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
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
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              color: color.withAlpha(25),
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
              color: AppColors.surfaceContainerHigh.withAlpha(153),
              border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.title, style: AppTypography.headlineMD),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: l.progressPct / 100.0,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 4),
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
