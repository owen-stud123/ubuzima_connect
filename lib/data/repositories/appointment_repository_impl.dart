import 'package:ubuzima_connect/data/datasources/firestore_source.dart';
import 'package:ubuzima_connect/data/models/appointment_model.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';
import 'package:ubuzima_connect/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final FirestoreSource _firestoreSource;

  AppointmentRepositoryImpl({required FirestoreSource firestoreSource})
      : _firestoreSource = firestoreSource;

  @override
  Future<List<AppointmentEntity>> getAppointments(String userId) async {
    final models = await _firestoreSource.getAppointments(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AppointmentEntity> getAppointmentById(String appointmentId) async {
    final model = await _firestoreSource.getAppointmentById(appointmentId);
    return model.toEntity();
  }

  @override
  Future<void> createAppointment(AppointmentEntity appointment) async {
    final model = _entityToModel(appointment);
    await _firestoreSource.createAppointment(model);
  }

  @override
  Future<void> updateAppointment(AppointmentEntity appointment) async {
    final model = _entityToModel(appointment);
    await _firestoreSource.updateAppointment(model);
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await _firestoreSource.deleteAppointment(appointmentId);
  }

  @override
  Future<List<AppointmentEntity>> getUpcomingAppointments(String userId) async {
    final models = await _firestoreSource.getUpcomingAppointments(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  AppointmentModel _entityToModel(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      dateTime: entity.dateTime,
      status: entity.status,
      professionalName: entity.professionalName,
      location: entity.location,
    );
  }
}
