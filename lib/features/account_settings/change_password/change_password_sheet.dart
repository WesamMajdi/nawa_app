import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/repositories/auth_repository.dart';
import 'package:nawa_flutter/core/network/api_exceptions.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final current = _currentController.text;
    final newPassword = _newController.text;
    final confirm = _confirmController.text;

    if (current.isEmpty) {
      setState(() => _error = 'أدخل كلمة السر الحالية');
      return;
    }
    if (newPassword.length < 8) {
      setState(() => _error = 'كلمة السر الجديدة يجب ألا تقل عن 8 أحرف');
      return;
    }
    if (newPassword != confirm) {
      setState(() => _error = 'كلمتا السر غير متطابقتين');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await context.read<AuthRepository>().changePassword(
            currentPassword: current,
            newPassword: newPassword,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تغيير كلمة السر بنجاح'),
          backgroundColor: AppColors.primaryContainer,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is ApiException
          ? e.toUserMessage()
          : 'حدث خطأ غير متوقع';
      setState(() {
        _error = message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: 24,
        bottom: MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تغيير كلمة المرور', style: AppTypography.headlineLG),
          const SizedBox(height: AppSpacing.stackSM),
          Text(
            'بعد التغيير ستُسجّل الخروج من باقي الأجهزة',
            style: AppTypography.bodyMD.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.stackLG),
          _PasswordField(
            controller: _currentController,
            obscure: _obscure,
            onToggle: () => setState(() => _obscure = !_obscure),
            hint: 'كلمة السر الحالية',
          ),
          const SizedBox(height: AppSpacing.gutter),
          _PasswordField(
            controller: _newController,
            obscure: _obscure,
            onToggle: () => setState(() => _obscure = !_obscure),
            hint: 'كلمة السر الجديدة',
          ),
          const SizedBox(height: AppSpacing.gutter),
          _PasswordField(
            controller: _confirmController,
            obscure: _obscure,
            onToggle: () => setState(() => _obscure = !_obscure),
            hint: 'تأكيد كلمة السر الجديدة',
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.stackMD),
            Text(
              _error!,
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.error,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.stackLG),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                elevation: 0,
                textStyle: AppTypography.headlineMD,
              ).copyWith(
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.background,
                      ),
                    )
                  : const Text('تغيير كلمة السر'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String hint;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: AppTypography.bodyMD.copyWith(
        color: AppColors.onSurface,
        fontFamily: AppTypography.fontMono,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMD.copyWith(
          color: AppColors.onSurfaceVariant.withAlpha(128),
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.onSurfaceVariant),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
