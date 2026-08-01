import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nawa_flutter/core/blocs/challenge/challenge_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/models/challenge_model.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final String challengeId;
  const ChallengeDetailsScreen({super.key, required this.challengeId});

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  ChallengeDetailModel? _challenge;

  @override
  void initState() {
    super.initState();
    context.read<ChallengeBloc>().add(ChallengeDetailLoadRequested(widget.challengeId));
  }

  void _showTestResults(SubmissionResult result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text(result.solved ? 'تم الحل بنجاح!' : 'لم يتم الحل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاختبارات: ${result.submission.testsPassed}/${result.submission.testsTotal}'),
            if (result.xpAwarded != null) Text('+${result.xpAwarded} XP'),
            if (result.remainingToday != null) Text('المتبقي اليوم: ${result.remainingToday} محاولات'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengeBloc, ChallengeState>(
      listener: (context, state) {
        if (state is ChallengeSubmitted) {
          _showTestResults(state.result);
        }
        if (state is ChallengeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ChallengeDetailLoaded) {
          _challenge = state.challenge;
        }
        if (state is ChallengeLoading || state is ChallengeInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is ChallengeError && _challenge == null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.containerMargin),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center, style: AppTypography.bodyMD),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.read<ChallengeBloc>().add(
                        ChallengeDetailLoadRequested(widget.challengeId),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        final challenge = _challenge;
        if (challenge == null) return const SizedBox.shrink();
        return Scaffold(
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.containerMargin,
                  right: AppSpacing.containerMargin,
                  top: 72,
                  bottom: 100,
                ),
                children: [
                  _HeroSection(challenge: challenge),
                  const SizedBox(height: AppSpacing.stackMD),
                  _DescriptionSection(challenge: challenge),
                  const SizedBox(height: AppSpacing.stackLG),
                  _RewardsSection(challenge: challenge),
                  const SizedBox(height: AppSpacing.stackLG),
                  _RequirementsSection(challenge: challenge),
                  const SizedBox(height: AppSpacing.stackLG),
                  if (challenge.imageUrl != null) _ImageSection(challenge: challenge),
                  const SizedBox(height: 24),
                ],
              ),
              const _TopBar(),
              _BottomCta(challenge: challenge),
            ],
          ),
        );
      },
    );
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
        border: Border(bottom: BorderSide(color: AppColors.onSurfaceVariant.withAlpha(25))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.full)),
              child: const Icon(Icons.arrow_back, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.stackSM),
          Text('تفاصيل التحدي', style: AppTypography.headlineMD.copyWith(color: AppColors.primary)),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.full)),
              child: const Icon(Icons.more_vert, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final ChallengeDetailModel challenge;
  const _HeroSection({required this.challenge});

  @override
  Widget build(BuildContext context) {
    final remaining = challenge.endsAt?.difference(DateTime.now());
    final days = remaining != null ? remaining.inDays.clamp(0, 999).toString().padLeft(2, '0') : '00';
    final hours = remaining != null ? (remaining.inHours % 24).clamp(0, 99).toString().padLeft(2, '0') : '00';
    final minutes = remaining != null ? (remaining.inMinutes % 60).clamp(0, 99).toString().padLeft(2, '0') : '00';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -40, left: 0, right: 0,
          child: Center(
            child: Container(
              width: 256, height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withAlpha(25),
                boxShadow: [
                  BoxShadow(color: AppColors.primaryContainer.withAlpha(25), blurRadius: 80, spreadRadius: 20),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: AppSpacing.stackLG),
            if (challenge.participantsCount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.primaryContainer.withAlpha(25),
                  border: Border.all(color: AppColors.primaryContainer.withAlpha(51)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.group, size: 18, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.stackSM),
                    Text(
                      formatChallengeNumber(challenge.participantsCount!),
                      style: AppTypography.labelMD.copyWith(color: AppColors.primary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.stackMD),
            Text(
              challenge.title,
              style: AppTypography.headlineXL.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            if (challenge.endsAt != null) ...[
              const SizedBox(height: AppSpacing.stackMD),
              Text(
                remaining?.isNegative == true ? 'انتهى التحدي' : 'ينتهي خلال',
                style: AppTypography.labelMD.copyWith(color: AppColors.onSurfaceVariant),
              ),
              if (remaining?.isNegative != true) ...[
                const SizedBox(height: AppSpacing.stackSM),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TimerBlock(value: days),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(':', style: TextStyle(color: AppColors.primary, fontSize: 32)),
                      ),
                      _TimerBlock(value: hours),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(':', style: TextStyle(color: AppColors.primary, fontSize: 32)),
                      ),
                      _TimerBlock(value: minutes),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ],
    );
  }
}

class _TimerBlock extends StatelessWidget {
  final String value;
  const _TimerBlock({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh,
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontFamily: AppTypography.fontMono,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final ChallengeDetailModel challenge;
  const _DescriptionSection({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl * 2),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  color: AppColors.primaryContainer.withAlpha(25),
                ),
                child: const Icon(Icons.description, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.stackSM),
              const Text('عن التحدي', style: AppTypography.headlineMD),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          Text(
            challenge.description ?? 'لا يوجد وصف',
            style: AppTypography.bodyLG.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _RewardsSection extends StatelessWidget {
  final ChallengeDetailModel challenge;
  const _RewardsSection({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الجوائز والمكافآت', style: AppTypography.headlineMD),
        const SizedBox(height: AppSpacing.gutter),
        Row(
          children: [
            if (challenge.xpReward != null)
              Expanded(
                child: _RewardCard(
                  icon: Icons.military_tech,
                  iconBg: AppColors.secondaryContainer.withAlpha(25),
                  iconColor: AppColors.secondary,
                  title: '${challenge.xpReward!} XP',
                  subtitle: 'نقاط خبرة تقنية',
                ),
              ),
            if (challenge.xpReward != null && challenge.badgeReward != null)
              const SizedBox(width: AppSpacing.gutter),
            if (challenge.badgeReward != null)
              Expanded(
                child: _RewardCard(
                  icon: Icons.architecture,
                  iconBg: AppColors.primaryContainer.withAlpha(25),
                  iconColor: AppColors.primary,
                  title: challenge.badgeReward!,
                  subtitle: 'Architect Badge',
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _RewardCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl * 2),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(shape: BoxShape.circle, color: iconBg),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: AppSpacing.stackSM),
          Text(
            title,
            style: AppTypography.headlineMD.copyWith(
              color: iconColor == AppColors.secondary ? AppColors.primary : AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.labelMD.copyWith(color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _RequirementsSection extends StatelessWidget {
  final ChallengeDetailModel challenge;
  const _RequirementsSection({required this.challenge});

  List<_RequirementItemData> _parseRequirements() {
    final md = challenge.requirementsMd ?? '';
    if (md.isEmpty) return [];
    final lines = md.split('\n').where((l) => l.trim().isNotEmpty).toList();
    return lines.map((line) {
      final cleaned = line.replaceAll(RegExp(r'^[#*\-\s]+'), '');
      final parts = cleaned.split('：');
      if (parts.length >= 2) {
        return _RequirementItemData(title: parts[0].trim(), body: parts.sublist(1).join('：').trim());
      }
      final colonParts = cleaned.split(':');
      if (colonParts.length >= 2) {
        return _RequirementItemData(title: colonParts[0].trim(), body: colonParts.sublist(1).join(':').trim());
      }
      return _RequirementItemData(title: cleaned, body: '');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final requirements = _parseRequirements();
    if (requirements.isEmpty && (challenge.description == null || challenge.description!.isEmpty)) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('المتطلبات التقنية', style: AppTypography.headlineMD),
        const SizedBox(height: AppSpacing.gutter),
        ...requirements.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.stackSM),
          child: _RequirementItem(title: r.title, body: r.body),
        )),
        if (challenge.languageCode != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.stackSM),
            child: _RequirementItem(
              title: 'لغة البرمجة',
              body: 'استخدام ${languageDisplayName(challenge.languageCode!)}',
            ),
          ),
        if (challenge.solvedCount != null)
          _RequirementItem(
            title: 'عدد الحلول',
            body: 'تم حل التحدي ${challenge.solvedCount} مرة',
          ),
      ],
    );
  }
}

class _RequirementItemData {
  final String title;
  final String body;
  const _RequirementItemData({required this.title, required this.body});
}

class _RequirementItem extends StatelessWidget {
  final String title;
  final String body;
  const _RequirementItem({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
        color: AppColors.surfaceContainerLow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headlineMD.copyWith(fontSize: 16)),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(body, style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final ChallengeDetailModel challenge;
  const _ImageSection({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl * 2),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
        image: challenge.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(challenge.imageUrl!),
                fit: BoxFit.cover,
                opacity: 0.8,
              )
            : null,
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  final ChallengeDetailModel challenge;
  const _BottomCta({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppColors.background.withAlpha(242), AppColors.background],
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.read<ChallengeBloc>().add(ChallengeSubmitRequested(
                  id: challenge.id,
                  sourceCode: challenge.starterCode ?? '',
                  languageCode: challenge.languageCode ?? '',
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
                elevation: 0,
                textStyle: AppTypography.headlineMD,
              ).copyWith(
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(challenge.solved ? 'تم الحل' : 'ابدأ التحدي الآن'),
                  const SizedBox(width: 8),
                  Icon(challenge.solved ? Icons.check : Icons.play_arrow, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String formatChallengeNumber(int number) {
  if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
  if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
  return number.toString();
}

String languageDisplayName(String code) {
  switch (code) {
    case 'python': return 'Python 3.9 أو إصدار أحدث';
    case 'javascript': return 'JavaScript ES6+';
    case 'typescript': return 'TypeScript';
    case 'dart': return 'Dart';
    case 'java': return 'Java 11+';
    case 'cpp': return 'C++17';
    case 'go': return 'Go';
    case 'rust': return 'Rust';
    default: return code;
  }
}
