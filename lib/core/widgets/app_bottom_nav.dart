import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/community/community_screen.dart';
import '../../features/challenges/challenges_screen.dart';

enum NavTab { profile, challenges, community, explore, home }

class AppBottomNav extends StatelessWidget {
  final NavTab currentTab;
  final VoidCallback? onHomeTap;

  const AppBottomNav({super.key, required this.currentTab, this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.containerMargin,
          0,
          AppSpacing.containerMargin,
          16,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withAlpha(30),
                blurRadius: 20,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: BottomAppBar(
              color: AppColors.surface.withAlpha(153),
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.person_outline,
                    label: 'الملف الشخصي',
                    isActive: currentTab == NavTab.profile,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.emoji_events_outlined,
                    label: 'التحديات',
                    isActive: currentTab == NavTab.challenges,
                    onTap: () {
                      if (currentTab != NavTab.challenges) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengesScreen()));
                      }
                    },
                  ),
                  _NavItem(
                    icon: Icons.groups_outlined,
                    label: 'المجتمع',
                    isActive: currentTab == NavTab.community,
                    onTap: () {
                      if (currentTab != NavTab.community) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityScreen()));
                      }
                    },
                  ),
                  _NavItem(
                    icon: Icons.search,
                    label: 'الاستكشاف',
                    isActive: currentTab == NavTab.explore,
                    onTap: () {
                      if (currentTab != NavTab.explore) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen()));
                      }
                    },
                  ),
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'الرئيسية',
                    isActive: currentTab == NavTab.home,
                    onTap: () {
                      if (currentTab != NavTab.home) {
                        if (onHomeTap != null) {
                          onHomeTap!();
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontArabic,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(128),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
