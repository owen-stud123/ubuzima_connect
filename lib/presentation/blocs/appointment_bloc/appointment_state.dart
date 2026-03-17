import 'package:equatable/equatable.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitialState extends AppointmentState {
  const AppointmentInitialState();
}

class AppointmentLoadingState extends AppointmentState {
  const AppointmentLoadingState();
}

class AppointmentsLoadedState extends AppointmentState {
  final List<AppointmentEntity> appointments;

  const AppointmentsLoadedState({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class AppointmentCreatedState extends AppointmentState {
  final AppointmentEntity appointment;

  const AppointmentCreatedState({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class AppointmentUpdatedState extends AppointmentState {
  final AppointmentEntity appointment;

  const AppointmentUpdatedState({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class AppointmentDeletedState extends AppointmentState {
  final String appointmentId;

  const AppointmentDeletedState({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}

class AppointmentErrorState extends AppointmentState {
  final String message;

  const AppointmentErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
