import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/path/path_bloc.dart';
import '../../core/constants/constants.dart';
import '../../core/helper/extension.dart';
import '../../core/models/dashboard_model.dart';
import '../../core/models/path_model.dart';
import '../certificates_store/certificates_store_screen.dart';
import '../lesson_viewing/lesson_viewing_screen.dart';

class PathDetailsScreen extends StatefulWidget {
  final String pathSlug;
  const PathDetailsScreen({super.key, required this.pathSlug});

  @override
  State<PathDetailsScreen> createState() => _PathDetailsScreenState();
}

class _PathDetailsScreenState extends State<PathDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PathBloc>().add(PathDetailLoadRequested(widget.pathSlug));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<PathBloc, PathState>(
            builder: (context, state) {
              if (state is PathLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PathError) {
                return _ErrorView(
                  message: state.message,
                  onRetry: () =>
                      context.read<PathBloc>().add(PathDetailLoadRequested(widget.pathSlug)),
                );
              }
              final path = switch (state) {
                PathDetailLoaded(:final path) => path,
                PathEnrolled(:final path) => path,
                _ => null,
              };
              if (path == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return _PathContent(path: path);
            },
          ),
          BlocBuilder<PathBloc, PathState>(
            builder: (context, state) {
              if (state is! PathDetailLoaded && state is! PathEnrolled) {
                return const SizedBox.shrink();
              }
              final path = state is PathDetailLoaded ? state.path : (state as PathEnrolled).path;
              return _BottomCTA(path: path);
            },
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 56,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.stackMD),
            Text(
              'تعذر تحميل المسار',
              style: AppTypography.headlineMD.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(height: AppSpacing.stackSM),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.stackLG),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: const Color(0xFF15141B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                elevation: 0,
                textStyle: AppTypography.headlineMD,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathContent extends StatelessWidget {
  final PathDetailModel path;
  const _PathContent({required this.path});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: 88,
        bottom: 100,
      ),
      children: [
        const _BackBreadcrumb(),
        const SizedBox(height: AppSpacing.stackLG),
        _HeroSection(path: path),
        if (path.instructor != null) ...[
          const SizedBox(height: AppSpacing.stackLG),
          _InstructorCard(instructor: path.instructor!),
        ],
        if (path.modules.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.stackLG),
          _Roadmap(modules: path.modules),
        ],
        const SizedBox(height: AppSpacing.stackLG),
        _StatsRow(path: path),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _BackBreadcrumb extends StatelessWidget {
  const _BackBreadcrumb();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
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
  final PathDetailModel path;
  const _HeroSection({required this.path});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            child: path.coverImageUrl != null && path.coverImageUrl!.isNotEmpty
                ? Image.network(
                    path.coverImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _BannerPlaceholder(),
                  )
                : const _BannerPlaceholder(),
          ),
        ),
        const SizedBox(height: AppSpacing.stackLG),
        if (path.tags != null && path.tags!.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in path.tags!) _Tag(tag),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMD),
        ],
        Text(
          path.title,
          style: AppTypography.headlineXL.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        if (path.blurb != null && path.blurb!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.stackSM),
          Text(
            path.blurb!,
            style: AppTypography.bodyMD.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.stackMD),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: [
            if (path.estimatedHours != null)
              _MetaChip(Icons.schedule, '${path.estimatedHours} ساعة'),
            if (path.level != null) _MetaChip(Icons.bar_chart, _levelLabel(path.level!)),
            if (path.rating != null)
              _MetaChip(Icons.star, path.rating!.toStringAsFixed(1)),
            _MetaChip(
              Icons.play_circle,
              '${path.totals?.lessonsTotal ?? 0} درس',
            ),
          ],
        ),
      ],
    );
  }
}

