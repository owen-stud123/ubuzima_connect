import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_event.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_state.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:ubuzima_connect/presentation/pages/add_appointment_page.dart'; // ✅ make sure this path is correct

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
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticatedState) {
      context
          .read<AppointmentBloc>()
          .add(GetAppointmentsEvent(userId: authState.user.id));
    }
  }

  Widget _buildGreeting() {
    final authState = context.read<AuthBloc>().state;
    String name = '';
    if (authState is AuthAuthenticatedState) {
      name = authState.user.name ?? '';
    }
    return Text(
      'Hello, $name 👋',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAppointmentsList(List<AppointmentEntity> appointments) {
    if (appointments.isEmpty) {
      return const Center(child: Text('No appointments yet.'));
    }

    return ListView.separated(
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final app = appointments[index];
        return ListTile(
          title: Text(app.title),
          subtitle: Text(
              '${app.dateTime.day}/${app.dateTime.month}/${app.dateTime.year} '
              '${app.dateTime.hour.toString().padLeft(2, '0')}:${app.dateTime.minute.toString().padLeft(2, '0')}'),
          trailing: Text(app.status),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildGreeting(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, state) {
                  if (state is AppointmentLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AppointmentsLoadedState) {
                    return _buildAppointmentsList(state.appointments);
                  } else if (state is AppointmentErrorState) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddAppointmentPage WITHOUT const
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddAppointmentPage(),
            ),
          );
          if (result == true) _loadAppointments();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
