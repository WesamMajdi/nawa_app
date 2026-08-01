import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/challenge_model.dart';
import '../../repositories/challenge_repository.dart';
import '../../network/api_exceptions.dart';

// Events
sealed class ChallengeEvent extends Equatable {
  const ChallengeEvent();
  @override
  List<Object?> get props => [];
}

class ChallengeFeedLoadRequested extends ChallengeEvent {
  final String? category;
  const ChallengeFeedLoadRequested({this.category});
  @override
  List<Object?> get props => [category];
}

class ChallengeFeedLoadMore extends ChallengeEvent {
  final String? category;
  const ChallengeFeedLoadMore({this.category});
  @override
  List<Object?> get props => [category];
}

class ChallengeDetailLoadRequested extends ChallengeEvent {
  final String id;
  const ChallengeDetailLoadRequested(this.id);
  @override
  List<Object?> get props => [id];
}

class ChallengeSubmitRequested extends ChallengeEvent {
  final String id;
  final String sourceCode;
  final String languageCode;
  const ChallengeSubmitRequested({
    required this.id,
    required this.sourceCode,
    required this.languageCode,
  });
  @override
  List<Object?> get props => [id, sourceCode, languageCode];
}

// States
sealed class ChallengeState extends Equatable {
  const ChallengeState();
  @override
  List<Object?> get props => [];
}

class ChallengeInitial extends ChallengeState {}
class ChallengeLoading extends ChallengeState {}
class ChallengeFeedLoaded extends ChallengeState {
  final List<ChallengeModel> challenges;
  final bool hasMore;
  final String? cursor;
  const ChallengeFeedLoaded({
    required this.challenges,
    this.hasMore = false,
    this.cursor,
  });
  @override
  List<Object?> get props => [challenges, hasMore, cursor];
}
class ChallengeDetailLoaded extends ChallengeState {
  final ChallengeDetailModel challenge;
  const ChallengeDetailLoaded(this.challenge);
  @override
  List<Object?> get props => [challenge];
}
class ChallengeSubmitted extends ChallengeState {
  final SubmissionResult result;
  const ChallengeSubmitted(this.result);
  @override
  List<Object?> get props => [result];
}
class ChallengeError extends ChallengeState {
  final String message;
  const ChallengeError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository _repository;

  ChallengeBloc(this._repository) : super(ChallengeInitial()) {
    on<ChallengeFeedLoadRequested>(_onLoadFeed);
    on<ChallengeFeedLoadMore>(_onLoadMore);
    on<ChallengeDetailLoadRequested>(_onLoadDetail);
    on<ChallengeSubmitRequested>(_onSubmit);
  }

  Future<void> _onLoadFeed(ChallengeFeedLoadRequested event, Emitter<ChallengeState> emit) async {
    emit(ChallengeLoading());
    try {
      final result = await _repository.getFeed(category: event.category);
      emit(ChallengeFeedLoaded(
        challenges: result.items,
        hasMore: result.pageInfo.hasNext,
        cursor: result.pageInfo.nextCursor,
      ));
    } catch (e) {
      String message;
      if (e is ApiException) {
        message = e.toUserMessage();
      } else {
        message = 'حدث خطأ غير متوقع';
      }
      emit(ChallengeError(message));
    }
  }

  Future<void> _onLoadMore(ChallengeFeedLoadMore event, Emitter<ChallengeState> emit) async {
    final current = state;
    if (current is! ChallengeFeedLoaded || !current.hasMore) return;
    try {
      final result = await _repository.getFeed(
        category: event.category,
        cursor: current.cursor,
      );
      emit(ChallengeFeedLoaded(
        challenges: [...current.challenges, ...result.items],
        hasMore: result.pageInfo.hasNext,
        cursor: result.pageInfo.nextCursor,
      ));
    } catch (_) {
      emit(current);
    }
  }

  Future<void> _onLoadDetail(ChallengeDetailLoadRequested event, Emitter<ChallengeState> emit) async {
    emit(ChallengeLoading());
    try {
      final challenge = await _repository.getChallenge(event.id);
      emit(ChallengeDetailLoaded(challenge));
    } catch (e) {
      String message;
      if (e is ApiException) {
        message = e.toUserMessage();
      } else {
        message = 'حدث خطأ غير متوقع';
      }
      emit(ChallengeError(message));
    }
  }

  Future<void> _onSubmit(ChallengeSubmitRequested event, Emitter<ChallengeState> emit) async {
    emit(ChallengeLoading());
    try {
      final result = await _repository.submitChallenge(
        id: event.id,
        sourceCode: event.sourceCode,
        languageCode: event.languageCode,
      );
      emit(ChallengeSubmitted(result));
    } catch (e) {
      String message;
      if (e is ApiException) {
        message = e.toUserMessage();
      } else {
        message = 'حدث خطأ غير متوقع';
      }
      emit(ChallengeError(message));
    }
  }
}
