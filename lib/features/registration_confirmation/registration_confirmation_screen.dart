import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class RegistrationConfirmationScreen extends StatefulWidget {
  const RegistrationConfirmationScreen({super.key});

  @override
  State<RegistrationConfirmationScreen> createState() =>
      _RegistrationConfirmationScreenState();
}

class _RegistrationConfirmationScreenState
    extends State<RegistrationConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _celebrationScale;
  late Animation<Offset> _celebrationSlide;
  late Animation<double> _messageFade;
  late Animation<Offset> _messageSlide;
  late Animation<double> _progressFade;
  late Animation<Offset> _progressSlide;
  late Animation<double> _stepFade;
  late Animation<Offset> _stepSlide;
  late Animation<double> _ctaFade;
  late Animation<Offset> _ctaSlide;
  late Animation<double> _checkmarkDraw;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _celebrationScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.elasticOut),
    );
    _celebrationSlide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );
    _checkmarkDraw = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.05, 0.3, curve: Curves.easeInOut),
    );
    _messageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
    );
    _messageSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );
    _progressFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
    );
    _progressSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );
    _stepFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
    );
    _stepSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );
    _ctaFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 0.95, curve: Curves.easeIn),
    );
    _ctaSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 0.95, curve: Curves.easeOut),
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _generateConfetti();
    _controller.forward();
  }

  void _generateConfetti() {
    final rng = Random(42);
    _particles = List.generate(40, (_) {
      final angle = rng.nextDouble() * pi * 2;
      final speed = 60 + rng.nextDouble() * 120;
      return _ConfettiParticle(
        x: cos(angle) * speed,
        y: sin(angle) * speed,
        size: 4 + rng.nextDouble() * 6,
        color: [
          const Color(0xFF12B886),
          const Color(0xFF50DEA9),
          const Color(0xFF00AC69),
          Colors.white,
        ][rng.nextInt(4)],
        rotation: rng.nextDouble() * pi * 2,
        rotationSpeed: -3 + rng.nextDouble() * 6,
        delay: rng.nextDouble() * 0.15,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return RepaintBoundary(
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.containerMargin,
                    right: AppSpacing.containerMargin,
                    top: 88,
                    bottom: 140,
                  ),
                  children: [
                    _buildCelebrationArea(),
                    const SizedBox(height: AppSpacing.stackMD),
                    _buildSuccessMessage(),
                    const SizedBox(height: AppSpacing.gutter),
                    _buildProgressCard(),
                    const SizedBox(height: AppSpacing.gutter),
                    _buildFirstStepCard(),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            },
          ),
          _buildConfettiOverlay(),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildCelebrationArea() {
    return SlideTransition(
      position: _celebrationSlide,
      child: ScaleTransition(
        scale: _celebrationScale,
        child: Center(
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
                  child: CustomPaint(
                    painter: _CheckmarkPainter(
                      progress: _checkmarkDraw.value,
                      color: AppColors.primary,
                      strokeWidth: 4,
                    ),
                    size: const Size(48, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return SlideTransition(
      position: _messageSlide,
      child: FadeTransition(
        opacity: _messageFade,
        child: Column(
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
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return SlideTransition(
      position: _progressSlide,
      child: FadeTransition(
        opacity: _progressFade,
        child: DecoratedBox(
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
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.02 * _controller.value.clamp(0.4, 1.0),
                      child: const DecoratedBox(
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
        ),
      ),
    );
  }

  Widget _buildFirstStepCard() {
    return SlideTransition(
      position: _stepSlide,
      child: FadeTransition(
        opacity: _stepFade,
        child: DecoratedBox(
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
        ),
      ),
    );
  }

  Widget _buildConfettiOverlay() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildBottomCTA() {
    return SlideTransition(
      position: _ctaSlide,
      child: FadeTransition(
        opacity: _ctaFade,
        child: Align(
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
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CheckmarkPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w * 0.15, h * 0.5);
    path.lineTo(w * 0.42, h * 0.78);
    path.lineTo(w * 0.88, h * 0.22);

    final metrics = path.computeMetrics();
    final totalLength =
        metrics.fold(0.0, (sum, m) => sum + m.length);
    final drawLength = totalLength * progress;

    for (final metric in metrics) {
      if (drawLength <= 0) break;
      final extractLength = drawLength < metric.length
          ? drawLength
          : metric.length;
      final segment = metric.extractPath(0, extractLength);
      canvas.drawPath(segment, paint);
    }
  }

  @override
  bool shouldRepaint(_CheckmarkPainter old) =>
      old.progress != progress || old.color != color;
}

class _ConfettiParticle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double rotation;
  final double rotationSpeed;
  final double delay;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.delay,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 200);

    for (final p in particles) {
      final t = ((progress - p.delay) / (1.0 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final eased = 1 - pow(1 - t, 3);
      final opacity = (1 - t).clamp(0.0, 1.0);

      final dx = p.x * eased;
      final dy = p.y * eased + 60 * eased * eased;
      final rotation = p.rotation + p.rotationSpeed * t;

      canvas.save();
      canvas.translate(center.dx + dx, center.dy + dy);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = p.color.withAlpha((255 * opacity).round())
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          const Radius.circular(1),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
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
