import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/repositories/auth_repository.dart';
import 'package:nawa_flutter/core/network/api_exceptions.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? token;

  const ResetPasswordScreen({super.key, this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      _tokenController.text = widget.token!;
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = _tokenController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (token.isEmpty) {
      setState(() => _error = 'أدخل رمز إعادة التعيين');
      return;
    }
    if (password.length < 8) {
      setState(() => _error = 'كلمة السر يجب ألا تقل عن 8 أحرف');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'كلمتا السر غير متطابقتين');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await context.read<AuthRepository>().resetPassword(
            token: token,
            password: password,
          );
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تغيير كلمة السر بنجاح، سجّل الدخول الآن'),
          backgroundColor: AppColors.primaryContainer,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text('إعادة تعيين كلمة السر'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          children: [
            const SizedBox(height: AppSpacing.stackLG),
            const Icon(
              Icons.password_rounded,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.stackMD),
            Text(
              'أدخل رمز إعادة التعيين وكلمة السر الجديدة',
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.stackLG),
            TextField(
              controller: _tokenController,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurface,
                fontFamily: AppTypography.fontMono,
                fontSize: 14,
              ),
              decoration: _inputDecoration(
                hint: 'رمز إعادة التعيين',
                prefix: Icons.vpn_key_rounded,
              ),
            ),
            const SizedBox(height: AppSpacing.gutter),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurface,
                fontFamily: AppTypography.fontMono,
              ),
              decoration: _inputDecoration(
                hint: 'كلمة السر الجديدة (8 أحرف على الأقل)',
                prefix: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () => setState(
                    () => _obscurePassword = !_obscurePassword,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.gutter),
            TextField(
              controller: _confirmController,
              obscureText: _obscureConfirm,
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurface,
                fontFamily: AppTypography.fontMono,
              ),
              decoration: _inputDecoration(
                hint: 'تأكيد كلمة السر',
                prefix: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirm = !_obscureConfirm,
                  ),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.stackMD),
              Text(
                _error!,
                style: AppTypography.bodyMD.copyWith(
                  color: AppColors.error,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.stackLG),
            ElevatedButton(
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
                  : const Text('حفظ كلمة السر الجديدة'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMD.copyWith(
        color: AppColors.onSurfaceVariant.withAlpha(128),
      ),
      prefixIcon: Icon(prefix, color: AppColors.onSurfaceVariant),
      suffixIcon: suffix,
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
    );
  }
}
