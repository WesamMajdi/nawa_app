import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/repositories/auth_repository.dart';
import 'package:nawa_flutter/core/network/api_exceptions.dart';
import '../reset_password/reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'أدخل بريدك الإلكتروني');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = 'أدخل بريداً إلكترونياً صحيحاً');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final token = await context.read<AuthRepository>().forgotPassword(email);
      if (!mounted) return;
      if (token != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(token: token),
          ),
        );
        return;
      }
      _showMessage(
        'تم إرسال رابط إعادة التعيين إلى بريدك',
        isError: false,
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

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? AppColors.error : AppColors.primaryContainer,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text('نسيت كلمة السر'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.containerMargin),
          children: [
            const SizedBox(height: AppSpacing.stackLG),
            const Icon(
              Icons.lock_reset_rounded,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.stackMD),
            Text(
              'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة السر',
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.stackLG),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurface,
                fontFamily: AppTypography.fontMono,
              ),
              decoration: InputDecoration(
                hintText: 'email@example.com',
                hintStyle: AppTypography.bodyMD.copyWith(
                  color: AppColors.onSurfaceVariant.withAlpha(128),
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
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onSubmitted: (_) => _submit(),
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
                  : const Text('إرسال رابط إعادة التعيين'),
            ),
          ],
        ),
      ),
    );
  }
}
