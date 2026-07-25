import 'package:flutter/material.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/features/certificates_store/certificates_store_screen.dart';
import 'package:nawa_flutter/features/notifications/notifications_screen.dart';

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
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('التحديات'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('المجتمع'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('الاستكشاف'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('الملف الشخصي'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('الإشعارات'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('الشهادات والمتجر'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CertificatesStoreScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
