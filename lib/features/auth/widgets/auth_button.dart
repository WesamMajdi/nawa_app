import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AuthButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryContainer.withAlpha(30),
              blurRadius: 30,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF12B886),
            foregroundColor: const Color(0xFF15141B),
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
          child: Text(label),
        ),
      ),
    );
  }
}
