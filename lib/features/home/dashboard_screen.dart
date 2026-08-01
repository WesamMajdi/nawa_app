import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/widgets/app_drawer.dart';
import '../../core/blocs/dashboard/dashboard_bloc.dart';
import '../../core/models/dashboard_model.dart';
import '../../core/constants/constants.dart';
import '../../core/helper/extension.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../challenge_details/challenge_details_screen.dart';
import '../lesson_viewing/lesson_viewing_screen.dart';
import '../notifications/notifications_screen.dart';
import 'widgets/progress_ring.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(DashboardLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DashboardLoaded) {
                  return _buildBody(state);
                }
                if (state is DashboardError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
            const AppBottomNav(currentTab: NavTab.home),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }

  Widget _buildBody(DashboardLoaded state) {
    final user = state.user;
    final dashboard = state.dashboard;
    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: AppSpacing.unit,
        bottom: 100,
      ),
      children: [
        _TopBar(),
        const SizedBox(height: AppSpacing.stackLG),
        _GreetingHeader(name: user.name, streakDays: dashboard.stats.streakDays),
        const SizedBox(height: AppSpacing.gutter),
        if (dashboard.continueData != null)
          _CurrentPathCard(continueData: dashboard.continueData!)
        else
          _EmptyPathCard(),
        const SizedBox(height: AppSpacing.gutter),
        if (dashboard.dailyChallenge != null) ...[
          _DailyChallengeCard(dailyChallenge: dashboard.dailyChallenge!),
          const SizedBox(height: AppSpacing.gutter),
        ],
        _StatsGrid(stats: dashboard.stats),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.menu),
          color: AppColors.onSurface,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        const Spacer(),
        Text(
          'نواة',
          style: AppTypography.headlineLG.copyWith(color: AppColors.primary),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.onSurface,
          onPressed: () => context.push(const NotificationsScreen()),
        ),
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  final String name;
  final int streakDays;
  const _GreetingHeader({required this.name, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً بعودتك',
                style: AppTypography.bodyMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text('أهلاً بك، $name', style: AppTypography.headlineXL),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.stackSM),
        _StreakCounter(streakDays: streakDays),
      ],
    );
  }
}

class _StreakCounter extends StatelessWidget {
  final int streakDays;
  const _StreakCounter({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: [
          _PulsingFire(),
          const SizedBox(width: 6),
          Text(
            '$streakDays',
            style: AppTypography.headlineMD.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _PulsingFire extends StatefulWidget {
  @override
  State<_PulsingFire> createState() => _PulsingFireState();
}

class _PulsingFireState extends State<_PulsingFire>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: child);
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(51),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          Icons.local_fire_department_rounded,
          color: const Color(0xFFFF6B35),
          size: 24,
        ),
      ),
    );
  }
}

class _CurrentPathCard extends StatelessWidget {
  final ContinueData continueData;
  const _CurrentPathCard({required this.continueData});

  @override
  Widget build(BuildContext context) {
    final pct = continueData.progressPct;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withAlpha(25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(12), Colors.white.withAlpha(0)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withAlpha(30),
            blurRadius: 30,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.stackLG),
        child: Column(
          children: [
            ProgressRing(progress: pct / 100.0, size: 128),
            const SizedBox(height: AppSpacing.stackMD),
            Row(
              children: [
                Text(
                  'الدرس ${continueData.lessonTitle}',
                  style: AppTypography.codeSM.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withAlpha(38),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'المسار الحالي',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackSM),
            Text(continueData.pathTitle, style: AppTypography.headlineLG),
            const SizedBox(height: AppSpacing.stackSM),
            const SizedBox(height: AppSpacing.stackMD),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(LessonViewingScreen(lessonId: continueData.lessonId));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surfaceContainerLowest,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  elevation: 0,
                  textStyle: AppTypography.headlineMD,
                ).copyWith(
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: const Text('أكمل التعلم'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPathCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withAlpha(25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(12), Colors.white.withAlpha(0)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.stackLG),
        child: Column(
          children: [
            Icon(Icons.school_outlined, size: 64, color: AppColors.onSurfaceVariant.withAlpha(100)),
            const SizedBox(height: AppSpacing.stackMD),
            Text('لم تبدأ أي مسار بعد', style: AppTypography.headlineMD),
            const SizedBox(height: AppSpacing.stackSM),
            Text(
              'استكشف المسارات المتاحة وابدأ رحلة التعلم',
              style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  final DailyChallengeModel dailyChallenge;
  const _DailyChallengeCard({required this.dailyChallenge});

  String get _difficultyLabel => switch (dailyChallenge.difficulty) {
        'easy' => 'سهل',
        'medium' => 'متوسط',
        'hard' => 'متقدم',
        _ => dailyChallenge.difficulty ?? 'تحدي',
      };

  @override
  Widget build(BuildContext context) {
    final challenge = dailyChallenge;
    return GestureDetector(
      onTap: () => context.push(
        ChallengeDetailsScreen(challengeId: challenge.id),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: Colors.white.withAlpha(25)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withAlpha(38),
              Colors.white.withAlpha(8),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      color: AppColors.primary.withAlpha(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bolt_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          challenge.solved ? 'تم الحل اليوم ✓' : 'تحدّي اليوم',
                          style: AppTypography.labelMD.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _difficultyLabel,
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.stackMD),
              Text(
                challenge.title,
                style: AppTypography.headlineMD,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (challenge.description != null) ...[
                const SizedBox(height: AppSpacing.stackSM),
                Text(
                  challenge.description!,
                  style: AppTypography.bodyMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppSpacing.stackMD),
              Row(
                children: [
                  _ChallengeMeta(
                    icon: Icons.emoji_events_rounded,
                    text: '${challenge.xpReward ?? 0} XP',
                  ),
                  const SizedBox(width: AppSpacing.stackMD),
                  if (challenge.languageCode != null)
                    _ChallengeMeta(
                      icon: Icons.code_rounded,
                      text: challenge.languageCode!.toUpperCase(),
                    ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      color: AppColors.primary,
                    ),
                    child: Text(
                      challenge.solved ? 'عرض التحدي' : 'ابدأ الآن',
                      style: AppTypography.headlineMD.copyWith(
                        color: AppColors.background,
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

class _ChallengeMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ChallengeMeta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTypography.labelMD.copyWith(
            color: AppColors.onSurfaceVariant,
            fontFamily: AppTypography.fontMono,
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final DashboardStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.star_rounded,
                iconColor: AppColors.primary,
                label: 'نقاط الخبرة',
                value: '${stats.xp} XP',
              ),
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: _StatCard(
                icon: Icons.task_alt_rounded,
                iconColor: AppColors.secondary,
                label: 'الدروس المكتملة',
                value: '${stats.lessonsCompleted}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.gutter),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.emoji_events_rounded,
                iconColor: AppColors.tertiary,
                label: 'التحديات الفائزة',
                value: '${stats.challengesSolved}',
              ),
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: _StatCard(
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.primary,
                label: 'الترتيب العالمي',
                value: '#${stats.globalRank}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: Colors.white.withAlpha(25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(12), Colors.white.withAlpha(0)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(value, style: AppTypography.headlineLG),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.stackMD),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
