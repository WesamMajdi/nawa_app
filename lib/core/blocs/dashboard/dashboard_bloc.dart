import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/dashboard_model.dart';
import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

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
      final meData = await _repository.getMe();
      final user = UserModel.fromJson(meData['user'] as Map<String, dynamic>);
      final dashboard = await _repository.getDashboard();
      emit(DashboardLoaded(user: user, dashboard: dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
