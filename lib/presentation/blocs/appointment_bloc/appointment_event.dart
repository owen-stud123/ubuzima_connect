import 'package:equatable/equatable.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class GetAppointmentsEvent extends AppointmentEvent {
  final String userId;

  const GetAppointmentsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetUpcomingAppointmentsEvent extends AppointmentEvent {
  final String userId;

  const GetUpcomingAppointmentsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CreateAppointmentEvent extends AppointmentEvent {
  final AppointmentEntity appointment;

  const CreateAppointmentEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class UpdateAppointmentEvent extends AppointmentEvent {
  final AppointmentEntity appointment;

  const UpdateAppointmentEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class DeleteAppointmentEvent extends AppointmentEvent {
  final String appointmentId;

  const DeleteAppointmentEvent({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}
