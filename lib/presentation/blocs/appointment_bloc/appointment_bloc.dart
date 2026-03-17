import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/domain/repositories/appointment_repository.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_event.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository _appointmentRepository;

  AppointmentBloc({required AppointmentRepository appointmentRepository})
    : _appointmentRepository = appointmentRepository,
      super(const AppointmentInitialState()) {
    on<GetAppointmentsEvent>(_onGetAppointments);
    on<GetUpcomingAppointmentsEvent>(_onGetUpcomingAppointments);
    on<CreateAppointmentEvent>(_onCreateAppointment);
    on<UpdateAppointmentEvent>(_onUpdateAppointment);
    on<DeleteAppointmentEvent>(_onDeleteAppointment);
  }

  Future<void> _onGetAppointments(
    GetAppointmentsEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointments = await _appointmentRepository.getAppointments(
        event.userId,
      );
      emit(AppointmentsLoadedState(appointments: appointments));
    } catch (e) {
      emit(AppointmentErrorState(message: e.toString()));
    }
  }

  Future<void> _onGetUpcomingAppointments(
    GetUpcomingAppointmentsEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointments = await _appointmentRepository.getUpcomingAppointments(
        event.userId,
      );
      emit(AppointmentsLoadedState(appointments: appointments));
    } catch (e) {
      emit(AppointmentErrorState(message: e.toString()));
    }
  }

  Future<void> _onCreateAppointment(
    CreateAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      await _appointmentRepository.createAppointment(event.appointment);
      emit(AppointmentCreatedState(appointment: event.appointment));
    } catch (e) {
      emit(AppointmentErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateAppointment(
    UpdateAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      await _appointmentRepository.updateAppointment(event.appointment);
      emit(AppointmentUpdatedState(appointment: event.appointment));
    } catch (e) {
      emit(AppointmentErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteAppointment(
    DeleteAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      await _appointmentRepository.deleteAppointment(event.appointmentId);
      emit(AppointmentDeletedState(appointmentId: event.appointmentId));
    } catch (e) {
      emit(AppointmentErrorState(message: e.toString()));
    }
  }
}
