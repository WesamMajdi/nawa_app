import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class RegistrationConfirmationScreen extends StatelessWidget {
  const RegistrationConfirmationScreen({super.key});

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
              bottom: 140,
            ),
            children: [
              const _CelebrationArea(),
              const SizedBox(height: AppSpacing.stackMD),
              const _SuccessMessage(),
              const SizedBox(height: AppSpacing.gutter),
              const _ProgressCard(),
              const SizedBox(height: AppSpacing.gutter),
              const _FirstStepCard(),
              const SizedBox(height: 100),
            ],
          ),
          const _BottomCTA(),
        ],
      ),
    );
  }
}

class _CelebrationArea extends StatefulWidget {
  const _CelebrationArea();

  @override
  State<_CelebrationArea> createState() => _CelebrationAreaState();
}

class _CelebrationAreaState extends State<_CelebrationArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 192,
        height: 192,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 192,
                  height: 192,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(51),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(
                          (51 * _pulseAnimation.value).round(),
                        ),
                        blurRadius: 40,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(77),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.primary,
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessMessage extends StatelessWidget {
  const _SuccessMessage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'تم التسجيل بنجاح!',
          style: AppTypography.headlineXL.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.stackSM),
        Text(
          'مرحباً بك في مسار مطور Flutter!',
          style: AppTypography.headlineMD.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.stackSM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'لقد تم انضمامك بنجاح إلى مجتمع مبرمجي المستقبل. رحلتك تبدأ الآن.',
            style: AppTypography.bodyMD.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
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
        padding: const EdgeInsets.all(AppSpacing.stackMD),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'الإنجاز الحالي',
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '0%',
                  style: AppTypography.codeSM.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackSM),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Container(
                height: 8,
                color: AppColors.surfaceContainerLowest,
                child: const FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.02,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(9999)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FirstStepCard extends StatelessWidget {
  const _FirstStepCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
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
        padding: const EdgeInsets.all(AppSpacing.stackMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  'الخطوة الأولى',
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: Colors.white.withAlpha(12)),
                  ),
                  child: const Icon(
                    Icons.play_circle,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الدرس الأول: مقدمة في Flutter',
                        style: AppTypography.headlineMD.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تعرف على تاريخ الإطار، لماذا نستخدمه، وكيفية إعداد بيئة العمل.',
                        style: AppTypography.bodyMD.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _Meta(Icons.schedule, '15 دقيقة'),
                          const SizedBox(width: 12),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.outlineVariant,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _Meta(Icons.movie, 'فيديو'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Meta(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.outline),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.labelMD.copyWith(
            color: AppColors.outline,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _BottomCTA extends StatelessWidget {
  const _BottomCTA();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.containerMargin,
          AppSpacing.stackLG,
          AppSpacing.containerMargin,
          24,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background.withAlpha(0),
              AppColors.background.withAlpha(242),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                elevation: 0,
                textStyle: AppTypography.headlineMD,
              ).copyWith(
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('ابدأ الآن'),
                  SizedBox(width: 8),
                  Icon(Icons.bolt, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
