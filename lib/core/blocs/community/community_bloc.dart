import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';
import '../../repositories/community_repository.dart';
import '../../network/api_exceptions.dart';

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

class CommunityLoadMyPosts extends CommunityEvent {}

class CommunityMyPostsToggleLike extends CommunityEvent {
  final String postId;
  final bool isLiked;
  const CommunityMyPostsToggleLike({
    required this.postId,
    required this.isLiked,
  });
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

class CommunityMyPostsLoading extends CommunityState {}

class CommunityMyPostsLoaded extends CommunityState {
  final List<PostModel> posts;
  const CommunityMyPostsLoaded({required this.posts});
  @override
  List<Object?> get props => [posts];
}

class CommunityMyPostsError extends CommunityState {
  final String message;
  const CommunityMyPostsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityRepository _repository;
  final Set<String> _pendingLikes = {};
  final Set<String> _pendingMyLikes = {};

  CommunityBloc(this._repository) : super(CommunityInitial()) {
    on<CommunityLoadPosts>(_onLoadPosts);
    on<CommunityLoadMore>(_onLoadMore);
    on<CommunityLoadTrending>(_onLoadTrending);
    on<CommunityCreatePost>(_onCreatePost);
    on<CommunityToggleLike>(_onToggleLike);
    on<CommunityLoadMyPosts>(_onLoadMyPosts);
    on<CommunityMyPostsToggleLike>(_onMyPostsToggleLike);
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
      String message;
      if (e is ApiException) {
        message = e.toUserMessage();
      } else {
        message = 'حدث خطأ غير متوقع';
      }
      emit(CommunityError(message));
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
    } catch (_) {
      emit(current);
    }
  }

  Future<void> _onLoadTrending(CommunityLoadTrending event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());
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
    } catch (e) {
      String message;
      if (e is ApiException) {
        message = e.toUserMessage();
      } else {
        message = 'حدث خطأ غير متوقع';
      }
      emit(CommunityError(message));
    }
  }

  Future<void> _onCreatePost(CommunityCreatePost event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());
    try {
      await _repository.createPost(
        type: event.type,
        title: event.title,
        body: event.body,
      );
      add(CommunityLoadPosts());
    } catch (e) {
      String message;
      if (e is ApiException) {
        message = e.toUserMessage();
      } else {
        message = 'حدث خطأ غير متوقع';
      }
      emit(CommunityError(message));
    }
  }

  Future<void> _onToggleLike(CommunityToggleLike event, Emitter<CommunityState> emit) async {
    final current = state;
    if (current is! CommunityLoaded) return;
    if (!_pendingLikes.add(event.postId)) return;

    final previousPosts = current.posts;
    final optimisticPosts = current.posts
        .map((p) => p.id == event.postId
            ? p.copyWithLike(
                liked: !event.isLiked,
                likesCount: p.likesCount + (event.isLiked ? -1 : 1),
              )
            : p)
        .toList();
    emit(CommunityLoaded(
      posts: optimisticPosts,
      trending: current.trending,
      hasMore: current.hasMore,
      cursor: current.cursor,
    ));

    try {
      final result = event.isLiked
          ? await _repository.removeLike(event.postId)
          : await _repository.toggleLike(event.postId);
      final live = state;
      if (live is CommunityLoaded) {
        final synced = live.posts
            .map((p) => p.id == event.postId
                ? p.copyWithLike(
                    liked: result['liked'] as bool? ?? !event.isLiked,
                    likesCount:
                        result['likesCount'] as int? ?? p.likesCount,
                  )
                : p)
            .toList();
        emit(CommunityLoaded(
          posts: synced,
          trending: live.trending,
          hasMore: live.hasMore,
          cursor: live.cursor,
        ));
      }
    } catch (_) {
      final live = state;
      if (live is CommunityLoaded) {
        emit(CommunityLoaded(
          posts: previousPosts,
          trending: live.trending,
          hasMore: live.hasMore,
          cursor: live.cursor,
        ));
      }
    } finally {
      _pendingLikes.remove(event.postId);
    }
  }

  Future<void> _onLoadMyPosts(
    CommunityLoadMyPosts event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityMyPostsLoading());
    try {
      final posts = await _repository.getPosts(author: 'me');
      emit(CommunityMyPostsLoaded(posts: posts.items));
    } catch (e) {
      String message;
      if (e is ApiException) {
        message = e.toUserMessage();
      } else {
        message = 'حدث خطأ غير متوقع';
      }
      emit(CommunityMyPostsError(message));
    }
  }

  Future<void> _onMyPostsToggleLike(
    CommunityMyPostsToggleLike event,
    Emitter<CommunityState> emit,
  ) async {
    final current = state;
    if (current is! CommunityMyPostsLoaded) return;
    if (!_pendingMyLikes.add(event.postId)) return;

    final previousPosts = current.posts;
    final optimisticPosts = current.posts
        .map((p) => p.id == event.postId
            ? p.copyWithLike(
                liked: !event.isLiked,
                likesCount: p.likesCount + (event.isLiked ? -1 : 1),
              )
            : p)
        .toList();
    emit(CommunityMyPostsLoaded(posts: optimisticPosts));

    try {
      final result = event.isLiked
          ? await _repository.removeLike(event.postId)
          : await _repository.toggleLike(event.postId);
      final live = state;
      if (live is CommunityMyPostsLoaded) {
        emit(CommunityMyPostsLoaded(
          posts: live.posts
              .map((p) => p.id == event.postId
                  ? p.copyWithLike(
                      liked: result['liked'] as bool? ?? !event.isLiked,
                      likesCount:
                          result['likesCount'] as int? ?? p.likesCount,
                    )
                  : p)
              .toList(),
        ));
      }
    } catch (_) {
      final live = state;
      if (live is CommunityMyPostsLoaded) {
        emit(CommunityMyPostsLoaded(posts: previousPosts));
      }
    } finally {
      _pendingMyLikes.remove(event.postId);
    }
  }
}
