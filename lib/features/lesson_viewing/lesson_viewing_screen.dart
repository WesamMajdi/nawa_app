import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nawa_flutter/core/blocs/lesson/lesson_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/models/lesson_model.dart';

class LessonViewingScreen extends StatefulWidget {
  final String lessonId;
  const LessonViewingScreen({super.key, required this.lessonId});

  @override
  State<LessonViewingScreen> createState() => _LessonViewingScreenState();
}

class _LessonViewingScreenState extends State<LessonViewingScreen> {
  LessonDetailModel? _lesson;

  @override
  void initState() {
    super.initState();
    context.read<LessonBloc>().add(LessonLoadRequested(widget.lessonId));
  }

  void _handleComplete() {
    final lesson = _lesson;
    if (lesson == null) return;
    switch (lesson.type) {
      case 'video':
        context.read<LessonBloc>().add(LessonCompleteRequested(lesson.id));
      case 'code':
        context.read<LessonBloc>().add(LessonSubmitCodeRequested(
          id: lesson.id,
          sourceCode: lesson.starterCode ?? '',
          languageCode: lesson.languageCode ?? '',
        ));
      case 'quiz':
        context.read<LessonBloc>().add(LessonSubmitQuizRequested(
          id: lesson.id,
          answers: [],
        ));
    }
  }

