import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/domain/repositories/appointment_repository.dart';
import 'package:ubuzima_connect/presentation/blocs/dashboard_bloc/dashboard_event.dart';
import 'package:ubuzima_connect/presentation/blocs/dashboard_bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AppointmentRepository repository;

  DashboardBloc(this.repository) : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    try {
      final appointments = await repository.getUpcomingAppointments(
        event.userId,
      );
      emit(DashboardLoaded(appointments));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    // Don't emit Loading on refresh so the list doesn't flash —
    // the RefreshIndicator spinner handles the visual feedback.
    try {
      final appointments = await repository.getUpcomingAppointments(
        event.userId,
      );
      emit(DashboardLoaded(appointments));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
