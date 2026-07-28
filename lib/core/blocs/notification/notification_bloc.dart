import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/notification_model.dart';
import '../../repositories/notification_repository.dart';

// Events
sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class NotificationLoadRequested extends NotificationEvent {
  final String? status;
  const NotificationLoadRequested({this.status});
  @override
  List<Object?> get props => [status];
}

class NotificationLoadMore extends NotificationEvent {}

class NotificationMarkAsRead extends NotificationEvent {
  final String id;
  const NotificationMarkAsRead(this.id);
  @override
  List<Object?> get props => [id];
}

class NotificationMarkAllAsRead extends NotificationEvent {}

// States
sealed class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool hasMore;
  final String? cursor;
  const NotificationLoaded({
    required this.notifications,
    this.unreadCount = 0,
    this.hasMore = false,
    this.cursor,
  });
  @override
  List<Object?> get props => [notifications, unreadCount, hasMore, cursor];
}
class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc(this._repository) : super(NotificationInitial()) {
    on<NotificationLoadRequested>(_onLoad);
    on<NotificationLoadMore>(_onLoadMore);
    on<NotificationMarkAsRead>(_onMarkAsRead);
    on<NotificationMarkAllAsRead>(_onMarkAllAsRead);
  }

  Future<void> _onLoad(NotificationLoadRequested event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final result = await _repository.getNotifications(status: event.status);
      final unreadCount = await _repository.getUnreadCount();
      emit(NotificationLoaded(
        notifications: result.items,
        unreadCount: unreadCount,
        hasMore: result.pageInfo.hasNext,
        cursor: result.pageInfo.nextCursor,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onLoadMore(NotificationLoadMore event, Emitter<NotificationState> emit) async {
    final current = state;
    if (current is! NotificationLoaded || !current.hasMore) return;
    try {
      final result = await _repository.getNotifications(cursor: current.cursor);
      emit(NotificationLoaded(
        notifications: [...current.notifications, ...result.items],
        unreadCount: current.unreadCount,
        hasMore: result.pageInfo.hasNext,
        cursor: result.pageInfo.nextCursor,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(NotificationMarkAsRead event, Emitter<NotificationState> emit) async {
    try {
      await _repository.markAsRead(event.id);
      add(NotificationLoadRequested());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkAllAsRead(NotificationMarkAllAsRead event, Emitter<NotificationState> emit) async {
    try {
      await _repository.markAllAsRead();
      add(NotificationLoadRequested());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
