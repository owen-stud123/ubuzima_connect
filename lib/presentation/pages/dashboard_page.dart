import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_event.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_state.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:ubuzima_connect/presentation/widgets/status_badge.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    final userId = _getUserId();
    if (userId != null) {
      context.read<AppointmentBloc>().add(
        GetUpcomingAppointmentsEvent(userId: userId),
      );
    }
  }

  String? _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticatedState) {
      return authState.user.id;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppointmentsLoadedState) {
            if (state.appointments.isEmpty) {
              return const Center(child: Text('No appointments found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.appointments.length,
              itemBuilder: (context, index) {
                final appointment = state.appointments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(appointment.title),
                    subtitle: Text(appointment.description),
                    trailing: StatusBadge(status: appointment.status),
                  ),
                );
              },
            );
          }

          if (state is AppointmentErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('No data'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create appointment
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
