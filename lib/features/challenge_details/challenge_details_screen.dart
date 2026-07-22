import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({super.key});

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
              bottom: 100,
            ),
            children: [
              const _HeroSection(),
              const SizedBox(height: AppSpacing.stackMD),
              const _DescriptionSection(),
              const SizedBox(height: AppSpacing.stackLG),
              const _RewardsSection(),
              const SizedBox(height: AppSpacing.stackLG),
              const _RequirementsSection(),
              const SizedBox(height: AppSpacing.stackLG),
              const _ImageSection(),
              const SizedBox(height: 24),
            ],
          ),
          const _TopBar(),
          const _BottomCta(),
        ],
      ),
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
            'تفاصيل التحدي',
            style: AppTypography.headlineMD.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Icon(Icons.more_vert, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer.withAlpha(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withAlpha(25),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: AppSpacing.stackLG),
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
                    '1,245 مشارك',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.stackMD),
            Text(
              'تحدي خوارزميات الذكاء الاصطناعي',
              style: AppTypography.headlineXL.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.stackMD),
            Text(
              'ينتهي خلال',
              style: AppTypography.labelMD.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.stackSM),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TimerBlock(value: '02'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(':', style: TextStyle(color: AppColors.primary, fontSize: 32)),
                  ),
                  _TimerBlock(value: '07'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(':', style: TextStyle(color: AppColors.primary, fontSize: 32)),
                  ),
                  _TimerBlock(value: '22'),
                ],
              ),
            ),
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
  const _DescriptionSection();

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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  color: AppColors.primaryContainer.withAlpha(25),
                ),
                child: const Icon(Icons.description, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.stackSM),
              Text('عن التحدي', style: AppTypography.headlineMD),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          Text(
            'قم ببناء نموذج تعلم آلي لتوقع أنماط استهلاك البيانات بكفاءة عالية باستخدام بايثون. يهدف هذا التحدي إلى تحسين دقة التوقعات بنسبة لا تقل عن 92% مع مراعاة استهلاك الموارد البرمجية.',
            style: AppTypography.bodyLG.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _RewardsSection extends StatelessWidget {
  const _RewardsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الجوائز والمكافآت', style: AppTypography.headlineMD),
        const SizedBox(height: AppSpacing.gutter),
        Row(
          children: [
            Expanded(child: _RewardCard(
              icon: Icons.military_tech,
              iconBg: AppColors.secondaryContainer.withAlpha(25),
              iconColor: AppColors.secondary,
              iconFill: true,
              title: '5,000 XP',
              subtitle: 'نقاط خبرة تقنية',
            )),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(child: _RewardCard(
              icon: Icons.architecture,
              iconBg: AppColors.primaryContainer.withAlpha(25),
              iconColor: AppColors.primary,
              iconFill: false,
              title: 'شارة معمار',
              subtitle: 'Architect Badge',
            )),
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
  final bool iconFill;
  final String title;
  final String subtitle;

  const _RewardCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.iconFill,
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBg,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: AppSpacing.stackSM),
          Text(title, style: AppTypography.headlineMD.copyWith(
            color: iconColor == AppColors.secondary ? AppColors.primary : AppColors.onSurface,
          )),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.labelMD.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementsSection extends StatelessWidget {
  const _RequirementsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('المتطلبات التقنية', style: AppTypography.headlineMD),
        const SizedBox(height: AppSpacing.gutter),
        _RequirementItem(
          title: 'لغة البرمجة',
          body: 'استخدام Python 3.9 أو إصدار أحدث حصراً.',
        ),
        const SizedBox(height: AppSpacing.stackSM),
        _RequirementItem(
          title: 'دقة النموذج',
          body: 'يجب أن تتخطى دقة التوقعات (Accuracy) حاجز الـ 90%.',
        ),
        const SizedBox(height: AppSpacing.stackSM),
        _RequirementItem(
          title: 'البيانات الضخمة',
          body: 'القدرة على معالجة ملفات بيانات بحجم يزيد عن 2 جيجابايت.',
        ),
        const SizedBox(height: AppSpacing.stackSM),
        _RequirementItem(
          title: 'التوثيق',
          body: 'إرفاق ملف README يشرح كيفية تشغيل الكود بوضوح.',
        ),
      ],
    );
  }
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
                const SizedBox(height: 4),
                Text(body, style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl * 2),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
        image: const DecorationImage(
          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBW4R2kEE1Z4OUF500vUeHWZ5_eX7BpUE50sSO5CSxswsbEzrVsqvwKxGXm9AbAQH2X529O9BZfYk4JQx9wQPEcKNQfFvdQU8QbNfxZC0U_dfWncMBJGqPTSi1x2WKu5hL88tRfStXSLrS-WA5-qRd2WnJ-6AXcJwjF1rJG1prN2tzz3mK9o-BxmI-1U_GN_guJTCkOyudhfqcwY0wyr_Cu6j19KhLys8IaZP8frqLn5yETnbO6MqbX8HENBG_QoO4LUk_HojqffQ'),
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta();

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
            colors: [
              Colors.transparent,
              AppColors.background.withAlpha(242),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                elevation: 0,
                textStyle: AppTypography.headlineMD,
              ).copyWith(
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('ابدأ التحدي الآن'),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
