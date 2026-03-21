import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../../domain/repositories/appointment_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AppointmentRepository repository;

  DashboardBloc(this.repository) : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      emit(DashboardLoading());
      try {
        final appointments = await repository.getUpcomingAppointments(
          event.userId,
        );

        emit(DashboardLoaded(appointments));
      } catch (e) {
        emit(DashboardError("Failed to load dashboard"));
      }
    });
  }
}
