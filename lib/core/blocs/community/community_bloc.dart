import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/post_model.dart';
import '../network/api_response.dart';
import '../repositories/community_repository.dart';

// Events
sealed class CommunityEvent extends Equatable {
  const CommunityEvent();
  @override
  List<Object?> get props => [];
}

class CommunityLoadPosts extends CommunityEvent {
  final String? type;
  final String? sort;
  const CommunityLoadPosts({this.type, this.sort});
  @override
  List<Object?> get props => [type, sort];
}

class CommunityLoadMore extends CommunityEvent {
  final String? type;
  final String? sort;
  const CommunityLoadMore({this.type, this.sort});
  @override
  List<Object?> get props => [type, sort];
}

class CommunityLoadTrending extends CommunityEvent {}

class CommunityCreatePost extends CommunityEvent {
  final String type;
  final String title;
  final String body;
  const CommunityCreatePost({
    required this.type,
    required this.title,
    required this.body,
  });
  @override
  List<Object?> get props => [type, title, body];
}

class CommunityToggleLike extends CommunityEvent {
  final String postId;
  final bool isLiked;
  const CommunityToggleLike({required this.postId, required this.isLiked});
  @override
  List<Object?> get props => [postId, isLiked];
}

// States
sealed class CommunityState extends Equatable {
  const CommunityState();
  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {}
class CommunityLoading extends CommunityState {}
class CommunityLoaded extends CommunityState {
  final List<PostModel> posts;
  final List<TrendingTopicModel> trending;
  final bool hasMore;
  final String? cursor;
  const CommunityLoaded({
    required this.posts,
    this.trending = const [],
    this.hasMore = false,
    this.cursor,
  });
  @override
  List<Object?> get props => [posts, trending, hasMore, cursor];
}
class CommunityError extends CommunityState {
  final String message;
  const CommunityError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityRepository _repository;

  CommunityBloc(this._repository) : super(CommunityInitial()) {
    on<CommunityLoadPosts>(_onLoadPosts);
    on<CommunityLoadMore>(_onLoadMore);
    on<CommunityLoadTrending>(_onLoadTrending);
    on<CommunityCreatePost>(_onCreatePost);
    on<CommunityToggleLike>(_onToggleLike);
  }

  Future<void> _onLoadPosts(CommunityLoadPosts event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());
    try {
      final posts = await _repository.getPosts(type: event.type, sort: event.sort);
      final trending = await _repository.getTrendingTopics();
      emit(CommunityLoaded(
        posts: posts.items,
        trending: trending,
        hasMore: posts.pageInfo.hasNext,
        cursor: posts.pageInfo.nextCursor,
      ));
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> _onLoadMore(CommunityLoadMore event, Emitter<CommunityState> emit) async {
    final current = state;
    if (current is! CommunityLoaded || !current.hasMore) return;
    try {
      final posts = await _repository.getPosts(
        type: event.type,
        sort: event.sort,
        cursor: current.cursor,
      );
      emit(CommunityLoaded(
        posts: [...current.posts, ...posts.items],
        trending: current.trending,
        hasMore: posts.pageInfo.hasNext,
        cursor: posts.pageInfo.nextCursor,
      ));
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> _onLoadTrending(CommunityLoadTrending event, Emitter<CommunityState> emit) async {
    try {
      final trending = await _repository.getTrendingTopics();
      final current = state;
      if (current is CommunityLoaded) {
        emit(CommunityLoaded(
          posts: current.posts,
          trending: trending,
          hasMore: current.hasMore,
          cursor: current.cursor,
        ));
      }
    } catch (_) {}
  }

  Future<void> _onCreatePost(CommunityCreatePost event, Emitter<CommunityState> emit) async {
    try {
      await _repository.createPost(
        type: event.type,
        title: event.title,
        body: event.body,
      );
      add(CommunityLoadPosts());
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> _onToggleLike(CommunityToggleLike event, Emitter<CommunityState> emit) async {
    try {
      if (event.isLiked) {
        await _repository.removeLike(event.postId);
      } else {
        await _repository.toggleLike(event.postId);
      }
      add(CommunityLoadPosts());
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }
}
