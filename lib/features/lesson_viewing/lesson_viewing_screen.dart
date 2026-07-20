import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class LessonViewingScreen extends StatelessWidget {
  const LessonViewingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _TopBar(),
              _VideoPlayer(),
              _LessonHeader(),
              _ContentTabs(),
              _LessonList(),
              const SizedBox(height: 100),
            ],
          ),
          const _BottomBar(),
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
        color: AppColors.background.withAlpha(204),
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant.withAlpha(25)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: AppColors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'المسار: مطور الواجهات الأمامية',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'أساسيات جافاسكربت الحديثة',
                    style: AppTypography.headlineMD.copyWith(
                      color: AppColors.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _VideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC0kFrcLqQoE0r1hcfY29kVWRlDxNUq4BgI5XWAblqd52GIoZJC6mMU_iU5tCEEGeFebmsFHHZeT4FpwYXboommy_gmQfJxCR7L-S062JBI4pX3wEaQjkfkUIHLFphcraGpugWDRreSbfDX-YncRn-l0GrREGmbQVV5QUwiwFprLHyMHS8F0wVvj-aEBFG82ROJXhS8XHLhm0bWYYRNGQvoFoRxJvmEW-nzWFDMpOoU3U6KIS16k2hBbvrm0J_-OmNbGlahXwBFUw',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              opacity: const AlwaysStoppedAnimation(0.7),
            ),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.surfaceVariant.withAlpha(102),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            _VideoControls(),
          ],
        ),
      ),
    );
  }
}

class _VideoControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withAlpha(128),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 45,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(128),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 55,
                    child: Container(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                const SizedBox(width: 16),
                const Icon(Icons.volume_up, color: Colors.white, size: 20),
                const SizedBox(width: 16),
                Text(
                  '04:15 / 12:30',
                  style: AppTypography.codeSM.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.closed_caption, color: Colors.white, size: 20),
                const SizedBox(width: 16),
                const Icon(Icons.settings, color: Colors.white, size: 20),
                const SizedBox(width: 16),
                const Icon(Icons.fullscreen, color: Colors.white, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.containerMargin),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant.withAlpha(25)),
        ),
        color: AppColors.surface.withAlpha(77),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withAlpha(51),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.primary.withAlpha(51)),
                  ),
                  child: Text(
                    'الدرس الثالث',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'التعامل مع الوعود (Promises) في جافاسكربت',
                  style: AppTypography.headlineLG.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'تعلم كيفية إدارة العمليات غير المتزامنة بشكل احترافي وتجنب "جحيم الاستدعاءات" (Callback Hell).',
                  style: AppTypography.bodyMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.outlineVariant,
                  size: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'مكتمل',
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContentTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant.withAlpha(25)),
        ),
        color: AppColors.background.withAlpha(242),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  'محتوى الدورة',
                  style: AppTypography.headlineMD.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.full),
                    ),
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
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  'الملاحظات',
                  style: AppTypography.headlineMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 3, color: Colors.transparent),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  'المرفقات',
                  style: AppTypography.headlineMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 3, color: Colors.transparent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonList extends StatelessWidget {
  static void _navigateToLesson(BuildContext context, String title) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LessonViewingScreen(),
      ),
    );
  }

  static void _showLocked(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('هذا الدرس مقفل، يرجى إكمال الدروس السابقة'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.containerMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'الوحدة 1: الأساسيات المتقدمة',
                style: AppTypography.headlineMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '3 / 5 مكتمل',
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                    fontFamily: AppTypography.fontMono,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _LessonCard(
            icon: Icons.check,
            iconColor: AppColors.primary,
            iconBg: AppColors.primary.withAlpha(25),
            iconBorder: AppColors.primary.withAlpha(51),
            title: 'مراجعة سريعة للمتغيرات والنطاق (Scope)',
            duration: '08:45',
            onTap: () => _navigateToLesson(context, 'مراجعة سريعة للمتغيرات والنطاق (Scope)'),
          ),
          const SizedBox(height: AppSpacing.gutter),
          _LessonCard(
            icon: Icons.check,
            iconColor: AppColors.primary,
            iconBg: AppColors.primary.withAlpha(25),
            iconBorder: AppColors.primary.withAlpha(51),
            title: 'مفهوم عدم التزامن (Asynchrony)',
            duration: '15:20',
            onTap: () => _navigateToLesson(context, 'مفهوم عدم التزامن (Asynchrony)'),
          ),
          const SizedBox(height: AppSpacing.gutter),
          _ActiveLessonCard(
            onTap: () => _navigateToLesson(context, 'التعامل مع الوعود (Promises) في جافاسكربت'),
          ),
          const SizedBox(height: AppSpacing.gutter),
          _LockedLessonCard(
            icon: Icons.lock,
            title: 'استخدام Async / Await',
            duration: '20:15',
            onTap: () => _showLocked(context),
          ),
          const SizedBox(height: AppSpacing.gutter),
          _LockedLessonCard(
            icon: Icons.code,
            title: 'تحدي: جلب بيانات من API خارجي',
            duration: 'مشروع عملي',
            isSquare: true,
            onTap: () => _showLocked(context),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color iconBorder;
  final String title;
  final String duration;
  final VoidCallback? onTap;

  const _LessonCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.iconBorder,
    required this.title,
    required this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceVariant.withAlpha(102),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBg,
              border: Border.all(color: iconBorder),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMD.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.play_circle, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontFamily: AppTypography.fontMono,
                      ),
                    ),
                  ],
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

class _ActiveLessonCard extends StatelessWidget {
  final VoidCallback? onTap;

  const _ActiveLessonCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainer,
        border: Border.all(color: AppColors.primary.withAlpha(77)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 24,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(128),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.play_arrow, color: AppColors.onPrimary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التعامل مع الوعود (Promises) في جافاسكربت',
                      style: AppTypography.headlineMD.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(25),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(color: AppColors.primary.withAlpha(51)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.graphic_eq,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'يتم التشغيل الآن',
                                style: AppTypography.labelMD.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '12:30',
                          style: AppTypography.labelMD.copyWith(
                            color: AppColors.primary.withAlpha(204),
                            fontSize: 12,
                            fontFamily: AppTypography.fontMono,
                          ),
                        ),
                      ],
                    ),
                  ],
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

class _LockedLessonCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String duration;
  final bool isSquare;
  final VoidCallback? onTap;

  const _LockedLessonCard({
    required this.icon,
    required this.title,
    required this.duration,
    this.isSquare = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(25)),
        color: AppColors.surfaceContainerLowest,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: isSquare
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.outlineVariant),
                    color: AppColors.surfaceVariant.withAlpha(77),
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
            child: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isSquare ? Icons.task : Icons.schedule,
                      size: 16,
                      color: AppColors.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.outline,
                        fontSize: 12,
                        fontFamily: !isSquare ? AppTypography.fontMono : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // Override opacity via the Opacity wrapper
    ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withAlpha(102),
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
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: const Icon(
                  Icons.edit_note,
                  color: AppColors.onSurface,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _LessonList._navigateToLesson(context, 'الدرس التالي');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
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
                        Text('الدرس التالي'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_back, size: 20),
                      ],
                    ),
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
