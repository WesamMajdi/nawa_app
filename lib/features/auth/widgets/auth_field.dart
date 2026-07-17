import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';

class AuthField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final Widget? suffix;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const AuthField({
    super.key,
    required this.label,
    this.hint,
    required this.prefixIcon,
    this.suffix,
    this.obscure = false,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMD.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.stackSM),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: const Color(0xFF76727F)),
            color: const Color(0xFF1E1C29),
          ),
          child: Focus(
            child: Builder(builder: (context) {
              final focused = Focus.of(context).hasFocus;
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: focused
                      ? Border.all(color: AppColors.primaryContainer, width: 1.5)
                      : null,
                  boxShadow: focused
                      ? [
                          BoxShadow(
                            color: AppColors.primaryContainer.withAlpha(51),
                            blurRadius: 12,
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: Icon(
                        prefixIcon,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        obscureText: obscure,
                        keyboardType: keyboardType,
                        style: AppTypography.codeSM.copyWith(
                          color: AppColors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: AppTypography.codeSM.copyWith(
                            color: AppColors.onSurfaceVariant.withAlpha(128),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 4,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    if (suffix != null) Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: suffix,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
