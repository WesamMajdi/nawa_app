import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/blocs/certificate/certificate_bloc.dart';
import '../../core/constants/constants.dart';
import '../../core/models/plan_model.dart';
import '../../core/repositories/certificate_repository.dart';

class CertificatesStoreScreen extends StatefulWidget {
  const CertificatesStoreScreen({super.key});

  @override
  State<CertificatesStoreScreen> createState() =>
      _CertificatesStoreScreenState();
}

class _CertificatesStoreScreenState extends State<CertificatesStoreScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<CertificateBloc>()
        .add(CertificateLoadRequested());
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return 'تم الإنجاز: ${date.day} ${_monthName(date.month)} ${date.year}';
  }

   String _monthName(int month) {
     const months = [
       'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
       'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
     ];
     return months[month - 1];
   }

   static Future<void> _downloadCertificate(
     BuildContext context,
     String certificateId,
   ) async {
     final repo = context.read<CertificateRepository>();
     final snackScaffold = ScaffoldMessenger.of(context);
     snackScaffold.showSnackBar(
       const SnackBar(
         content: Text('جاري التحميل...'),
         duration: Duration(seconds: 1),
       ),
     );
     try {
       final bytes = await repo.downloadCertificate(certificateId);
       if (bytes.isEmpty) {
         snackScaffold.showSnackBar(
           const SnackBar(
             content: Text('فشل التحميل'),
             backgroundColor: AppColors.error,
           ),
         );
         return;
       }
       final dir = await getApplicationDocumentsDirectory();
       final file = File('${dir.path}/certificate_$certificateId.pdf');
       await file.writeAsBytes(bytes);
       await Share.shareXFiles(
         [XFile(file.path)],
         text: 'شهادة نواة',
       );
     } catch (_) {
       snackScaffold.showSnackBar(
         const SnackBar(
           content: Text('حدث خطأ أثناء التحميل'),
           backgroundColor: AppColors.error,
         ),
       );
     }
   }

   IconData _iconForCertificate(String title, String? pathTitle) {
    final text = (title + (pathTitle ?? '')).toLowerCase();
    if (text.contains('هندسة') || text.contains('software')) {
      return Icons.military_tech;
    }
    if (text.contains('بيانات') || text.contains('data')) {
      return Icons.code;
    }
    if (text.contains('شبكات') || text.contains('network')) {
      return Icons.lan;
    }
    if (text.contains('أمن') || text.contains('security')) {
      return Icons.security;
    }
    if (text.contains('ذكاء') || text.contains('ai') || text.contains('ml')) {
      return Icons.psychology;
    }
    if (text.contains('تطبيقات') || text.contains('mobile')) {
      return Icons.phone_android;
    }
    if (text.contains('ويب') || text.contains('web')) {
      return Icons.web;
    }
    return Icons.workspace_premium;
  }

  Color _colorFromString(String? colorHex) {
    if (colorHex == null) return AppColors.primary;
    final c = colorHex.replaceFirst('#', '');
    if (c.length == 6) {
      return Color(int.parse('FF$c', radix: 16));
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<CertificateBloc, CertificateState>(
            builder: (context, state) {
              if (state is CertificateLoading) {
                return _buildLoading();
              }
              if (state is CertificateError) {
                return _buildError(state.message);
              }
              if (state is CertificateSubscriptionSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showSuccessDialog(context);
                  context
                      .read<CertificateBloc>()
                      .add(CertificateLoadRequested());
                });
              }
              if (state is CertificateLoaded) {
                return _buildContent(state.certificates, state.plans);
              }
              return const SizedBox.shrink();
            },
          ),
          _TopBar(),
        ],
      ),
    );
  }

  Widget _buildContent(
      List<CertificateModel> certificates, List<PlanModel> plans) {
    final sortedCerts = List<CertificateModel>.from(certificates)
      ..sort((a, b) {
        if (a.issuedAt == null && b.issuedAt == null) return 0;
        if (a.issuedAt == null) return 1;
        if (b.issuedAt == null) return -1;
        return b.issuedAt!.compareTo(a.issuedAt!);
      });

    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: 72,
        bottom: 100,
      ),
      children: [
        const _Header(),
        const SizedBox(height: 48),
        if (sortedCerts.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: AppColors.primary),
              const SizedBox(width: AppSpacing.stackSM),
              Text('شهاداتك الرقمية', style: AppTypography.headlineMD),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          for (final cert in sortedCerts) ...[
            _CertificateCard(
              icon: _iconForCertificate(cert.title, cert.pathTitle),
              iconColor: _colorFromString(cert.color),
              iconBorderColor: _colorFromString(cert.color).withAlpha(77),
              badge: cert.grade ?? 'مكتمل',
              badgeBg: cert.grade != null
                  ? const Color(0x1AFFD700)
                  : AppColors.surfaceVariant,
              badgeBorder: cert.grade != null
                  ? const Color(0x33FFD700)
                  : const Color(0x1ABBCAC0),
              badgeText: cert.grade != null
                  ? const Color(0xFFFFD700)
                  : AppColors.onSurfaceVariant,
              title: cert.title,
              date: _formatDate(cert.issuedAt),
              glowColor: _colorFromString(cert.color).withAlpha(26),
              onShare: () {
                if (cert.pdfUrl != null) {
                  context.go(cert.pdfUrl!);
                }
              },
              onDownload: () => _downloadCertificate(context, cert.id),
            ),
            const SizedBox(height: AppSpacing.gutter),
          ],
        ],
        if (plans.isNotEmpty) ...[
          const SizedBox(height: 48),
          Row(
            children: [
              const Icon(Icons.storefront, color: AppColors.primary),
              const SizedBox(width: AppSpacing.stackSM),
              Text('باقات الاشتراك', style: AppTypography.headlineMD),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          for (final plan in plans) ...[
            _PlanCard(plan: plan),
            const SizedBox(height: AppSpacing.stackLG),
          ],
        ],
      ],
    );
  }

  Widget _buildLoading() {
    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: 72,
        bottom: 100,
      ),
      children: [
        const _Header(),
        const SizedBox(height: 48),
        Row(
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.primary),
            const SizedBox(width: AppSpacing.stackSM),
            Text('شهاداتك الرقمية', style: AppTypography.headlineMD),
          ],
        ),
        const SizedBox(height: AppSpacing.stackMD),
        for (int i = 0; i < 2; i++) _ShimmerCard(),
        const SizedBox(height: 48),
        Row(
          children: [
            const Icon(Icons.storefront, color: AppColors.primary),
            const SizedBox(width: AppSpacing.stackSM),
            Text('باقات الاشتراك', style: AppTypography.headlineMD),
          ],
        ),
        const SizedBox(height: AppSpacing.stackMD),
        for (int i = 0; i < 2; i++) _ShimmerPlanCard(),
      ],
    );
  }

  Widget _buildError(String message) {
    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: 72,
        bottom: 100,
      ),
      children: [
        const _Header(),
        const SizedBox(height: 48),
        Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                message,
                style: AppTypography.bodyMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<CertificateBloc>()
                      .add(CertificateLoadRequested());
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(
          'تم بنجاح',
          style: AppTypography.headlineMD.copyWith(color: AppColors.primary),
        ),
        content: Text(
          'تم الاشتراك بنجاح!',
          style: AppTypography.bodyMD.copyWith(color: AppColors.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'حسناً',
              style: AppTypography.bodyMD.copyWith(
                  color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(76),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceVariant.withAlpha(76),
                ),
              ),
              const Spacer(),
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.surfaceVariant.withAlpha(76),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          Container(
            width: 180,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.surfaceVariant.withAlpha(76),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.surfaceVariant.withAlpha(51),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerPlanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(76),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.surfaceVariant.withAlpha(76),
            ),
          ),
          const SizedBox(height: AppSpacing.stackSM),
          Container(
            width: 100,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.surfaceVariant.withAlpha(76),
            ),
          ),
          const SizedBox(height: AppSpacing.stackMD),
          for (int i = 0; i < 3; i++) ...[
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceVariant.withAlpha(76),
                  ),
                ),
                const SizedBox(width: AppSpacing.gutter),
                Container(
                  width: 160,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.surfaceVariant.withAlpha(76),
                  ),
                ),
              ],
            ),
            if (i < 2) const SizedBox(height: AppSpacing.gutter),
          ],
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
          style:
              AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
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
            'الشهادات والمتجر',
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
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

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
    this.onShare,
    this.onDownload,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
               Row(
                 children: [
                   Expanded(
                     child: OutlinedButton(
                       onPressed: onShare,
                       style: OutlinedButton.styleFrom(
                         backgroundColor: AppColors.surfaceVariant.withAlpha(128),
                         foregroundColor: AppColors.onSurface,
                         side: BorderSide(
                             color: AppColors.onSurfaceVariant.withAlpha(51)),
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
                             style: AppTypography.labelMD
                                 .copyWith(color: AppColors.onSurface),
                           ),
                           const SizedBox(width: AppSpacing.stackSM),
                           const Icon(Icons.share, size: 18),
                         ],
                       ),
                     ),
                   ),
                   if (onDownload != null) ...[
                     const SizedBox(width: AppSpacing.gutter),
                     Expanded(
                       child: OutlinedButton(
                         onPressed: onDownload,
                         style: OutlinedButton.styleFrom(
                           backgroundColor: AppColors.surfaceVariant.withAlpha(128),
                           foregroundColor: AppColors.onSurface,
                           side: BorderSide(
                               color: AppColors.onSurfaceVariant.withAlpha(51)),
                           padding: const EdgeInsets.symmetric(vertical: 12),
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(AppRadius.lg),
                           ),
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                               'تحميل',
                               style: AppTypography.labelMD
                                   .copyWith(color: AppColors.onSurface),
                             ),
                             const SizedBox(width: AppSpacing.stackSM),
                             const Icon(Icons.download_rounded, size: 18),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ],
               ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PlanModel plan;

  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final isFree = plan.priceCents == 0;

    if (isFree) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          color: AppColors.surfaceContainerHigh.withAlpha(153),
          border:
              Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.name, style: AppTypography.headlineLG),
            const SizedBox(height: AppSpacing.stackSM),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('مجاني', style: AppTypography.headlineXL),
                const SizedBox(width: 4),
                Text(
                  '/ دائماً',
                  style: AppTypography.bodyMD
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stackMD),
            for (final feature in plan.features) ...[
              _FeatureItem(text: feature),
              const SizedBox(height: AppSpacing.gutter),
            ],
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

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(
          color: plan.isPopular
              ? AppColors.primary.withAlpha(76)
              : AppColors.onSurfaceVariant.withAlpha(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.name,
                style: AppTypography.headlineLG.copyWith(
                  color: plan.isPopular
                      ? AppColors.primary
                      : AppColors.onSurface,
                ),
              ),
              if (plan.isPopular)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
              Text(
                (plan.priceCents / 100).toStringAsFixed(0),
                style: AppTypography.headlineXL,
              ),
              const SizedBox(width: 4),
              Text(
                '\$/شهرياً',
                style: AppTypography.bodyMD
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
          for (final feature in plan.features) ...[
            _FeatureItem(
              text: feature,
              color: plan.isPopular ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.gutter),
          ],
          const SizedBox(height: AppSpacing.stackMD),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<CertificateBloc>().add(
                      CertificateSubscribeRequested(
                        planCode: plan.code,
                        billingCycle: 'monthly',
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: plan.isPopular
                    ? AppColors.primaryContainer
                    : AppColors.surfaceVariant,
                foregroundColor: plan.isPopular
                    ? AppColors.onPrimaryContainer
                    : AppColors.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                elevation: 0,
              ).copyWith(
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: Text(
                isFree ? 'الاشتراك' : 'ترقية الحساب الآن',
                style: AppTypography.headlineMD.copyWith(
                  color: plan.isPopular
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurface,
                ),
              ),
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

  const _FeatureItem(
      {required this.text, this.color = AppColors.onSurfaceVariant});

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
