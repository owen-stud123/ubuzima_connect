import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';
import 'package:ubuzima_connect/domain/repositories/appointment_repository.dart';
import 'appointment_state.dart';

/// AppointmentCubit manages the state of appointments for the presentation layer.
///
/// This cubit handles:
/// - Fetching appointments from the repository
/// - Creating new appointments
/// - Updating existing appointments
/// - Deleting appointments
/// - Emitting appropriate states for UI updates
class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository _appointmentRepository;

  AppointmentCubit({required AppointmentRepository appointmentRepository})
      : _appointmentRepository = appointmentRepository,
        super(const AppointmentInitial());

  /// Fetches all appointments for a specific user.
  ///
  /// Emits [AppointmentLoading] while fetching, then [AppointmentLoaded]
  /// on success, or [AppointmentError] if an error occurs.
  Future<void> getAppointments(String userId) async {
    try {
      emit(const AppointmentLoading());
      final appointments = await _appointmentRepository.getAppointments(userId);
      // Sort appointments by dateTime in ascending order
      appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      emit(AppointmentLoaded(appointments: appointments));
    } catch (e) {
      emit(AppointmentError(message: e.toString()));
    }
  }

  /// Fetches upcoming appointments for a specific user (from current date onwards).
  ///
  /// Emits [AppointmentLoading] while fetching, then [AppointmentLoaded]
  /// on success, or [AppointmentError] if an error occurs.
  Future<void> getUpcomingAppointments(String userId) async {
    try {
      emit(const AppointmentLoading());
      final appointments =
          await _appointmentRepository.getUpcomingAppointments(userId);
      emit(AppointmentLoaded(appointments: appointments));
    } catch (e) {
      emit(AppointmentError(message: e.toString()));
    }
  }

  /// Fetches a single appointment by its ID.
  ///
  /// Emits [AppointmentLoading] while fetching, then [AppointmentLoaded]
  /// on success, or [AppointmentError] if an error occurs.
  Future<void> getAppointmentById(String appointmentId) async {
    try {
      emit(const AppointmentLoading());
      final appointment =
          await _appointmentRepository.getAppointmentById(appointmentId);
      emit(AppointmentLoaded(appointments: [appointment]));
    } catch (e) {
      emit(AppointmentError(message: e.toString()));
    }
  }

  /// Creates a new appointment.
  ///
  /// Takes an [AppointmentEntity] and saves it to Firestore.
  /// Emits [AppointmentCreating] while saving, then [AppointmentCreated]
  /// on success, or [AppointmentError] if an error occurs.
  ///
  /// Parameters:
  /// - [appointment]: The appointment entity to create
  Future<void> addAppointment(AppointmentEntity appointment) async {
    try {
      emit(const AppointmentCreating());
      await _appointmentRepository.createAppointment(appointment);

      // Refresh the appointments list after creation
      if (state is AppointmentLoaded) {
        final currentAppointments =
            (state as AppointmentLoaded).appointments.toList();
        currentAppointments.add(appointment);
        currentAppointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        emit(AppointmentCreated(appointments: currentAppointments));
      } else {
        emit(AppointmentCreated(appointments: [appointment]));
      }
    } catch (e) {
      emit(AppointmentError(message: 'Failed to create appointment: $e'));
    }
  }

  /// Updates an existing appointment.
  ///
  /// Takes an [AppointmentEntity] with updated values and saves changes to Firestore.
  /// Emits [AppointmentUpdating] while saving, then [AppointmentUpdated]
  /// on success, or [AppointmentError] if an error occurs.
  ///
  /// Parameters:
  /// - [appointment]: The appointment entity with updated values
  Future<void> updateAppointment(AppointmentEntity appointment) async {
    try {
      emit(const AppointmentUpdating());
      await _appointmentRepository.updateAppointment(appointment);

      // Update the appointments list after successful update
      if (state is AppointmentLoaded) {
        final currentAppointments =
            (state as AppointmentLoaded).appointments.toList();
        final index =
            currentAppointments.indexWhere((a) => a.id == appointment.id);
        if (index != -1) {
          currentAppointments[index] = appointment;
          currentAppointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          emit(AppointmentUpdated(appointments: currentAppointments));
        } else {
          emit(AppointmentUpdated(appointments: currentAppointments));
        }
      } else {
        emit(AppointmentUpdated(appointments: [appointment]));
      }
    } catch (e) {
      emit(AppointmentError(message: 'Failed to update appointment: $e'));
    }
  }

  /// Deletes an appointment by its ID.
  ///
  /// Takes an appointment ID and removes it from Firestore.
  /// Emits [AppointmentDeleting] while deleting, then [AppointmentDeleted]
  /// on success, or [AppointmentError] if an error occurs.
  ///
  /// Parameters:
  /// - [appointmentId]: The ID of the appointment to delete
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      emit(const AppointmentDeleting());
      await _appointmentRepository.deleteAppointment(appointmentId);

      // Remove the appointment from the list after successful deletion
      if (state is AppointmentLoaded) {
        final currentAppointments =
            (state as AppointmentLoaded).appointments.toList();
        currentAppointments.removeWhere((a) => a.id == appointmentId);
        emit(AppointmentDeleted(appointments: currentAppointments));
      } else {
        emit(const AppointmentDeleted(appointments: []));
      }
    } catch (e) {
      emit(AppointmentError(message: 'Failed to delete appointment: $e'));
    }
  }

  /// Resets the cubit state to initial.
  ///
  /// Useful when navigating away from the appointments screen or logging out.
  void reset() {
    emit(const AppointmentInitial());
  }
}
