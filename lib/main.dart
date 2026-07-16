import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() {
  runApp(const NawahApp());
}

class NawahApp extends StatelessWidget {
  const NawahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نواة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const OnboardingScreen(),
    );
  }
}
