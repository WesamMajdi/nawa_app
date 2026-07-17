import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import 'widgets/progress_ring.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildBody(),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: AppSpacing.unit,
        bottom: 100,
      ),
      children: [
        const _TopBar(),
        const SizedBox(height: AppSpacing.stackLG),
        const _GreetingHeader(),
        const SizedBox(height: AppSpacing.gutter),
        const _CurrentPathCard(),
        const SizedBox(height: AppSpacing.gutter),
        const _StatsGrid(),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.onSurface,
          onPressed: () {},
        ),
        const Spacer(),
        Text(
          'نواة',
          style: AppTypography.headlineLG.copyWith(color: AppColors.primary),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.menu),
          color: AppColors.onSurface,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StreakCounter(),
        const SizedBox(width: AppSpacing.stackSM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً بعودتك',
                style: AppTypography.bodyMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                'أهلاً بك، أحمد',
                style: AppTypography.headlineXL,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StreakCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: [
          _PulsingFire(),
          const SizedBox(width: 6),
          Text(
            '12',
            style: AppTypography.headlineMD.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingFire extends StatefulWidget {
  @override
  State<_PulsingFire> createState() => _PulsingFireState();
}

class _PulsingFireState extends State<_PulsingFire>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(51),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          Icons.local_fire_department_rounded,
          color: const Color(0xFFFF6B35),
          size: 24,
        ),
      ),
    );
  }
}

class _CurrentPathCard extends StatelessWidget {
  const _CurrentPathCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withAlpha(25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withAlpha(12),
            Colors.white.withAlpha(0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withAlpha(30),
            blurRadius: 30,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.stackLG),
        child: Column(
          children: [
            const ProgressRing(progress: 0.65, size: 128),
            const SizedBox(height: AppSpacing.stackMD),
            Row(
              children: [
                Text(
                  'الدرس 12 من 18',
                  style: AppTypography.codeSM.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withAlpha(38),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'المسار الحالي',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackSM),
            Text(
              'تطوير تطبيقات Flutter',
              style: AppTypography.headlineLG,
            ),
            const SizedBox(height: AppSpacing.stackSM),
            Text(
              'تعلم كيفية بناء واجهات مستخدم معقدة وإدارة حالة التطبيق باستخدام Provider.',
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.stackMD),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surfaceContainerLowest,
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
                child: const Text('أكمل التعلم'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatCard(
              icon: Icons.star_rounded,
              iconColor: AppColors.primary,
              label: 'نقاط الخبرة',
              value: '2,450 XP',
            )),
            SizedBox(width: AppSpacing.gutter),
            Expanded(child: _StatCard(
              icon: Icons.task_alt_rounded,
              iconColor: AppColors.secondary,
              label: 'الدروس المكتملة',
              value: '48',
            )),
          ],
        ),
        SizedBox(height: AppSpacing.gutter),
        Row(
          children: [
            Expanded(child: SizedBox.shrink()),
            SizedBox(width: AppSpacing.gutter),
            Expanded(child: _StatCard(
              icon: Icons.emoji_events_rounded,
              iconColor: AppColors.tertiary,
              label: 'التحديات الفائزة',
              value: '7',
            )),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withAlpha(25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withAlpha(12),
            Colors.white.withAlpha(0),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppTypography.headlineLG,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.stackMD),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ],
        ),
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
                    icon: Icons.emoji_events_outlined,
                    label: 'التحديات',
                    isActive: false,
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
                    isActive: true,
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
                color:
                    isActive ? AppColors.primary : AppColors.onSurfaceVariant,
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