  void _showCompletionDialog(LessonCompletionResult result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: const Text('أحسنت!', style: AppTypography.headlineMD),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('+${result.xpAwarded} XP', style: AppTypography.headlineXL.copyWith(color: AppColors.primary)),
            const SizedBox(height: 8),
            Text('المجموع: ${result.newXpTotal} XP', style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant)),
            Text('المستوى: ${result.level}', style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('متابعة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonBloc, LessonState>(
      listener: (context, state) {
        if (state is LessonCompleted) {
          _showCompletionDialog(state.result);
        }
      },
      builder: (context, state) {
        if (state is LessonLoaded) {
          _lesson = state.lesson;
        }
        if (state is LessonLoading || state is LessonInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is LessonError) {
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
                      onPressed: () => context.read<LessonBloc>().add(LessonLoadRequested(widget.lessonId)),
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
        final lesson = _lesson;
        if (lesson == null) return const SizedBox.shrink();
        return Scaffold(
          body: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  _TopBar(lesson: lesson),
                  if (lesson.type == 'video') _VideoPlayerArea(lesson: lesson),
                  if (lesson.type == 'code') _CodeContent(lesson: lesson),
                  if (lesson.type == 'quiz') _QuizContent(lesson: lesson),
                  _LessonHeader(lesson: lesson),
                  _ContentTabs(),
                  const SizedBox(height: 100),
                ],
              ),
              _BottomBar(
                lesson: lesson,
                onComplete: _handleComplete,
                showCompleted: state is LessonCompleted || lesson.isCompleted,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final LessonDetailModel lesson;
  const _TopBar({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(204),
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withAlpha(25))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: AppColors.onSurface),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'المسار: ${lesson.pathContext.pathTitle}',
                    style: AppTypography.labelMD.copyWith(color: AppColors.onSurfaceVariant, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    lesson.pathContext.moduleTitle,
                    style: AppTypography.headlineMD.copyWith(color: AppColors.onSurface),
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

class _VideoPlayerArea extends StatelessWidget {
  final LessonDetailModel lesson;
  const _VideoPlayerArea({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            if (lesson.videoUrl != null)
              Image.network(
                lesson.videoUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                opacity: const AlwaysStoppedAnimation(0.7),
                errorBuilder: (_, _, _) => Container(color: Colors.black),
              )
            else
              Container(color: Colors.black),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.surfaceVariant.withAlpha(102),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
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
                        boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(128), blurRadius: 10)],
                      ),
                    ),
                  ),
                  Expanded(flex: 55, child: Container()),
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
                Text('04:15 / 12:30',
                    style: AppTypography.codeSM.copyWith(color: AppColors.onSurfaceVariant)),
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

class _CodeContent extends StatelessWidget {
  final LessonDetailModel lesson;
  const _CodeContent({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lesson.instructionsMd != null) ...[
            Text(
              lesson.instructionsMd!,
              style: AppTypography.bodyMD.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
          ],
          if (lesson.starterCode != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(128),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: SelectableText(
                lesson.starterCode!,
                style: AppTypography.codeSM.copyWith(color: Colors.greenAccent, fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuizContent extends StatelessWidget {
  final LessonDetailModel lesson;
  const _QuizContent({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final questions = lesson.quiz ?? [];
    if (questions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: questions.map((q) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q.question, style: AppTypography.bodyMD.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              ...q.options.map((o) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(q.allowMultiple ? Icons.check_box_outline_blank : Icons.radio_button_unchecked,
                        size: 20, color: Colors.white54),
                    const SizedBox(width: 8),
                    Text(o.text, style: AppTypography.bodyMD.copyWith(color: Colors.white70)),
                  ],
                ),
              )),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  final LessonDetailModel lesson;
  const _LessonHeader({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.containerMargin),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withAlpha(25))),
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
                    lesson.type == 'video' ? 'درس فيديو' : lesson.type == 'code' ? 'تحدي برمجي' : 'اختبار',
                    style: AppTypography.labelMD.copyWith(color: AppColors.primary, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.title,
                  style: AppTypography.headlineLG.copyWith(color: AppColors.onSurface),
                ),
                if (lesson.instructionsMd != null && lesson.type == 'video') ...[
                  const SizedBox(height: 8),
                  Text(
                    lesson.instructionsMd!,
                    style: AppTypography.bodyMD.copyWith(color: AppColors.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
                  border: Border.all(
                    color: lesson.isCompleted ? AppColors.primary : AppColors.outlineVariant,
                  ),
                ),
                child: Icon(
                  lesson.isCompleted ? Icons.check : Icons.check,
                  color: lesson.isCompleted ? AppColors.primary : AppColors.outlineVariant,
                  size: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lesson.isCompleted ? 'مكتمل' : 'لم يكتمل',
                style: AppTypography.labelMD.copyWith(
                  color: lesson.isCompleted ? AppColors.primary : AppColors.onSurfaceVariant,
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
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withAlpha(25))),
        color: AppColors.background.withAlpha(242),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text('محتوى الدورة', style: AppTypography.headlineMD.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.full)),
                    boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(128), blurRadius: 8)],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text('الملاحظات', style: AppTypography.headlineMD.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 8),
                Container(height: 3, color: Colors.transparent),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text('المرفقات', style: AppTypography.headlineMD.copyWith(color: AppColors.onSurfaceVariant)),
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

class _BottomBar extends StatelessWidget {
  final LessonDetailModel lesson;
  final VoidCallback onComplete;
  final bool showCompleted;

  const _BottomBar({
    required this.lesson,
    required this.onComplete,
    required this.showCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final String buttonText = switch (lesson.type) {
      'video' => showCompleted ? 'تم الإكمال ✓' : 'إكمال الدرس',
      'code' => showCompleted ? 'تم التقديم ✓' : 'تقديم الكود',
      'quiz' => showCompleted ? 'تم التقديم ✓' : 'تقديم الإجابات',
      _ => 'إكمال',
    };

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.containerMargin),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withAlpha(102),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 30, offset: const Offset(0, -10)),
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
                child: const Icon(Icons.edit_note, color: AppColors.onSurface, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: showCompleted ? null : onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showCompleted ? AppColors.surfaceVariant : AppColors.primary,
                      foregroundColor: showCompleted ? AppColors.onSurfaceVariant : AppColors.onPrimary,
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
                        Text(buttonText),
                        const SizedBox(width: 8),
                        Icon(showCompleted ? Icons.check : Icons.arrow_back, size: 20),
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
