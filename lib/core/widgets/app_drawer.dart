import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nawa_flutter/core/constants/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Text(
                'نواة',
                style: AppTypography.headlineLG.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('الرئيسية'),
              onTap: () {
                Navigator.pop(context);
                context.go('/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('التحديات'),
              onTap: () {
                Navigator.pop(context);
                context.go('/challenges');
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('المجتمع'),
              onTap: () {
                Navigator.pop(context);
                context.go('/community');
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('الاستكشاف'),
              onTap: () {
                Navigator.pop(context);
                context.go('/explore');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('الملف الشخصي'),
              onTap: () {
                Navigator.pop(context);
                context.go('/profile');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('المتصدرين'),
              onTap: () {
                Navigator.pop(context);
                context.go('/leaderboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('الإشعارات'),
              onTap: () {
                Navigator.pop(context);
                context.go('/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('الشهادات والمتجر'),
              onTap: () {
                Navigator.pop(context);
                context.go('/certificates-store');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('الإعدادات'),
              onTap: () {
                Navigator.pop(context);
                context.go('/account-settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
