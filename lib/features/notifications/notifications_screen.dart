import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _TopBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
              child: _ClearAllRow(),
            ),
            const SizedBox(height: AppSpacing.stackLG),
            const _SectionHeader(title: 'اليوم'),
            const _NotificationCard(
              icon: Icons.emoji_events,
              iconBg: AppColors.primaryContainer,
              iconColor: AppColors.primary,
              iconFill: true,
              title: 'تحدي الخوارزميات الجديد متاح',
              time: 'منذ ساعتين',
              body: 'انضم الآن لتحدي "البحث الثنائي المتقدم" واكسب 50 نقطة خبرة.',
              unread: true,
            ),
            const _NotificationCard(
              icon: Icons.forum,
              iconBg: AppColors.secondaryContainer,
              iconColor: AppColors.secondary,
              iconFill: true,
              title: 'رد جديد من AhmedDev',
              time: 'منذ 4 ساعات',
              body: 'قام بالرد على سؤالك في قسم "React Hooks".',
              unread: true,
            ),
            const SizedBox(height: AppSpacing.stackMD),
            const _SectionHeader(title: 'الأمس'),
            const _NotificationCard(
              icon: Icons.military_tech,
              iconBg: AppColors.tertiaryContainer,
              iconColor: AppColors.tertiaryContainer,
              iconFill: true,
              title: 'حصلت على شارة "مصلح الأخطاء"',
              time: 'الأمس، 14:30',
              body: 'لقد قمت بحل 10 أخطاء برمجية بنجاح هذا الأسبوع. واصل التألق!',
              unread: false,
            ),
            const _NotificationCard(
              icon: Icons.groups,
              iconBg: AppColors.primaryContainer,
              iconColor: AppColors.primary,
              iconFill: false,
              title: 'لقاء مجتمع بايثون',
              time: 'الأمس، 09:15',
              body: 'تذكير: اللقاء الأسبوعي يبدأ بعد 15 دقيقة في الغرفة الصوتية.',
              unread: false,
            ),
            const SizedBox(height: AppSpacing.stackMD),
            const _SectionHeader(title: 'سابقاً'),
            const _NotificationCard(
              icon: Icons.update,
              iconBg: AppColors.surfaceVariant,
              iconColor: AppColors.onSurfaceVariant,
              iconFill: false,
              title: 'تحديث النظام v2.4',
              time: '12 مايو',
              body: 'تم إضافة ميزات جديدة لبيئة التطوير المدمجة. اقرأ سجل التغييرات.',
              unread: false,
            ),
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
            'الإشعارات',
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
              child: const Icon(Icons.done_all, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClearAllRow extends StatelessWidget {
  const _ClearAllRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مسح الكل',
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.primary.withAlpha(204),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.stackSM,
      ),
      child: Text(
        title,
        style: AppTypography.headlineMD.copyWith(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final bool iconFill;
  final String title;
  final String time;
  final String body;
  final bool unread;

  const _NotificationCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.iconFill,
    required this.title,
    required this.time,
    required this.body,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
        vertical: AppSpacing.stackSM / 2,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            color: AppColors.surfaceContainerHigh.withAlpha(153),
            border: Border.all(
              color: unread
                  ? AppColors.primary.withAlpha(128)
                  : AppColors.onSurfaceVariant.withAlpha(25),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (unread)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 16, left: 12),
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
                if (!unread) const SizedBox(width: 20),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    color: iconBg.withAlpha(25),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTypography.headlineMD.copyWith(
                                color: AppColors.onSurface,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: AppTypography.codeSM.copyWith(
                              color: AppColors.onSurfaceVariant.withAlpha(153),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: AppTypography.codeSM.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
