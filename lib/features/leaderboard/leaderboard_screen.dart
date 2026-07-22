import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';


class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _isWeekly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              left: AppSpacing.containerMargin,
              right: AppSpacing.containerMargin,
              top: 88,
              bottom: 120,
            ),
            children: [
              _Header(),
              const SizedBox(height: AppSpacing.stackMD),
              _Toggle(isWeekly: _isWeekly, onToggle: _toggle),
              const SizedBox(height: AppSpacing.stackMD),
              const _Podium(),
              const SizedBox(height: AppSpacing.stackMD),
              const _RankedList(),
            ],
          ),
          const _TopBar(),
          const _BottomNav(),
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      _isWeekly = !_isWeekly;
    });
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

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
              child: const Icon(Icons.arrow_forward, color: AppColors.onSurface),
            ),
          ),
          const Spacer(),
          Text(
            'نواة',
            style: AppTypography.headlineLG.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: AppColors.onSurface),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(128),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'لوحة الصدارة',
          style: AppTypography.headlineXL,
        ),
      ],
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool isWeekly;
  final VoidCallback onToggle;

  const _Toggle({required this.isWeekly, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.full),
          color: AppColors.surfaceContainerHigh.withAlpha(153),
          border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              top: 4,
              right: isWeekly ? 4 : null,
              left: isWeekly ? null : 4,
              width: 144,
              height: 36,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withAlpha(77),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: isWeekly ? null : onToggle,
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      child: Text(
                        'أسبوعي',
                        style: AppTypography.labelMD.copyWith(
                          color: isWeekly ? AppColors.background : AppColors.onSurfaceVariant,
                          fontWeight: isWeekly ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: isWeekly ? onToggle : null,
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      child: Text(
                        'شهري',
                        style: AppTypography.labelMD.copyWith(
                          color: !isWeekly ? AppColors.background : AppColors.onSurfaceVariant,
                          fontWeight: !isWeekly ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 256,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 8),
          _PodiumCard(
            place: '2',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAjRLCdGo1EMTjXSWWlWFu3ypKQ_1cL2RpDp-P3S1HgEzQxD_jSEjhs7UA-Gi-F8KHmULNgGURMmF6ksgyzgJZ-vNKIutuXw9vjR-PDAj4scP1uaL1yzw6y27wXT8Wn04Uylvrt8OG1Gtq0UJtelQJA12JVd63uGO584P1495j0fvlm3uLCr9CHEyuMDaadvV0BBvtDF4Tly5b__5uGCiQECIuse4cxmeiNp-ziSSbOLUEUTsBkwfIA8cHXYG14lpufK2U8RIc-oA',
            name: 'أحمد',
            xp: '8,420 XP',
            barHeight: 96,
            isFirst: false,
          ),
          SizedBox(width: AppSpacing.gutter),
          _PodiumCard(
            place: '1',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDirkz4tBTou3oKNhGDrJfyBSQFwuw3kG3VspNBENzvAvoA0iZmKSkG_ZvP5mdHUINr-xUbTTj5yWboTiMu4ZIdcsnwguPnXJAOBYUsKa0EhCPKTCtDyNxx8pNY8iYE7CCUPlOmh_J7x8B-juuWLACK6ss-kXyu2XlCeIqamlGF2ut6IvU_IgjEH7N3___YckysRbsT-md8MnFHsKHC2-LoDdhHs_PMQQM9iJ8e2KEw5Wo2vuo-iKXbcF5x3JoC4_icFZnaftrQaA',
            name: 'سارة',
            xp: '12,500 XP',
            barHeight: 128,
            isFirst: true,
          ),
          SizedBox(width: AppSpacing.gutter),
          _PodiumCard(
            place: '3',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC9le6DWdM9D5oP5XknB91fKEAQ_UmZrFywvp5U14eadAWdcsqf9uftKX-eKMAj6dveNKn_axR_6IGvzeezuVWM-TafrPnONzvcLvOcONx2H5EIi0n0iZ0zbAeZg2zdCUdXpwJq2EITBJKBI4WKgh5q4A_57gxOIhgktTWxFfmifdU8ZEWjkEIM1nb59q_3zgUK-lNGtxOvBpMRDiVNSUpPb-iOAGluIVYCbev6sknttUE3VrdwXhP_uuzCSALRAx1SZJXiikczFw',
            name: 'عمر',
            xp: '7,100 XP',
            barHeight: 80,
            isFirst: false,
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final String place;
  final String avatarUrl;
  final String name;
  final String xp;
  final double barHeight;
  final bool isFirst;

  const _PodiumCard({
    required this.place,
    required this.avatarUrl,
    required this.name,
    required this.xp,
    required this.barHeight,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFirst ? 120 : 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isFirst)
            const Icon(Icons.workspace_premium, color: AppColors.primary, size: 32),
          if (isFirst) const SizedBox(height: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: isFirst ? 80 : 64,
                height: isFirst ? 80 : 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFirst ? AppColors.primary : AppColors.surfaceVariant,
                    width: isFirst ? 4 : 2,
                  ),
                  boxShadow: isFirst
                      ? [BoxShadow(color: AppColors.primary.withAlpha(77), blurRadius: 20)]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: Image.network(avatarUrl, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: -4,
                left: -4,
                child: Container(
                  width: isFirst ? 32 : 24,
                  height: isFirst ? 32 : 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFirst ? AppColors.primary : AppColors.surfaceVariant,
                    border: Border.all(color: AppColors.surfaceDim, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    place,
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: isFirst ? 14 : 12,
                      fontWeight: FontWeight.bold,
                      color: isFirst ? AppColors.onPrimary : AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: AppTypography.bodyMD.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            xp,
            style: AppTypography.labelMD.copyWith(
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              color: isFirst
                  ? AppColors.primary.withAlpha(51)
                  : AppColors.surfaceVariant,
              gradient: isFirst
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withAlpha(77),
                        Colors.transparent,
                      ],
                    )
                  : null,
              border: isFirst
                  ? const Border(top: BorderSide(color: AppColors.primary, width: 1))
                  : null,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.emoji_events,
              size: isFirst ? 48 : 36,
              color: isFirst
                  ? AppColors.primary.withAlpha(204)
                  : AppColors.onSurfaceVariant.withAlpha(77),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankedList extends StatelessWidget {
  const _RankedList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _RankCard(
          rank: '4',
          avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuASI_MkK4HjIcU5X3_WmoXdzf7CIZ29TnUOyvvm45YBP0QqlXhlKeiK4heF6QZUgRKEp5EH5RQYKP0rRx-TFhiZuFYemQaPtmkGKHbx754KB1czmrp05YfXIkHlRrf7tIjvmC_uq581bBhj2OHOUNImkOH_YDViBpLWRPqcgtTamxSBM2Jb148Do6jKhlXWd94V7V2kZnOClhPH2QXP6ZZMvlq3P0XN2L82OHHjFH3JnfB9xSxMorRk2FZCkGiIs-2xAX1J__pVvA',
          name: 'ليلى',
          xp: '6,250',
          isCurrentUser: false,
        ),
        SizedBox(height: AppSpacing.stackSM),
        _RankCard(
          rank: '5',
          avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB-Dqvcek8DA6T12H6jApOtXsHHWiBB6tdRdiKz1sURhTKX4bga_ANgMY3fN3kViRHa-xBkzm2v5kcLl4RXIE9l3LWLW4OEaIdRBqVIngR1bGTkCZAiR7sbZu1Mz3gyurLF3f8uX99HVTQc6aaHQ8obIVyWOXJ0SiYDek-BXXOZgPKAW1vZxq8PVtZFd63kPYOh-TdfNlxcqh8_mNu_m3lDnWk3L0MA5rEMHb4KEOtxXZtP0Xfzgzdh_Hc0W_kjmtK8-VMBWRn4lg',
          name: 'أنت',
          xp: '5,800',
          isCurrentUser: true,
        ),
        SizedBox(height: AppSpacing.stackSM),
        _RankCard(
          rank: '6',
          avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBOIlgvsTNg7fhBtLe9y9N0We8Xeg7EdeutRuHQ0qVp6MSWQjhM9R28afk8scKT4ylE8e-_F2HRZnH4N0cAVvOhVIJjLaSNnYJVZPVm-fFJnCUu0cqIii-sXSJk70oSlgRSFrv9qQWVmkg_VyOkJ6d9fQGT1MOZUIhawFPUwNnvPS1cK2AynID_HwH0lrDSe3UQSR17USxalh52rZqdNG4IrWoaEBrN3ZYrjKmL6_zbX99D8kKLKnTJRMW8x2RX4JGjdBijkgGdmQ',
          name: 'نورة',
          xp: '5,120',
          isCurrentUser: false,
        ),
        SizedBox(height: AppSpacing.stackSM),
        _RankCard(
          rank: '7',
          avatarUrl: null,
          name: 'محمد',
          xp: '4,900',
          isCurrentUser: false,
        ),
      ],
    );
  }
}

class _RankCard extends StatelessWidget {
  final String rank;
  final String? avatarUrl;
  final String name;
  final String xp;
  final bool isCurrentUser;

  const _RankCard({
    required this.rank,
    this.avatarUrl,
    required this.name,
    required this.xp,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: isCurrentUser ? AppColors.primary.withAlpha(12) : AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(
          color: isCurrentUser ? AppColors.primary.withAlpha(128) : AppColors.onSurfaceVariant.withAlpha(25),
        ),
        boxShadow: isCurrentUser
            ? [BoxShadow(color: AppColors.primaryContainer.withAlpha(38), blurRadius: 20)]
            : null,
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: AppTypography.headlineMD.copyWith(
              color: isCurrentUser ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.stackMD),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentUser ? AppColors.primary : AppColors.onSurfaceVariant.withAlpha(51),
                width: isCurrentUser ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: avatarUrl != null
                  ? Image.network(avatarUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 24),
            ),
          ),
          const SizedBox(width: AppSpacing.stackMD),
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodyLG.copyWith(
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            xp,
            style: AppTypography.labelMD.copyWith(
              color: isCurrentUser ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'XP',
            style: AppTypography.codeSM.copyWith(
              color: isCurrentUser ? AppColors.primary : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

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
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.emoji_events_outlined,
                    label: 'التحديات',
                    isActive: true,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.groups_outlined,
                    label: 'المجتمع',
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.search,
                    label: 'الاستكشاف',
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'الرئيسية',
                    isActive: false,
                    onTap: () {},
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
