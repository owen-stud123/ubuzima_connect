import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentEntity>> getAppointments(String userId);
  Future<AppointmentEntity> getAppointmentById(String appointmentId);
  Future<void> createAppointment(AppointmentEntity appointment);
  Future<void> updateAppointment(AppointmentEntity appointment);
  Future<void> deleteAppointment(String appointmentId);
  Future<List<AppointmentEntity>> getUpcomingAppointments(String userId);
}
