import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:nawa_flutter/core/models/leaderboard_model.dart';
import '../../core/constants/constants.dart';
import '../../core/widgets/app_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedPeriod = 'weekly';

  @override
  void initState() {
    super.initState();
    context.read<LeaderboardBloc>().add(
      LeaderboardLoadRequested(period: _selectedPeriod),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<LeaderboardBloc, LeaderboardState>(
            builder: (context, state) {
              if (state is LeaderboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is LeaderboardLoaded) {
                return _buildBody(state);
              }
              if (state is LeaderboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: AppTypography.bodyMD),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<LeaderboardBloc>().add(
                          LeaderboardLoadRequested(period: _selectedPeriod),
                        ),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const _TopBar(),
          const AppBottomNav(currentTab: NavTab.challenges),
        ],
      ),
    );
  }

  Widget _buildBody(LeaderboardLoaded state) {
    final entries = state.entries;
    final podium = entries.where((e) => e.rank <= 3).toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));
    final rankedList = entries.where((e) => e.rank > 3).toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));

    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.containerMargin,
        right: AppSpacing.containerMargin,
        top: 88,
        bottom: 120,
      ),
      children: [
        const _Header(),
        const SizedBox(height: AppSpacing.stackMD),
        _PeriodSelector(
          selectedPeriod: _selectedPeriod,
          onChanged: (period) {
            setState(() => _selectedPeriod = period);
            context.read<LeaderboardBloc>().add(
              LeaderboardLoadRequested(period: period),
            );
          },
        ),
        if (podium.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.stackMD),
          _Podium(entries: podium),
        ],
        if (rankedList.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.stackMD),
          _RankedList(entries: rankedList),
        ],
      ],
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
            'نواة',
            style: AppTypography.headlineLG.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.push('/notifications'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: AppColors.onSurface),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'لوحة الصدارة',
          style: AppTypography.headlineXL,
        ),
      ],
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  const _PeriodSelector({required this.selectedPeriod, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final periods = <String, String>{
      'weekly': 'أسبوعي',
      'monthly': 'شهري',
      'all_time': 'الكل',
    };
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.full),
          color: AppColors.surfaceContainerHigh.withAlpha(153),
          border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: periods.entries.map((e) {
            final isSelected = e.key == selectedPeriod;
            return GestureDetector(
              onTap: isSelected ? null : () => onChanged(e.key),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: isSelected ? AppColors.primaryContainer : Colors.transparent,
                ),
                child: Text(
                  e.value,
                  style: AppTypography.labelMD.copyWith(
                    color: isSelected ? AppColors.background : AppColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  final List<LeaderboardModel> entries;

  const _Podium({required this.entries});

  /// Returns widgets in order: 2nd place, 1st place, 3rd place
  List<Widget> _buildPodiumCards(BuildContext context) {
    final items = <Widget>[];

    // 2nd place (left visually)
    if (entries.length >= 2) {
      items.add(_PodiumCard(entry: entries[1], isFirst: false));
    } else {
      items.add(const SizedBox(width: 100));
    }

    items.add(const SizedBox(width: AppSpacing.gutter));

    // 1st place (center)
    if (entries.isNotEmpty) {
      items.add(_PodiumCard(entry: entries[0], isFirst: true));
    } else {
      items.add(const SizedBox(width: 120));
    }

    items.add(const SizedBox(width: AppSpacing.gutter));

    // 3rd place (right visually)
    if (entries.length >= 3) {
      items.add(_PodiumCard(entry: entries[2], isFirst: false));
    } else {
      items.add(const SizedBox(width: 100));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          ..._buildPodiumCards(context),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final LeaderboardModel entry;
  final bool isFirst;

  const _PodiumCard({required this.entry, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFirst ? 120 : 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (isFirst)
            const Icon(Icons.workspace_premium, color: AppColors.primary, size: 32),
          if (isFirst) const SizedBox(height: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: isFirst ? 80 : 64,
                height: isFirst ? 80 : 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFirst ? AppColors.primary : AppColors.surfaceVariant,
                    width: isFirst ? 4 : 2,
                  ),
                  boxShadow: isFirst
                      ? [BoxShadow(color: AppColors.primary.withAlpha(77), blurRadius: 20)]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: entry.avatarUrl != null
                      ? Image.network(entry.avatarUrl!, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.surfaceVariant,
                          alignment: Alignment.center,
                          child: Text(
                            entry.initials ?? entry.name.substring(0, 1),
                            style: AppTypography.headlineMD.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: -4,
                left: -4,
                child: Container(
                  width: isFirst ? 32 : 24,
                  height: isFirst ? 32 : 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFirst ? AppColors.primary : AppColors.surfaceVariant,
                    border: Border.all(color: AppColors.surfaceDim, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${entry.rank}',
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: isFirst ? 14 : 12,
                      fontWeight: FontWeight.bold,
                      color: isFirst ? AppColors.onPrimary : AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.name,
            style: AppTypography.bodyMD.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${entry.xp} XP',
            style: AppTypography.labelMD.copyWith(
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                color: isFirst
                    ? AppColors.primary.withAlpha(51)
                    : AppColors.surfaceVariant,
                gradient: isFirst
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withAlpha(77),
                          Colors.transparent,
                        ],
                      )
                    : null,
                border: isFirst
                    ? const Border(top: BorderSide(color: AppColors.primary, width: 1))
                    : null,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.emoji_events,
                size: isFirst ? 48 : 36,
                color: isFirst
                    ? AppColors.primary.withAlpha(204)
                    : AppColors.onSurfaceVariant.withAlpha(77),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankedList extends StatelessWidget {
  final List<LeaderboardModel> entries;

  const _RankedList({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          _RankCard(entry: entries[i]),
          if (i < entries.length - 1) const SizedBox(height: AppSpacing.stackSM),
        ],
      ],
    );
  }
}

class _RankCard extends StatelessWidget {
  final LeaderboardModel entry;

  const _RankCard({required this.entry});

  IconData _trendIcon(String? trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      case 'flat':
        return Icons.trending_flat;
      default:
        return Icons.remove;
    }
  }

  Color _trendColor(String? trend) {
    switch (trend) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = entry.isCurrentUser;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: isCurrentUser
            ? AppColors.primary.withAlpha(12)
            : AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primary.withAlpha(128)
              : AppColors.onSurfaceVariant.withAlpha(25),
        ),
        boxShadow: isCurrentUser
            ? [BoxShadow(color: AppColors.primaryContainer.withAlpha(38), blurRadius: 20)]
            : null,
      ),
      child: Row(
        children: [
          Text(
            '${entry.rank}',
            style: AppTypography.headlineMD.copyWith(
              color: isCurrentUser ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.stackMD),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentUser
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant.withAlpha(51),
                width: isCurrentUser ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: entry.avatarUrl != null
                  ? Image.network(entry.avatarUrl!, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.surfaceVariant,
                      alignment: Alignment.center,
                      child: Text(
                        entry.initials ?? entry.name.substring(0, 1),
                        style: AppTypography.labelMD.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.stackMD),
          Expanded(
            child: Text(
              entry.name,
              style: AppTypography.bodyLG.copyWith(
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            _trendIcon(entry.trend),
            size: 20,
            color: _trendColor(entry.trend),
          ),
          const SizedBox(width: 8),
          Text(
            '${entry.xp}',
            style: AppTypography.labelMD.copyWith(
              color: isCurrentUser ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'XP',
            style: AppTypography.codeSM.copyWith(
              color: isCurrentUser ? AppColors.primary : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