String _levelLabel(String level) {
  return switch (level) {
    'beginner' => 'مبتدئ',
    'intermediate' || 'mid' => 'متوسط',
    'advanced' => 'متقدم',
    _ => level,
  };
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.code,
          size: 64,
          color: AppColors.primaryContainer,
        ),
      ),
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
  final InstructorModel instructor;
  const _InstructorCard({required this.instructor});

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
              clipBehavior: Clip.antiAlias,
              child: instructor.avatarUrl != null && instructor.avatarUrl!.isNotEmpty
                  ? Image.network(
                      instructor.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _InstructorPlaceholder(),
                    )
                  : const _InstructorPlaceholder(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instructor.name,
                    style: AppTypography.headlineMD.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  if (instructor.title != null && instructor.title!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      instructor.title!,
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  if (instructor.bio != null && instructor.bio!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      instructor.bio!,
                      style: AppTypography.bodyMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructorPlaceholder extends StatelessWidget {
  const _InstructorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerHigh,
      child: const Icon(
        Icons.person,
        color: AppColors.onSurfaceVariant,
        size: 32,
      ),
    );
  }
}

class _Roadmap extends StatelessWidget {
  final List<ModuleModel> modules;
  const _Roadmap({required this.modules});

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
                for (var i = 0; i < modules.length; i++) ...[
                  _Module(module: modules[i]),
                  if (i != modules.length - 1)
                    const SizedBox(height: AppSpacing.stackLG),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Module extends StatelessWidget {
  final ModuleModel module;
  const _Module({required this.module});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = !module.isLocked;
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
                            module.title,
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
                            _moduleStatusLabel(module),
                            style: AppTypography.labelMD.copyWith(
                              color: isUnlocked ? AppColors.primary : AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (module.description != null && module.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        module.description!,
                        style: AppTypography.bodyMD.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _ModuleMeta(Icons.play_circle, '${module.lessonsCount} درس'),
                        if (module.doneCount > 0) ...[
                          const SizedBox(width: 16),
                          _ModuleMeta(Icons.check_circle, '${module.doneCount} مكتمل'),
                        ],
                      ],
                    ),
                    if (module.lessons.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      for (final lesson in module.lessons)
                        _LessonTile(
                          lesson: lesson,
                          locked: module.isLocked,
                        ),
                    ],
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

String _moduleStatusLabel(ModuleModel module) {
  if (module.isDone) return 'مكتمل';
  if (module.isCurrent) return 'الحالي';
  return module.isLocked ? 'مغلق' : 'مفتوح';
}

class _LessonTile extends StatelessWidget {
  final LessonItemModel lesson;
  final bool locked;

  const _LessonTile({required this.lesson, required this.locked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: locked
          ? null
          : () => context.push(LessonViewingScreen(lessonId: lesson.id)),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              lesson.isCurrent
                  ? Icons.play_circle_fill
                  : lesson.status == 'completed'
                      ? Icons.check_circle
                      : locked
                          ? Icons.lock
                          : Icons.play_circle_outline,
              size: 20,
              color: lesson.isCurrent
                  ? AppColors.primary
                  : lesson.status == 'completed'
                      ? const Color(0xFF5BE49B)
                      : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lesson.title,
                style: AppTypography.bodyMD.copyWith(
                  color: locked ? AppColors.onSurfaceVariant : AppColors.onSurface,
                  fontSize: 14,
                ),
              ),
            ),
            if (lesson.durationMinutes != null)
              Text(
                '${lesson.durationMinutes} د',
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
          ],
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

class _StatsRow extends StatelessWidget {
  final PathDetailModel path;
  const _StatsRow({required this.path});

  @override
  Widget build(BuildContext context) {
    final totals = path.totals;
    return Row(
      children: [
        if (totals != null) ...[
          _StatItem(
            icon: Icons.play_circle,
            value: '${totals.lessonsDone}/${totals.lessonsTotal}',
            label: 'درس مكتمل',
          ),
          const SizedBox(width: 24),
        ],
        if (path.instructor?.studentsCount != null) ...[
          _StatItem(
            icon: Icons.people,
            value: '+${path.instructor!.studentsCount}',
            label: 'طالب',
          ),
          const SizedBox(width: 24),
        ],
        _StatItem(
          icon: Icons.military_tech,
          value: path.progressPct.toString(),
          label: 'نسبة التقدم',
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$value $label',
          style: AppTypography.labelMD.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _BottomCTA extends StatelessWidget {
  final PathDetailModel path;
  const _BottomCTA({required this.path});

  @override
  Widget build(BuildContext context) {
    final isEnrolled = path.isEnrolled || path.progressPct > 0;
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
          child: isEnrolled
              ? _EnrolledCTA(path: path)
              : _EnrollCTA(path: path),
        ),
      ),
    );
  }
}

class _EnrollCTA extends StatelessWidget {
  final PathDetailModel path;
  const _EnrollCTA({required this.path});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (path.requiresUpgrade) {
                context.push(const CertificatesStoreScreen());
                return;
              }
              context.read<PathBloc>().add(PathEnrollRequested(path.slug));
            },
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
            child: Text(path.requiresUpgrade ? 'الترقية للانضمام للمسار' : 'سجل الآن في المسار'),
          ),
        ),
      ],
    );
  }
}

class _EnrolledCTA extends StatelessWidget {
  final PathDetailModel path;
  const _EnrolledCTA({required this.path});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: path.progressPct / 100,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceVariant,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${path.progressPct}% مكتمل',
                style: AppTypography.labelMD.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 180,
          child: ElevatedButton(
            onPressed: () {
              final current = path.modules
                  .where((m) => !m.isLocked)
                  .expand((m) => m.lessons)
                  .toList();
              final next = current
                  .where((l) => l.status != 'completed')
                  .firstOrNull ?? current.firstOrNull;
              if (next != null) {
                context.push(LessonViewingScreen(lessonId: next.id));
              }
            },
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
            child: const Text('متابعة التعلم'),
          ),
        ),
      ],
    );
  }
}
