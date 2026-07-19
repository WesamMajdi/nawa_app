import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/helper/extension.dart';
import '../registration_confirmation/registration_confirmation_screen.dart';

class PathDetailsScreen extends StatelessWidget {
  const PathDetailsScreen({super.key});

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
              bottom: 100,
            ),
            children: [
              _BackBreadcrumb(),
              const SizedBox(height: AppSpacing.stackLG),
              _HeroSection(),
              const SizedBox(height: AppSpacing.stackLG),
              _InstructorCard(),
              const SizedBox(height: AppSpacing.stackLG),
              _Roadmap(),
              const SizedBox(height: AppSpacing.stackLG),
              _RecentStudents(),
              const SizedBox(height: 24),
            ],
          ),
          const _BottomCTA(),
        ],
      ),
    );
  }
}

class _BackBreadcrumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'العودة',
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '/',
          style: AppTypography.labelMD.copyWith(
            color: AppColors.outlineVariant,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'الاستكشاف',
          style: AppTypography.labelMD.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner
        Container(
          height: 192,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.primary.withAlpha(51)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withAlpha(30),
                blurRadius: 30,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Stack(
              children: [
                Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: Icon(
                      Icons.code,
                      size: 64,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Tag('Flutter'),
                      const SizedBox(width: 8),
                      _Tag('Dart'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.stackLG),
        // Info
        Text(
          'مسار مطور تطبيقات Flutter المتقدم',
          style: AppTypography.headlineXL.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.stackSM),
        Text(
          'تعلم بناء تطبيقات هواتف ذكية عالية الأداء تدعم أنظمة iOS و Android باستخدام إطار عمل Flutter ولغة Dart. يبدأ المسار من الأساسيات وصولاً إلى المعماريات المتقدمة وربط قواعد البيانات.',
          style: AppTypography.bodyMD.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.stackMD),
        Row(
          children: [
            _MetaChip(Icons.schedule, '12 أسبوع'),
            const SizedBox(width: 24),
            _MetaChip(Icons.bar_chart, 'مستوى متوسط'),
            const SizedBox(width: 24),
            _MetaChip(Icons.military_tech, 'شهادة معتمدة'),
          ],
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withAlpha(38),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.primary.withAlpha(51)),
      ),
      child: Text(
        label,
        style: AppTypography.labelMD.copyWith(
          color: const Color(0xFF5BE49B),
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.labelMD.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _InstructorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withAlpha(12),
            Colors.white.withAlpha(0),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withAlpha(77)),
                color: AppColors.surfaceContainerHigh,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.onSurfaceVariant,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أحمد محمود',
                    style: AppTypography.headlineMD.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Senior Mobile Developer',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'خبير في تطوير تطبيقات الموبايل بأكثر من 8 سنوات خبرة. قاد فرق تقنية في شركات ناشئة كبرى وساهم في بناء تطبيقات يستخدمها الملايين.',
                    style: AppTypography.bodyMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
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

class _Roadmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'محتوى المسار',
          style: AppTypography.headlineLG.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.stackLG),
        Stack(
          children: [
            // Timeline line
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 2,
                  margin: const EdgeInsets.only(right: 15),
                  color: AppColors.surfaceVariant,
                ),
              ),
            ),
            Column(
              children: [
                _Module(
                  title: 'مقدمة',
                  description: 'نظرة عامة على بيئة العمل وإعداد الأدوات اللازمة للبدء.',
                  lessons: '3 دروس',
                  exercise: '1 تمرين',
                  isUnlocked: true,
                ),
                const SizedBox(height: AppSpacing.stackLG),
                _Module(
                  title: 'أساسيات لغة Dart',
                  description: 'المتغيرات، الدوال، البرمجة الكائنية التوجه (OOP) في Dart.',
                  lessons: '8 دروس',
                  exercise: '3 تمارين',
                  isUnlocked: false,
                ),
                const SizedBox(height: AppSpacing.stackLG),
                _Module(
                  title: 'بناء الواجهات',
                  description: 'التعامل مع الـ Widgets، تصميم واجهات مستخدم متجاوبة.',
                  lessons: '12 درس',
                  exercise: 'مشروع مصغر',
                  isUnlocked: false,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Module extends StatelessWidget {
  final String title;
  final String description;
  final String lessons;
  final String exercise;
  final bool isUnlocked;

  const _Module({
    required this.title,
    required this.description,
    required this.lessons,
    required this.exercise,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.surfaceVariant),
            gradient: isUnlocked
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withAlpha(12),
                      Colors.transparent,
                    ],
                  )
                : null,
          ),
          child: Stack(
            children: [
              if (isUnlocked)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 4, color: AppColors.primary.withAlpha(128)),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTypography.headlineMD.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? AppColors.primary.withAlpha(25)
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            isUnlocked ? 'مفتوح' : 'مغلق',
                            style: AppTypography.labelMD.copyWith(
                              color: isUnlocked ? AppColors.primary : AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: AppTypography.bodyMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ModuleMeta(Icons.play_circle, lessons),
                        const SizedBox(width: 16),
                        _ModuleMeta(Icons.assignment, exercise),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleMeta extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ModuleMeta(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.labelMD.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _RecentStudents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'منضمون حديثاً',
              style: AppTypography.headlineMD.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            Text(
              '+240 طالب',
              style: AppTypography.labelMD.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: Stack(
            children: [
              Positioned(right: 0, child: const _Avatar(icon: Icons.person)),
              Positioned(right: 16, child: const _Avatar(icon: Icons.person)),
              Positioned(right: 32, child: const _Avatar(icon: Icons.person)),
              Positioned(right: 48, child: const _Avatar(icon: Icons.person)),
              Positioned(right: 64, child: const _AvatarOverflow()),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final IconData icon;

  const _Avatar({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.background, width: 2),
      ),
      child: Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
    );
  }
}

class _AvatarOverflow extends StatelessWidget {
  const _AvatarOverflow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withAlpha(51),
        border: Border.all(color: AppColors.background, width: 2),
      ),
      child: Center(
        child: Text(
          '+99',
          style: AppTypography.labelMD.copyWith(
            color: AppColors.primary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  const _BottomCTA();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        decoration: BoxDecoration(
          color: AppColors.background.withAlpha(230),
          border: Border(
            top: BorderSide(color: AppColors.surfaceVariant.withAlpha(128)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'مجاناً',
                    style: AppTypography.headlineMD.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    '500\$',
                    style: AppTypography.bodyMD.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => context.push(const RegistrationConfirmationScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: const Color(0xFF15141B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    elevation: 0,
                    textStyle: AppTypography.headlineMD,
                  ).copyWith(
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: const Text('سجل الآن في المسار'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
