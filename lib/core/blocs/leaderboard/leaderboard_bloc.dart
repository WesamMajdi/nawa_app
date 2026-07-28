import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/leaderboard_model.dart';
import '../../repositories/leaderboard_repository.dart';

// Events
sealed class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();
  @override
  List<Object?> get props => [];
}

class LeaderboardLoadRequested extends LeaderboardEvent {
  final String period;
  const LeaderboardLoadRequested({this.period = 'weekly'});
  @override
  List<Object?> get props => [period];
}

class LeaderboardPeriodChanged extends LeaderboardEvent {
  final String period;
  const LeaderboardPeriodChanged(this.period);
  @override
  List<Object?> get props => [period];
}

// States
sealed class LeaderboardState extends Equatable {
  const LeaderboardState();
  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}
class LeaderboardLoading extends LeaderboardState {}
class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardModel> entries;
  final String period;
  final bool hasMore;
  final String? cursor;
  const LeaderboardLoaded({
    required this.entries,
    required this.period,
    this.hasMore = false,
    this.cursor,
  });
  @override
  List<Object?> get props => [entries, period, hasMore, cursor];
}
class LeaderboardError extends LeaderboardState {
  final String message;
  const LeaderboardError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository _repository;

  LeaderboardBloc(this._repository) : super(LeaderboardInitial()) {
    on<LeaderboardLoadRequested>(_onLoad);
    on<LeaderboardPeriodChanged>(_onPeriodChanged);
  }

  Future<void> _onLoad(LeaderboardLoadRequested event, Emitter<LeaderboardState> emit) async {
    emit(LeaderboardLoading());
    try {
      final result = await _repository.getLeaderboard(
        period: event.period,
        aroundMe: true,
      );
      emit(LeaderboardLoaded(
        entries: result.items,
        period: event.period,
        hasMore: result.pageInfo.hasNext,
        cursor: result.pageInfo.nextCursor,
      ));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }

  Future<void> _onPeriodChanged(LeaderboardPeriodChanged event, Emitter<LeaderboardState> emit) async {
    add(LeaderboardLoadRequested(period: event.period));
  }
}
