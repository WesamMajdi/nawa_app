import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/dashboard_model.dart';
import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';
import '../../network/api_exceptions.dart';

// Events
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {}

// States
sealed class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final UserModel user;
  final DashboardModel dashboard;
  const DashboardLoaded({required this.user, required this.dashboard});
  @override
  List<Object?> get props => [user, dashboard];
}
class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(DashboardLoadRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final user = await _repository.getMe();
      final dashboard = await _repository.getDashboard();
      emit(DashboardLoaded(user: user, dashboard: dashboard));
    } catch (e) {
      String message;
      if (e is ApiException) {
        message = e.toUserMessage();
      } else {
        message = 'حدث خطأ غير متوقع';
      }
      emit(DashboardError(message));
    }
  }
}
