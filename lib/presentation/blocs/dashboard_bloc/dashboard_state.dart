import '../../../domain/entities/appointment_entity.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<AppointmentEntity> appointments;

  DashboardLoaded(this.appointments);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
