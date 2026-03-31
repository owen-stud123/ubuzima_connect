import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/core/theme.dart';
import 'package:ubuzima_connect/core/language_service.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_state.dart';

class MyVisitsPage extends StatelessWidget {
  const MyVisitsPage({super.key});

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return AppTheme.primaryGreen;
      case 'completed':
        return AppTheme.primaryBlue;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return AppTheme.lightGreen;
      case 'completed':
        return AppTheme.lightBlue;
      case 'cancelled':
        return AppTheme.errorColor.withValues(alpha: 0.1);
      default:
        return AppTheme.dividerColor;
    }
  }

  Widget _buildAppointmentCard(AppointmentEntity appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appointment.dateTime.day.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                Text(
                  _getMonthName(appointment.dateTime.month),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment.professionalName ?? 'Doctor'} • ${appointment.location ?? 'Clinic'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment.dateTime.hour.toString().padLeft(2, '0')}:${appointment.dateTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusBgColor(appointment.status),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              appointment.status.replaceFirst(
                appointment.status[0],
                appointment.status[0].toUpperCase(),
              ),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(appointment.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.currentLanguage,
      builder: (context, language, _) => Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(
            language == AppLanguage.kinyarwanda ? 'Isura Ryanje' : 'My Visits',
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            if (state is AppointmentLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AppointmentsLoadedState) {
              if (state.appointments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 64,
                          color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      Text(
                        language == AppLanguage.kinyarwanda
                            ? 'Nta gahunda ifite'
                            : 'No appointments yet',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.appointments.length,
                itemBuilder: (context, index) =>
                    _buildAppointmentCard(state.appointments[index]),
              );
            }
            if (state is AppointmentErrorState) {
              return Center(
                child: Text(
                  language == AppLanguage.kinyarwanda
                      ? 'Habaye ikosa. Gerageza nanone.'
                      : 'Something went wrong. Please try again.',
                  style: const TextStyle(color: AppTheme.errorColor),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
