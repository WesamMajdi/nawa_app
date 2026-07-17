import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 128,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress),
        child: Center(
          child: Text(
            '${(progress * 100).round()}%',
            style: AppTypography.headlineLG.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 8.0;

    final bgPaint = Paint()
      ..color = AppColors.surfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arc = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arc,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
