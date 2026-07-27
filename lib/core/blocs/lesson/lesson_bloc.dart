import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/lesson_model.dart';
import '../repositories/lesson_repository.dart';

// Events
sealed class LessonEvent extends Equatable {
  const LessonEvent();
  @override
  List<Object?> get props => [];
}

class LessonLoadRequested extends LessonEvent {
  final String id;
  const LessonLoadRequested(this.id);
  @override
  List<Object?> get props => [id];
}

class LessonCompleteRequested extends LessonEvent {
  final String id;
  const LessonCompleteRequested(this.id);
  @override
  List<Object?> get props => [id];
}

class LessonSubmitCodeRequested extends LessonEvent {
  final String id;
  final String sourceCode;
  final String languageCode;
  const LessonSubmitCodeRequested({
    required this.id,
    required this.sourceCode,
    required this.languageCode,
  });
  @override
  List<Object?> get props => [id, sourceCode, languageCode];
}

class LessonSubmitQuizRequested extends LessonEvent {
  final String id;
  final List<Map<String, dynamic>> answers;
  const LessonSubmitQuizRequested({required this.id, required this.answers});
  @override
  List<Object?> get props => [id, answers];
}

// States
sealed class LessonState extends Equatable {
  const LessonState();
  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonState {}
class LessonLoading extends LessonState {}
class LessonLoaded extends LessonState {
  final LessonDetailModel lesson;
  const LessonLoaded(this.lesson);
  @override
  List<Object?> get props => [lesson];
}
class LessonCompleted extends LessonState {
  final LessonCompletionResult result;
  const LessonCompleted(this.result);
  @override
  List<Object?> get props => [result];
}
class LessonError extends LessonState {
  final String message;
  const LessonError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonRepository _repository;

  LessonBloc(this._repository) : super(LessonInitial()) {
    on<LessonLoadRequested>(_onLoad);
    on<LessonCompleteRequested>(_onComplete);
    on<LessonSubmitCodeRequested>(_onSubmitCode);
    on<LessonSubmitQuizRequested>(_onSubmitQuiz);
  }

  Future<void> _onLoad(LessonLoadRequested event, Emitter<LessonState> emit) async {
    emit(LessonLoading());
    try {
      final lesson = await _repository.getLesson(event.id);
      emit(LessonLoaded(lesson));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }

  Future<void> _onComplete(LessonCompleteRequested event, Emitter<LessonState> emit) async {
    try {
      final result = await _repository.completeLesson(event.id);
      emit(LessonCompleted(result));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }

  Future<void> _onSubmitCode(LessonSubmitCodeRequested event, Emitter<LessonState> emit) async {
    try {
      final result = await _repository.submitCode(
        id: event.id,
        sourceCode: event.sourceCode,
        languageCode: event.languageCode,
      );
      emit(LessonCompleted(result));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }

  Future<void> _onSubmitQuiz(LessonSubmitQuizRequested event, Emitter<LessonState> emit) async {
    try {
      final result = await _repository.submitQuiz(
        id: event.id,
        answers: event.answers,
      );
      emit(LessonCompleted(result));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }
}
