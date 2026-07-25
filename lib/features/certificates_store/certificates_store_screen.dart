import 'package:flutter/material.dart';
import 'package:nawa_flutter/core/constants/constants.dart';

class CertificatesStoreScreen extends StatelessWidget {
  const CertificatesStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(
          left: AppSpacing.containerMargin,
          right: AppSpacing.containerMargin,
          top: 72,
          bottom: 100,
        ),
        children: [
          const _Header(),
          const SizedBox(height: 48),
          const _CertificatesSection(),
          const SizedBox(height: 48),
          const _SubscriptionSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الشهادات والمتجر',
          style: AppTypography.headlineXL.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: AppSpacing.stackSM),
        Text(
          'استعرض إنجازاتك وارتقِ بحسابك إلى المستوى التالي.',
          style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _CertificatesSection extends StatelessWidget {
  const _CertificatesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.primary),
            const SizedBox(width: AppSpacing.stackSM),
            Text('شهاداتك الرقمية', style: AppTypography.headlineMD),
          ],
        ),
        const SizedBox(height: AppSpacing.stackMD),
        const _CertificateCard(
          icon: Icons.military_tech,
          iconColor: Color(0xFFFFD700),
          iconBorderColor: Color(0x4DFFD700),
          badge: 'درجة امتياز',
          badgeBg: Color(0x1AFFD700),
          badgeBorder: Color(0x33FFD700),
          badgeText: Color(0xFFFFD700),
          title: 'هندسة البرمجيات المتقدمة',
          date: 'تم الإنجاز: ٢٤ أكتوبر ٢٠٢٣',
          glowColor: Color(0x1AFFD700),
        ),
        const SizedBox(height: AppSpacing.gutter),
        const _CertificateCard(
          icon: Icons.code,
          iconColor: AppColors.primary,
          iconBorderColor: Color(0x4D50DEA9),
          badge: 'مكتمل',
          badgeBg: AppColors.surfaceVariant,
          badgeBorder: Color(0x1ABBCAC0),
          badgeText: AppColors.onSurfaceVariant,
          title: 'أساسيات هياكل البيانات',
          date: 'تم الإنجاز: ١٢ سبتمبر ٢٠٢٣',
          glowColor: Color(0x1A50DEA9),
        ),
      ],
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBorderColor;
  final String badge;
  final Color badgeBg;
  final Color badgeBorder;
  final Color badgeText;
  final String title;
  final String date;
  final Color glowColor;

  const _CertificateCard({
    required this.icon,
    required this.iconColor,
    required this.iconBorderColor,
    required this.badge,
    required this.badgeBg,
    required this.badgeBorder,
    required this.badgeText,
    required this.title,
    required this.date,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(12)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowColor,
                boxShadow: [
                  BoxShadow(
                    color: glowColor,
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceVariant,
                      border: Border.all(color: iconBorderColor),
                    ),
                    child: Icon(icon, color: iconColor, size: 32),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      color: badgeBg,
                      border: Border.all(color: badgeBorder),
                    ),
                    child: Text(
                      badge,
                      style: AppTypography.labelMD.copyWith(
                        color: badgeText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.stackMD),
              Text(title, style: AppTypography.headlineLG),
              const SizedBox(height: 4),
              Text(
                date,
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontFamily: AppTypography.fontMono,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.stackMD),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surfaceVariant.withAlpha(128),
                    foregroundColor: AppColors.onSurface,
                    side: BorderSide(color: AppColors.onSurfaceVariant.withAlpha(51)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'مشاركة',
                        style: AppTypography.labelMD.copyWith(color: AppColors.onSurface),
                      ),
                      const SizedBox(width: AppSpacing.stackSM),
                      const Icon(Icons.share, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubscriptionSection extends StatelessWidget {
  const _SubscriptionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.storefront, color: AppColors.primary),
            const SizedBox(width: AppSpacing.stackSM),
            Text('باقات الاشتراك', style: AppTypography.headlineMD),
          ],
        ),
        const SizedBox(height: AppSpacing.stackMD),
        const _FreePlanCard(),
        const SizedBox(height: AppSpacing.stackLG),
        const _ProPlanCard(),
      ],
    );
  }
}

class _FreePlanCard extends StatelessWidget {
  const _FreePlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الباقة الأساسية', style: AppTypography.headlineLG),
          const SizedBox(height: AppSpacing.stackSM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('مجاني', style: AppTypography.headlineXL),
              const SizedBox(width: 4),
              Text('/ دائماً', style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          _FeatureItem(text: 'وصول محدود للمسارات التعليمية'),
          const SizedBox(height: AppSpacing.gutter),
          _FeatureItem(text: 'مشاركة في التحديات المجتمعية'),
          const SizedBox(height: AppSpacing.gutter),
          _FeatureItem(text: 'شهادات إتمام أساسية'),
          const SizedBox(height: AppSpacing.stackMD),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text(
              'الخطة الحالية',
              style: AppTypography.labelMD.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProPlanCard extends StatelessWidget {
  const _ProPlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.primary.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الباقة الاحترافية',
                style: AppTypography.headlineLG.copyWith(color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.primaryContainer,
                ),
                child: Text(
                  'الأكثر شعبية',
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackSM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('٤٩', style: AppTypography.headlineXL),
              const SizedBox(width: 4),
              Text('/ شهرياً', style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          _FeatureItem(text: 'وصول كامل لجميع المسارات والمحتوى المتقدم', color: AppColors.primary),
          const SizedBox(height: AppSpacing.gutter),
          _FeatureItem(text: 'مراجعة كود من خبراء الصناعة (Code Review)', color: AppColors.primary),
          const SizedBox(height: AppSpacing.gutter),
          _FeatureItem(text: 'شهادات معتمدة ومميزة بختم ذهبي', color: AppColors.primary),
          const SizedBox(height: AppSpacing.gutter),
          _FeatureItem(text: 'أولوية في الدعم الفني والإرشاد', color: AppColors.primary),
          const SizedBox(height: AppSpacing.stackMD),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                elevation: 0,
                textStyle: AppTypography.headlineMD,
              ).copyWith(
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: const Text('ترقية الحساب الآن'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  final Color color;

  const _FeatureItem({required this.text, this.color = AppColors.onSurfaceVariant});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: color, size: 20),
        const SizedBox(width: AppSpacing.gutter),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMD.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
