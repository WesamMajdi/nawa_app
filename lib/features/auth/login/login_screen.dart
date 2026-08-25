import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../core/helper/extension.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_divider.dart';
import '../widgets/social_button.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToSignup() {
    context.push(const SignupScreen());
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
                'تسجيل الدخول',
                style: AppTypography.headlineLG,
              ),
              const SizedBox(height: AppSpacing.stackSM),
              Text(
                'مرحباً بعودتك إلى بيئة التطوير الخاصة بك',
                style: AppTypography.bodyMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.stackMD),
              SocialButton(
                label: 'الدخول بواسطة جوجل',
                icon: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCEAZ3-yc3m9ZGS11xU-OFZjnJtHt-NvIaA4dRpf4DAxyNZlrzI_eqjLOmaEkuDMaQtWke0RBHFNnKy4hmuyAlszqF68Ifv0dvr_uV8Nnsi62dEpJwjoSqYQokA1rtZ2SO-f8nwEZYb4eShyUt6yek_yTwnQhbXW5CC0MaoMx58ApbsRbvZ57ouw5dh0jt-lTmIrxKz-ZHkQFSp76FQCBmtmeXunQVz4_PjTzOmE4JzRkADyGAV1nf73iG5wlW31sGSklnJVKcDMA',
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.stackMD),
              const AuthDivider(),
              const SizedBox(height: AppSpacing.stackMD),
              AuthField(
                label: 'البريد الإلكتروني',
                hint: 'developer@example.com',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: AppSpacing.stackMD),
              AuthField(
                label: 'كلمة المرور',
                prefixIcon: Icons.lock_outline_rounded,
                obscure: _obscurePassword,
                textDirection: TextDirection.ltr,
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
              const SizedBox(height: AppSpacing.stackSM),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'نسيت كلمة السر؟',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.stackSM),
              AuthButton(
                label: 'تسجيل الدخول',
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.stackMD),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ليس لديك حساب؟',
                    style: AppTypography.bodyMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _goToSignup,
                    child: Text(
                      'إنشاء حساب جديد',
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
