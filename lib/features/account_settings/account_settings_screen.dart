import 'package:flutter/material.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/helper/extension.dart';
import 'package:nawa_flutter/features/profile/profile_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              left: AppSpacing.containerMargin,
              right: AppSpacing.containerMargin,
              top: 72,
              bottom: AppSpacing.stackLG,
            ),
            children: [
              _ProfileSection(),
              const SizedBox(height: AppSpacing.stackMD),
              const _SettingsLinks(),
              const SizedBox(height: AppSpacing.stackMD),
              _ThemeToggle(
                darkMode: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              const SizedBox(height: AppSpacing.stackLG),
              const _LogoutButton(),
              const SizedBox(height: AppSpacing.stackMD),
              Text(
                'Nawah v2.4.1 (Build 8902)',
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.onSurfaceVariant.withAlpha(128),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          _TopBar(),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(153),
        border: Border(
          bottom: BorderSide(color: AppColors.onSurfaceVariant.withAlpha(25)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Icon(Icons.arrow_forward, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.stackSM),
          Text(
            'الإعدادات',
            style: AppTypography.headlineMD.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(const ProfileScreen()),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          color: AppColors.surfaceContainerHigh.withAlpha(153),
          border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariant,
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDeFueL4009Sb_zQzuhT7kKNtwZjjtilZgjCaGGFwWtmO5go5If2TaQaS9sNUBCPwl4Qq2aZLncH3hhJx28ZBepmu43ldPaXvAOe-lOBbopaptuE1rMVgn6bsNtyyeFzQD_ncMJS2mltQnUlimNgzbj2P0Qh1oQOzC3Cxuo38RoLh8lsqyJ8o2BqMHU-OkiNTAlyW3ZOXkSSpuDhXUwXXizyouX_uVQ5ThSHIKll1FxSmogbiGCFQ3CBW11uq6I0v7cLcVzAtE2rw',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.person, size: 32, color: AppColors.onSurfaceVariant),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('أحمد مطور', style: AppTypography.headlineMD),
                  Text(
                    'ahmed@nawah.dev',
                    style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _SettingsLinks extends StatelessWidget {
  const _SettingsLinks();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.person,
            title: 'تعديل الملف الشخصي',
            hasDivider: true,
            onTap: () => context.push(const ProfileScreen()),
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'تفضيلات الإشعارات',
            hasDivider: true,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.palette_outlined,
            title: 'اللغة والمظهر',
            hasDivider: true,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.lock_outline,
            title: 'الخصوصية',
            hasDivider: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool hasDivider;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.hasDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant.withAlpha(128),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(
            title,
            style: AppTypography.bodyLG,
          ),
          trailing: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
        ),
        if (hasDivider)
          Divider(
            height: 1,
            indent: 72,
            color: AppColors.onSurfaceVariant.withAlpha(25),
          ),
      ],
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onChanged;

  const _ThemeToggle({required this.darkMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant.withAlpha(128),
            ),
            child: const Icon(Icons.dark_mode, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المظهر الداكن', style: AppTypography.bodyLG),
                Text(
                  'تفعيل المظهر الداكن كافتراضي',
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: darkMode,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.surfaceContainerHigh,
              title: Text(
                'تسجيل الخروج',
                style: AppTypography.headlineMD.copyWith(color: AppColors.error),
              ),
              content: Text(
                'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                style: AppTypography.bodyMD.copyWith(color: AppColors.onSurface),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'إلغاء',
                    style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.pushAndRemoveUntil(const AccountSettingsScreen());
                  },
                  child: Text(
                    'تسجيل الخروج',
                    style: AppTypography.bodyMD.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.error, size: 20),
            const SizedBox(width: AppSpacing.stackSM),
            Text(
              'تسجيل الخروج',
              style: AppTypography.headlineMD.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}
