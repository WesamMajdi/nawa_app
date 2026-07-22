import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _Header(),
              const SizedBox(height: AppSpacing.stackLG),
              _CategoryChips(),
              const SizedBox(height: AppSpacing.stackLG),
              const _FeaturedChallenge(),
              const SizedBox(height: AppSpacing.stackLG),
              const _UpcomingChallenges(),
            ],
          ),
          const _TopBar(),
          const _BottomNav(),
        ],
      ),
      floatingActionButton: const _Fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: AppColors.onSurface),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
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
        Text(
          'التحديات والمسابقات',
          style: AppTypography.headlineXL,
        ),
        const SizedBox(height: AppSpacing.stackSM),
        Text(
          'اختبر مهاراتك، تنافس مع أفضل المطورين، واربح جوائز قيمة.',
          style: AppTypography.bodyMD.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(
            icon: Icons.local_fire_department,
            label: 'تحديات برمجية',
            isActive: true,
          ),
          const SizedBox(width: AppSpacing.gutter),
          const _Chip(label: 'هاكاثون', isActive: false),
          const SizedBox(width: AppSpacing.gutter),
          const _Chip(label: 'مسابقات سريعة', isActive: false),
        ],
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
        color: isActive
            ? AppColors.primaryContainer.withAlpha(38)
            : AppColors.surfaceContainer.withAlpha(128),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: isActive
              ? AppColors.primaryContainer.withAlpha(77)
              : AppColors.outlineVariant.withAlpha(77),
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

class _FeaturedChallenge extends StatelessWidget {
  const _FeaturedChallenge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainer.withAlpha(102),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primaryContainer.withAlpha(25),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Badge(
                icon: Icons.timer,
                label: 'ينتهي قريباً',
                color: AppColors.error,
                bgColor: AppColors.errorContainer,
              ),
              const Spacer(),
              _Badge(
                icon: Icons.military_tech,
                label: 'متقدم',
                color: AppColors.primary,
                bgColor: AppColors.surfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          Text(
            'تحدي خوارزميات الذكاء الاصطناعي',
            style: AppTypography.headlineMD,
          ),
          const SizedBox(height: AppSpacing.stackSM),
          Text(
            'قم ببناء نموذج تعلم آلي لتوقع أنماط استهلاك البيانات بكفاءة عالية مستخدماً بايثون.',
            style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.stackMD),
          const Divider(color: AppColors.outlineVariant, height: 1),
          const SizedBox(height: AppSpacing.stackMD),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.groups, size: 20, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.stackSM),
                  Text(
                    '١,٢٤٥ مشارك',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.gutter),
              Container(width: 1, height: 16, color: AppColors.outlineVariant.withAlpha(128)),
              const SizedBox(width: AppSpacing.gutter),
              Row(
                children: [
                  const Icon(Icons.emoji_events, size: 20, color: AppColors.secondary),
                  const SizedBox(width: AppSpacing.stackSM),
                  Text(
                    '٥٠٠٠ نقطة خبرة',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.secondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          _CountdownTimer(),
          const SizedBox(height: AppSpacing.stackMD),
          SizedBox(
            width: double.infinity,
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
              child: const Text('انضم للتحدي الآن'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

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
          Text(
            label,
            style: AppTypography.codeSM.copyWith(color: color, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CountdownTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.surfaceDim,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TimeUnit(value: '02', label: 'أيام'),
            const Text(':', style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
            _TimeUnit(value: '14', label: 'ساعات'),
            const Text(':', style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
            _TimeUnit(value: '45', label: 'دقائق', isHighlighted: true),
          ],
        ),
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final String value;
  final String label;
  final bool isHighlighted;

  const _TimeUnit({
    required this.value,
    required this.label,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.codeSM.copyWith(
            fontSize: 18,
            color: isHighlighted ? AppColors.primary : AppColors.onSurface,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelMD.copyWith(
            fontSize: 10,
            color: isHighlighted ? AppColors.primary.withAlpha(179) : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _UpcomingChallenges extends StatelessWidget {
  const _UpcomingChallenges();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحديات قادمة',
          style: AppTypography.headlineMD,
        ),
        const SizedBox(height: AppSpacing.stackMD),
        _UpcomingCard(
          icon: Icons.code,
          title: 'تحدي بناء واجهة برمجة (API)',
          level: 'متوسط',
          levelIcon: Icons.military_tech,
          reward: 'شارة معمار',
          rewardColor: AppColors.secondary,
          time: 'يبدأ بعد يومين',
        ),
        const SizedBox(height: AppSpacing.gutter),
        _UpcomingCard(
          icon: Icons.bug_report,
          title: 'صيد الثغرات الأمنية',
          level: 'خبير',
          levelIcon: Icons.military_tech,
          reward: '١٠٠٠ XP',
          rewardColor: AppColors.secondary,
          time: 'يبدأ بعد أسبوع',
        ),
      ],
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String level;
  final IconData levelIcon;
  final String reward;
  final Color rewardColor;
  final String time;

  const _UpcomingCard({
    required this.icon,
    required this.title,
    required this.level,
    required this.levelIcon,
    required this.reward,
    required this.rewardColor,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainer.withAlpha(77),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              color: AppColors.surfaceVariant,
              border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headlineMD.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(levelIcon, size: 14, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          level,
                          style: AppTypography.labelMD.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.gutter),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events, size: 14, color: rewardColor.withAlpha(204)),
                        const SizedBox(width: 4),
                        Text(
                          reward,
                          style: AppTypography.labelMD.copyWith(
                            color: rewardColor.withAlpha(204),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTypography.codeSM.copyWith(
              color: AppColors.onSurfaceVariant,
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
            color: AppColors.primaryContainer.withAlpha(102),
            blurRadius: 20,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.leaderboard, color: AppColors.background, size: 28),
        onPressed: () {},
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.containerMargin,
          0,
          AppSpacing.containerMargin,
          16,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withAlpha(30),
                blurRadius: 20,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: BottomAppBar(
              color: AppColors.surface.withAlpha(153),
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.person_outline,
                    label: 'الملف الشخصي',
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.leaderboard,
                    label: 'التحديات',
                    isActive: true,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.groups_outlined,
                    label: 'المجتمع',
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.search,
                    label: 'الاستكشاف',
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'الرئيسية',
                    isActive: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontArabic,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(128),
                      blurRadius: 8,
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
