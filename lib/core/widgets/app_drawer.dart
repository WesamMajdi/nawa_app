import 'package:flutter/material.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/helper/extension.dart';
import 'package:nawa_flutter/features/certificates_store/certificates_store_screen.dart';
import 'package:nawa_flutter/features/challenges/challenges_screen.dart';
import 'package:nawa_flutter/features/community/community_screen.dart';
import 'package:nawa_flutter/features/explore/explore_screen.dart';
import 'package:nawa_flutter/features/home/dashboard_screen.dart';
import 'package:nawa_flutter/features/notifications/notifications_screen.dart';
import 'package:nawa_flutter/features/profile/profile_screen.dart';

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
                context.pushReplacement(const DashboardScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: const Text('التحديات'),
              onTap: () {
                Navigator.pop(context);
                context.pushReplacement(const ChallengesScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('المجتمع'),
              onTap: () {
                Navigator.pop(context);
                context.pushReplacement(const CommunityScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('الاستكشاف'),
              onTap: () {
                Navigator.pop(context);
                context.pushReplacement(const ExploreScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('الملف الشخصي'),
              onTap: () {
                Navigator.pop(context);
                context.pushReplacement(const ProfileScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('الإشعارات'),
              onTap: () {
                Navigator.pop(context);
                context.push(const NotificationsScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('الشهادات والمتجر'),
              onTap: () {
                Navigator.pop(context);
                context.push(const CertificatesStoreScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
