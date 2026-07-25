import 'package:flutter/material.dart';
import 'package:nawa_flutter/core/constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  final _tabs = ['إنجازاتي', 'مساراتي', 'منشوراتي'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              left: AppSpacing.containerMargin,
              right: AppSpacing.containerMargin,
              top: 72,
              bottom: 100,
            ),
            children: [
              const _ProfileHeader(),
              const SizedBox(height: AppSpacing.stackLG),
              const _StatsGrid(),
              const SizedBox(height: AppSpacing.stackLG),
              _TabSection(
                tabs: _tabs,
                selectedTab: _selectedTab,
                onTabChanged: (i) => setState(() => _selectedTab = i),
              ),
              const SizedBox(height: AppSpacing.gutter),
              const _AchievementsList(),
              const SizedBox(height: 24),
            ],
          ),
          const _TopBar(),
          const _BottomNav(),
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
                onTap: () {},
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
                onTap: () {},
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
  const _ProfileHeader();

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
                  _AvatarSection(),
                  const SizedBox(width: AppSpacing.stackMD),
                  Expanded(child: _UserInfo()),
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
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBsCFhP-YWecHirccA5vUog_GViK9EnNCNRhVSyDAoVnAHJNJ_zNH2sM6Kob_Jspr58UA_OfSHIZZ0L0O8QAGa2gyMkYXYTKcmmQ3G4n2b8h5iEn-EF7TlmjI2l8qbXN4AbkTOHID08xjUL4WDkH90t9Tw9z5TjUSahupTNJUAxo1rks6jo3XHTol-UMVvWgvdySuSea5r1bx1t4_u5GfmOgbZg1Rzdt9wVwegbRka5ILnIGRZCa61puaTrdFNKeODVRIwEsXN0Aw',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceContainerHigh,
                child: const Icon(Icons.person, size: 48, color: AppColors.onSurfaceVariant),
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
              color: AppColors.primaryContainer,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
            child: const Icon(Icons.code, size: 16, color: AppColors.background),
          ),
        ),
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أحمد عبدالله',
          style: AppTypography.headlineXL.copyWith(color: AppColors.primaryFixed),
        ),
        const SizedBox(height: 4),
        Text(
          '@ahmed_dev • Full Stack Engineer',
          style: AppTypography.labelMD.copyWith(
            color: AppColors.onSurfaceVariant,
            fontFamily: AppTypography.fontMono,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.stackMD),
        Text(
          'مطور مهتم بتقنيات الويب الحديثة والذكاء الاصطناعي. أبني تطبيقات عالية الأداء وأساهم في المصادر المفتوحة.',
          style: AppTypography.bodyMD.copyWith(
            color: AppColors.onSurface.withAlpha(204),
          ),
        ),
        const SizedBox(height: AppSpacing.stackMD),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TechTag(label: 'Python'),
            _TechTag(label: 'React'),
            _TechTag(label: 'Flutter'),
          ],
        ),
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
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.gutter,
      crossAxisSpacing: AppSpacing.gutter,
      childAspectRatio: 0.85,
      children: const [
        _StatItem(icon: Icons.military_tech, color: AppColors.primary, value: 'Lv. 42', label: 'المستوى'),
        _StatItem(icon: Icons.local_fire_department, color: AppColors.secondary, value: '14', label: 'يوم متتالي'),
        _StatItem(icon: Icons.terminal, color: AppColors.tertiaryContainer, value: '8,450', label: 'نقاط الخبرة (XP)'),
        _StatItem(icon: Icons.workspace_premium, color: AppColors.primaryFixedDim, value: '7', label: 'إنجازات'),
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
  const _AchievementsList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AchievementCard(
          icon: Icons.bug_report,
          color: AppColors.primary,
          title: 'صائد الثغرات الأول',
          subtitle: 'حل 50 تحدي في أمن المعلومات.',
          progress: 1.0,
        ),
        SizedBox(height: AppSpacing.gutter),
        _AchievementCard(
          icon: Icons.rocket_launch,
          color: AppColors.secondary,
          title: 'مُطلق المشاريع',
          subtitle: 'إكمال 5 مسارات برمجية كاملة.',
          progress: 0.8,
        ),
      ],
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

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withAlpha(102),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryContainer.withAlpha(30),
              blurRadius: 20,
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.person, label: 'الملف الشخصي', isActive: true),
            _NavItem(icon: Icons.emoji_events, label: 'التحديات', isActive: false),
            _NavItem(icon: Icons.groups, label: 'المجتمع', isActive: false),
            _NavItem(icon: Icons.search, label: 'الاستكشاف', isActive: false),
            _NavItem(icon: Icons.home, label: 'الرئيسية', isActive: false),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.onSurfaceVariant;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelMD.copyWith(
            color: color,
            fontSize: 10,
          ),
        ),
        if (isActive) ...[
          const SizedBox(height: 2),
          Container(
            width: 4,
            height: 4,
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
        ],
      ],
    );
  }
}
