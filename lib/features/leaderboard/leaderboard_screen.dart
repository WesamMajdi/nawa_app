import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            const _LeaderboardTabs(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.containerMargin,
                  right: AppSpacing.containerMargin,
                  top: AppSpacing.gutter,
                  bottom: 100,
                ),
                children: const [
                  _Podium(),
                  SizedBox(height: AppSpacing.gutter),
                  _RankCard(
                    rank: 4,
                    name: 'نورة السعدون',
                    xp: 2150,
                    level: 9,
                    isYou: false,
                  ),
                  SizedBox(height: AppSpacing.gutter),
                  _RankCard(
                    rank: 5,
                    name: 'سارة الحربي',
                    xp: 1920,
                    level: 8,
                    isYou: false,
                  ),
                  SizedBox(height: AppSpacing.gutter),
                  _RankCard(
                    rank: 6,
                    name: 'خالد المطيري',
                    xp: 1880,
                    level: 8,
                    isYou: false,
                  ),
                  SizedBox(height: AppSpacing.gutter),
                  _RankCard(
                    rank: 7,
                    name: 'ندى الشمري',
                    xp: 1750,
                    level: 7,
                    isYou: false,
                  ),
                  SizedBox(height: AppSpacing.gutter),
                  _RankCard(
                    rank: 8,
                    name: 'عبدالله القحطاني',
                    xp: 1620,
                    level: 7,
                    isYou: false,
                  ),
                  SizedBox(height: AppSpacing.gutter),
                  _RankCard(
                    rank: 9,
                    name: 'ريم العتيبي',
                    xp: 1510,
                    level: 6,
                    isYou: false,
                  ),
                ],
              ),
            ),
            const _MyRankBar(),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.stackSM,
      ),
      child: Row(
        children: [
          const Spacer(),
          Text(
            'لوحة المتصدرين',
            style: AppTypography.headlineLG.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.info_outline),
            color: AppColors.onSurface,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTabs extends StatelessWidget {
  const _LeaderboardTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Text(
                'أسبوعي',
                textAlign: TextAlign.center,
                style: AppTypography.headlineMD.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'شهري',
                textAlign: TextAlign.center,
                style: AppTypography.headlineMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'كل الوقت',
                textAlign: TextAlign.center,
                style: AppTypography.headlineMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.gutter),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(child: _PodiumItem(rank: 2, name: 'سارة', xp: '3,200', height: 100)),
          const Expanded(flex: 12, child: SizedBox.shrink()),
          const Expanded(child: _PodiumItem(rank: 1, name: 'أحمد', xp: '4,500', height: 140, isGold: true)),
          const Expanded(flex: 12, child: SizedBox.shrink()),
          const Expanded(child: _PodiumItem(rank: 3, name: 'فهد', xp: '2,800', height: 80)),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final int rank;
  final String name;
  final String xp;
  final double height;
  final bool isGold;

  const _PodiumItem({
    required this.rank,
    required this.name,
    required this.xp,
    required this.height,
    this.isGold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isGold ? const Color(0xFFFFD700) : AppColors.outlineVariant,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: isGold ? 22 : 18,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Text(
              '$rank',
              style: AppTypography.headlineMD.copyWith(
                color: isGold ? const Color(0xFFFFD700) : AppColors.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: AppTypography.labelMD.copyWith(color: AppColors.onSurface, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isGold
                  ? [const Color(0xFFFFD700).withAlpha(77), const Color(0xFFFFD700).withAlpha(25)]
                  : [AppColors.primary.withAlpha(77), AppColors.primary.withAlpha(25)],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            xp,
            style: AppTypography.codeSM.copyWith(
              color: isGold ? const Color(0xFFFFD700) : AppColors.primary,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _RankCard extends StatelessWidget {
  final int rank;
  final String name;
  final int xp;
  final int level;
  final bool isYou;

  const _RankCard({
    required this.rank,
    required this.name,
    required this.xp,
    required this.level,
    required this.isYou,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: isYou ? AppColors.primary.withAlpha(20) : AppColors.surfaceContainer,
        border: Border.all(
          color: isYou ? AppColors.primary.withAlpha(77) : AppColors.outlineVariant.withAlpha(25),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              textAlign: TextAlign.center,
              style: AppTypography.headlineMD.copyWith(
                color: rank <= 3 ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Text(
              name[0],
              style: AppTypography.bodyMD.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: AppTypography.bodyMD.copyWith(color: AppColors.onSurface)),
                    if (isYou)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(38),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          'أنت',
                          style: AppTypography.codeSM.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'المستوى $level',
                  style: AppTypography.codeSM.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            '$xp XP',
            style: AppTypography.headlineMD.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _MyRankBar extends StatelessWidget {
  const _MyRankBar();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.containerMargin,
          AppSpacing.gutter,
          AppSpacing.containerMargin,
          24,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.emoji_events, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرتبتك الحالية',
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '#1 من 234 متعلم',
                      style: AppTypography.headlineMD.copyWith(color: AppColors.onSurface),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '4,500 XP',
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.primary,
                    fontFamily: AppTypography.fontMono,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
