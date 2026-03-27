import 'package:equatable/equatable.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

/// Initial state - empty list of appointments
class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

/// Loading state - appointments are being fetched
class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

/// Success state - appointments loaded successfully
class AppointmentLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;

  const AppointmentLoaded({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

/// Error state - error occurred while fetching appointments
class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError({required this.message});

  @override
  List<Object> get props => [message];
}

/// State when creating an appointment
class AppointmentCreating extends AppointmentState {
  const AppointmentCreating();
}

/// State when appointment was created successfully
class AppointmentCreated extends AppointmentState {
  final List<AppointmentEntity> appointments;

  const AppointmentCreated({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

/// State when updating an appointment
class AppointmentUpdating extends AppointmentState {
  const AppointmentUpdating();
}

/// State when appointment was updated successfully
class AppointmentUpdated extends AppointmentState {
  final List<AppointmentEntity> appointments;

  const AppointmentUpdated({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

/// State when deleting an appointment
class AppointmentDeleting extends AppointmentState {
  const AppointmentDeleting();
}

/// State when appointment was deleted successfully
class AppointmentDeleted extends AppointmentState {
  final List<AppointmentEntity> appointments;

  const AppointmentDeleted({required this.appointments});

  @override
  List<Object> get props => [appointments];
}
