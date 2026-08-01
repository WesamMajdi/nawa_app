import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/path/path_bloc.dart';
import '../../core/constants/constants.dart';
import '../../core/helper/extension.dart';
import '../../core/models/dashboard_model.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../path_details/path_details_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _Body(),
          AppBottomNav(
            currentTab: NavTab.explore,
            onHomeTap: () => context.pushAndRemoveUntil(const ExploreScreen()),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  String? _selectedTag;

  static const _tags = ['الكل', 'Flutter', 'Python', 'Web', 'AI'];

  @override
  void initState() {
    super.initState();
    context.read<PathBloc>().add(PathListLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.containerMargin,
            right: AppSpacing.containerMargin,
            top: 88,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              SizedBox(height: AppSpacing.stackLG),
              _SearchBar(),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.stackLG),
        _CategoryChips(
          selectedTag: _selectedTag,
          onSelect: (tag) {
            setState(() => _selectedTag = tag);
            context.read<PathBloc>().add(PathListLoadRequested(tag: tag));
          },
        ),
        const SizedBox(height: AppSpacing.stackLG),
        Expanded(
          child: BlocBuilder<PathBloc, PathState>(
            builder: (context, state) {
              if (state is PathLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PathError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        style: AppTypography.bodyMD
                            .copyWith(color: AppColors.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.stackMD),
                      ElevatedButton(
                        onPressed: () => context
                            .read<PathBloc>()
                            .add(PathListLoadRequested(tag: _selectedTag)),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }
              final paths = state is PathListLoaded ? state.paths : const <PathCardModel>[];
              return ListView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.containerMargin,
                  right: AppSpacing.containerMargin,
                  bottom: 104,
                ),
                children: [
                  for (final path in paths) ...[
                    _CourseCard(path: path),
                    const SizedBox(height: AppSpacing.gutter),
                  ],
                ],
              );
            },
          ),
        ),
      ],
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
  const _SearchBar();

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
  final String? selectedTag;
  final ValueChanged<String?> onSelect;

  const _CategoryChips({required this.selectedTag, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
        itemCount: _BodyState._tags.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.unit),
        itemBuilder: (context, index) {
          final label = _BodyState._tags[index];
          final isActive = (index == 0 && selectedTag == null) ||
              selectedTag == label;
          return _Chip(
            label: label,
            isActive: isActive,
            onTap: () => onSelect(index == 0 ? null : label),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withAlpha(38)
              : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withAlpha(77)
                : AppColors.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelMD.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final PathCardModel path;

  const _CourseCard({required this.path});

  Color get _levelColor => switch (path.level) {
        'beginner' => AppColors.secondary,
        'intermediate' => AppColors.tertiary,
        'advanced' => AppColors.error,
        _ => AppColors.onSurfaceVariant,
      };

  String get _levelLabel => switch (path.level) {
        'beginner' => 'مبتدئ',
        'intermediate' => 'متوسط',
        'advanced' => 'خبير',
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(PathDetailsScreen(pathSlug: path.slug)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1C29),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 128,
                    width: double.infinity,
                    child: path.coverImageUrl != null
                        ? Image.network(
                            path.coverImageUrl!,
                            fit: BoxFit.cover,
                            opacity: const AlwaysStoppedAnimation(0.6),
                            errorBuilder: (_, _, _) =>
                                const _CourseBannerFallback(),
                          )
                        : const _CourseBannerFallback(),
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _levelColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: _levelColor.withAlpha(51)),
                        ),
                        child: Text(
                          _levelLabel,
                          style: AppTypography.labelMD.copyWith(
                            color: _levelColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (path.requiresUpgrade) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.lock,
                            size: 14, color: AppColors.onSurfaceVariant),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    path.title,
                    style: AppTypography.headlineMD
                        .copyWith(color: AppColors.onSurface),
                  ),
                  if (path.blurb != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      path.blurb!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  if (path.instructor != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      path.instructor!.name,
                      style: AppTypography.bodyMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.group,
                          size: 16, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${path.learnersCount ?? 0} طالب',
                        style: AppTypography.labelMD.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      if (path.rating != null) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.star,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          path.rating!.toStringAsFixed(1),
                          style: AppTypography.labelMD.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
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

class _CourseBannerFallback extends StatelessWidget {
  const _CourseBannerFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      width: double.infinity,
      color: AppColors.primaryContainer.withAlpha(76),
      child: const Icon(
        Icons.menu_book,
        size: 48,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
