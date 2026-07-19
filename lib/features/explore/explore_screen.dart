import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/helper/extension.dart';
import '../home/dashboard_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _Body(),
          const _BottomNav(),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: 88,
        bottom: 104,
      ),
      children: [
        _Header(),
        const SizedBox(height: AppSpacing.stackLG),
        _SearchBar(),
        const SizedBox(height: AppSpacing.stackLG),
        _CategoryChips(),
        const SizedBox(height: AppSpacing.stackLG),
        _CourseGrid(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'استكشف المسارات',
          style: AppTypography.headlineXL.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: AppSpacing.stackSM),
        Text(
          'ابحث عن الدورة المناسبة لمستواك التقني.',
          style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: TextDirection.rtl,
      style: AppTypography.bodyMD.copyWith(color: AppColors.onSurface),
      decoration: InputDecoration(
        hintText: 'ابحث عن دورة، تقنية، أو مدرب...',
        hintStyle: AppTypography.bodyMD.copyWith(
          color: AppColors.onSurfaceVariant.withAlpha(128),
        ),
        prefixIcon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<_Category> categories = const [
    _Category('الكل', true),
    _Category('Flutter', false),
    _Category('Python', false),
    _Category('Web', false),
    _Category('AI', false),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.unit),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _Chip(cat: cat);
        },
      ),
    );
  }
}

class _Category {
  final String label;
  final bool isActive;
  const _Category(this.label, this.isActive);
}

class _Chip extends StatelessWidget {
  final _Category cat;
  const _Chip({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cat.isActive
            ? AppColors.primary.withAlpha(38)
            : AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: cat.isActive
              ? AppColors.primary.withAlpha(77)
              : AppColors.outlineVariant,
        ),
      ),
      child: Center(
        child: Text(
          cat.label,
          style: AppTypography.labelMD.copyWith(
            color: cat.isActive ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _CourseGrid extends StatelessWidget {
  final List<_Course> courses = const [
    _Course(
      title: 'أساسيات بايثون للذكاء الاصطناعي',
      instructor: 'م. أحمد سامي',
      students: '1.2k طالب',
      level: 'مبتدئ',
      levelColor: AppColors.secondary,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDQMu-tukfSrhyRy6LaAKTe70wTXKSJJU6mNGicz80YfLEwaIMGx_HUm1dxhQppNW9r1Z8m0wGtqjrKNlOAaNvrMPiAdt4aZMcLd6KdTZKXMVDRYUrgV5Th--NLNbwgVcRxIzhIH6MgnypCMYsBACvS-h8fMx3NJjfdQVZNgT6mKsiyQ5L38Rmk27ubu8qjN1iYT8QaSUBwuSq9nQpx_yb4ho40fCfjOeQFHcuwvourcLYQA5Gw6qUiZ6i1R4sgAXhwFJjeHzAsiA',
    ),
    _Course(
      title: 'بناء تطبيقات تفاعلية بـ Flutter',
      instructor: 'سارة الخالد',
      students: '850 طالب',
      level: 'متوسط',
      levelColor: AppColors.tertiary,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC4u4B7D-wvCW-JQerrCw_y1466fWxZuOLuvuVaP_4hH3cOptU1osfIlZOvwpFQjWVCXmGoOoLyBLBkxiZyd9UVmGkr1DJsr-u-jXDDScFxoxHTdxbsLpB304q5J9iX2-5kteas-GdFbQNY7Wsp75OYJBZ8bsbK9-tm1kJnOAH2gDxo5VfP_QiC5crDSmlznwgVn_ZFHIC8Qf3yq6xiun7NluPDohOxj4Rg5jJnpfBTphQ98wQ1j11ycBHtPtku4Xg8Gfj79ZsKJQ',
    ),
    _Course(
      title: 'هندسة الواجهات الخلفية المتقدمة',
      instructor: 'د. طارق محمود',
      students: '420 طالب',
      level: 'خبير',
      levelColor: AppColors.error,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDpj5LUNRkNhoMOWdi3uej8z95AZiVtD3Pg3C-PYhrg3BHcOoa7w5xTSr6rbTWdmi3t40PZN9CxxPVsK6BFCGjkuXx7mxWVEvLqh7Xc3M73CYLyQGy3lYnFqS1FrvAPt2gkdM5dqzSgLR2KyL_yHGYhSVdaf-jO3a4jsZ8654UQM7f80Wl2egIl7I3j__zrDlCZ-fwetnCYbe_eO6w0N5OaENMRme-ahH2z8IceVKqSIs0L0Rz5kbiD91D1PdRetvoYmkhrtT7tFg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final course in courses) ...[
          _CourseCard(course: course),
          const SizedBox(height: AppSpacing.gutter),
        ],
      ],
    );
  }
}

class _Course {
  final String title;
  final String instructor;
  final String students;
  final String level;
  final Color levelColor;
  final String imageUrl;

  const _Course({
    required this.title,
    required this.instructor,
    required this.students,
    required this.level,
    required this.levelColor,
    required this.imageUrl,
  });
}

class _CourseCard extends StatelessWidget {
  final _Course course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1C29),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            child: Stack(
              children: [
                SizedBox(
                  height: 128,
                  width: double.infinity,
                  child: Image.network(
                    course.imageUrl,
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.6),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF1E1C29),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: course.levelColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: course.levelColor.withAlpha(51)),
                      ),
                      child: Text(
                        course.level,
                        style: AppTypography.labelMD.copyWith(
                          color: course.levelColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  course.title,
                  style: AppTypography.headlineMD.copyWith(color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  course.instructor,
                  style: AppTypography.bodyMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.group, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      course.students,
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
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
                    isActive: false,
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
                    isActive: true,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'الرئيسية',
                    isActive: false,
                    onTap: () => context.pushAndRemoveUntil(const DashboardScreen()),
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
