import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/path_model.dart';
import '../repositories/path_repository.dart';

// Events
sealed class PathEvent extends Equatable {
  const PathEvent();
  @override
  List<Object?> get props => [];
}

class PathListLoadRequested extends PathEvent {
  final String? query;
  final String? tag;
  final String? level;
  final String? filter;
  const PathListLoadRequested({this.query, this.tag, this.level, this.filter});
  @override
  List<Object?> get props => [query, tag, level, filter];
}

class PathDetailLoadRequested extends PathEvent {
  final String slug;
  const PathDetailLoadRequested(this.slug);
  @override
  List<Object?> get props => [slug];
}

class PathEnrollRequested extends PathEvent {
  final String slug;
  const PathEnrollRequested(this.slug);
  @override
  List<Object?> get props => [slug];
}

// States
sealed class PathState extends Equatable {
  const PathState();
  @override
  List<Object?> get props => [];
}

class PathInitial extends PathState {}
class PathLoading extends PathState {}
class PathListLoaded extends PathState {
  final List<PathCardModel> paths;
  const PathListLoaded(this.paths);
  @override
  List<Object?> get props => [paths];
}
class PathDetailLoaded extends PathState {
  final PathDetailModel path;
  const PathDetailLoaded(this.path);
  @override
  List<Object?> get props => [path];
}
class PathEnrolled extends PathState {
  final PathDetailModel path;
  const PathEnrolled(this.path);
  @override
  List<Object?> get props => [path];
}
class PathError extends PathState {
  final String message;
  const PathError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class PathBloc extends Bloc<PathEvent, PathState> {
  final PathRepository _repository;

  PathBloc(this._repository) : super(PathInitial()) {
    on<PathListLoadRequested>(_onLoadList);
    on<PathDetailLoadRequested>(_onLoadDetail);
    on<PathEnrollRequested>(_onEnroll);
  }

  Future<void> _onLoadList(PathListLoadRequested event, Emitter<PathState> emit) async {
    emit(PathLoading());
    try {
      final paths = await _repository.getPaths(
        query: event.query,
        tag: event.tag,
        level: event.level,
        filter: event.filter,
      );
      emit(PathListLoaded(paths));
    } catch (e) {
      emit(PathError(e.toString()));
    }
  }

  Future<void> _onLoadDetail(PathDetailLoadRequested event, Emitter<PathState> emit) async {
    emit(PathLoading());
    try {
      final path = await _repository.getPathDetail(event.slug);
      emit(PathDetailLoaded(path));
    } catch (e) {
      emit(PathError(e.toString()));
    }
  }

  Future<void> _onEnroll(PathEnrollRequested event, Emitter<PathState> emit) async {
    try {
      await _repository.enrollPath(event.slug);
      final path = await _repository.getPathDetail(event.slug);
      emit(PathEnrolled(path));
    } catch (e) {
      emit(PathError(e.toString()));
    }
  }
}
