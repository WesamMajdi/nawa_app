import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/plan_model.dart';
import '../../repositories/certificate_repository.dart';

// Events
sealed class CertificateEvent extends Equatable {
  const CertificateEvent();
  @override
  List<Object?> get props => [];
}

class CertificateLoadRequested extends CertificateEvent {}
class CertificateLoadPlans extends CertificateEvent {}
class CertificateSubscribeRequested extends CertificateEvent {
  final String planCode;
  final String billingCycle;
  const CertificateSubscribeRequested({
    required this.planCode,
    required this.billingCycle,
  });
  @override
  List<Object?> get props => [planCode, billingCycle];
}

// States
sealed class CertificateState extends Equatable {
  const CertificateState();
  @override
  List<Object?> get props => [];
}

class CertificateInitial extends CertificateState {}
class CertificateLoading extends CertificateState {}
class CertificateLoaded extends CertificateState {
  final List<CertificateModel> certificates;
  final List<PlanModel> plans;
  const CertificateLoaded({required this.certificates, required this.plans});
  @override
  List<Object?> get props => [certificates, plans];
}
class CertificateError extends CertificateState {
  final String message;
  const CertificateError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
  final CertificateRepository _repository;

  CertificateBloc(this._repository) : super(CertificateInitial()) {
    on<CertificateLoadRequested>(_onLoad);
    on<CertificateLoadPlans>(_onLoadPlans);
    on<CertificateSubscribeRequested>(_onSubscribe);
  }

  Future<void> _onLoad(CertificateLoadRequested event, Emitter<CertificateState> emit) async {
    emit(CertificateLoading());
    try {
      final certificates = await _repository.getCertificates();
      final plans = await _repository.getPlans();
      emit(CertificateLoaded(certificates: certificates, plans: plans));
    } catch (e) {
      emit(CertificateError(e.toString()));
    }
  }

  Future<void> _onLoadPlans(CertificateLoadPlans event, Emitter<CertificateState> emit) async {
    try {
      final plans = await _repository.getPlans();
      final current = state;
      if (current is CertificateLoaded) {
        emit(CertificateLoaded(certificates: current.certificates, plans: plans));
      }
    } catch (e) {
      emit(CertificateError(e.toString()));
    }
  }

  Future<void> _onSubscribe(CertificateSubscribeRequested event, Emitter<CertificateState> emit) async {
    try {
      await _repository.subscribe(
        planCode: event.planCode,
        billingCycle: event.billingCycle,
      );
    } catch (e) {
      emit(CertificateError(e.toString()));
    }
  }
}
