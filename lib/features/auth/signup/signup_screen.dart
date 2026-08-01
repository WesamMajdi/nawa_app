import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/auth/auth_bloc.dart';
import '../../../core/constants/constants.dart';
import '../../../core/helper/extension.dart';
import '../../home/dashboard_screen.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    super.initState();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    final authBloc = context.read<AuthBloc>();
    _authSubscription = authBloc.stream.listen((state) {
      if (!mounted) return;
      if (state is AuthAuthenticated) {
        setState(() => _isLoading = false);
        context.pushAndRemoveUntil(const DashboardScreen());
      } else if (state is AuthError) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      } else if (state is AuthLoading) {
        setState(() => _isLoading = true);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pop(context);
  }

  void _signup() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة المرور غير متطابقة')),
      );
      return;
    }

    context.read<AuthBloc>().add(AuthRegisterRequested(name: name, email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.containerMargin),
            child: Column(
              children: [
                Text(
                  'نواة',
                  style: AppTypography.headlineXL.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.stackLG),
                _buildCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
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
            color: AppColors.primaryContainer.withAlpha(12),
            blurRadius: 30,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.stackLG),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'إنشاء حساب جديد',
                style: AppTypography.headlineLG,
              ),
              const SizedBox(height: AppSpacing.stackSM),
              Text(
                'انضم إلى مجتمع المبرمجين العرب',
                style: AppTypography.bodyMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.stackMD),
              AuthField(
                label: 'الاسم الكامل',
                hint: 'أحمد محمد',
                prefixIcon: Icons.person_outline_rounded,
                controller: _nameController,
              ),
              const SizedBox(height: AppSpacing.stackMD),
              AuthField(
                label: 'البريد الإلكتروني',
                hint: 'developer@example.com',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: AppSpacing.stackMD),
              AuthField(
                label: 'كلمة المرور',
                prefixIcon: Icons.lock_outline_rounded,
                obscure: _obscurePassword,
                controller: _passwordController,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: AppSpacing.stackMD),
              AuthField(
                label: 'تأكيد كلمة المرور',
                prefixIcon: Icons.lock_outline_rounded,
                obscure: _obscureConfirm,
                controller: _confirmPasswordController,
                suffix: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _obscureConfirm = !_obscureConfirm);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: AppSpacing.stackMD),
              AuthButton(
                label: _isLoading ? 'جاري التحميل...' : 'إنشاء حساب',
                onPressed: _isLoading ? null : _signup,
              ),
              const SizedBox(height: AppSpacing.stackMD),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لدي حساب بالفعل؟',
                    style: AppTypography.bodyMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _goToLogin,
                    child: Text(
                      'تسجيل الدخول',
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary.withAlpha(77),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
