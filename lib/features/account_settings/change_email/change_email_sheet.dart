import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/repositories/user_repository.dart';
import 'package:nawa_flutter/core/network/api_exceptions.dart';

class ChangeEmailSheet extends StatefulWidget {
  const ChangeEmailSheet({super.key});

  @override
  State<ChangeEmailSheet> createState() => _ChangeEmailSheetState();
}

class _ChangeEmailSheetState extends State<ChangeEmailSheet> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final newEmail = _emailController.text.trim();
    if (!newEmail.contains('@') || !newEmail.contains('.')) {
      setState(() => _error = 'أدخل بريداً إلكترونياً صحيحاً');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _error = 'أدخل كلمة السر الحالية للتأكيد');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await context.read<UserRepository>().changeEmail(
            newEmail: newEmail,
            currentPassword: _passwordController.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم تغيير البريد بنجاح، يرجى التحقق من بريدك الجديد',
          ),
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
          Text('تغيير البريد الإلكتروني', style: AppTypography.headlineLG),
          const SizedBox(height: AppSpacing.stackSM),
          Text(
            'سيصبح البريد الجديد بحاجة إلى تحقق',
            style: AppTypography.bodyMD.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.stackLG),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            style: AppTypography.bodyMD.copyWith(
              color: AppColors.onSurface,
              fontFamily: AppTypography.fontMono,
            ),
            decoration: InputDecoration(
              hintText: 'new@example.com',
              hintStyle: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurfaceVariant.withAlpha(128),
              ),
              prefixIcon: const Icon(
                Icons.alternate_email,
                color: AppColors.onSurfaceVariant,
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
          ),
          const SizedBox(height: AppSpacing.gutter),
          TextField(
            controller: _passwordController,
            obscureText: _obscure,
            style: AppTypography.bodyMD.copyWith(
              color: AppColors.onSurface,
              fontFamily: AppTypography.fontMono,
            ),
            decoration: InputDecoration(
              hintText: 'كلمة السر الحالية',
              hintStyle: AppTypography.bodyMD.copyWith(
                color: AppColors.onSurfaceVariant.withAlpha(128),
              ),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.onSurfaceVariant),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
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
                  : const Text('تغيير البريد'),
            ),
          ),
        ],
      ),
    );
  }
}
