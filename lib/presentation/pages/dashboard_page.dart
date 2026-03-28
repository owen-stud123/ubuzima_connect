import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/core/theme.dart';
import 'package:ubuzima_connect/core/language_service.dart';
import 'package:ubuzima_connect/domain/entities/appointment_entity.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_event.dart';
import 'package:ubuzima_connect/presentation/blocs/appointment_bloc/appointment_state.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:ubuzima_connect/presentation/pages/add_appointment_page.dart';
import 'package:ubuzima_connect/presentation/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointments();
    });
  }

  void _loadAppointments() {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticatedState) {
        context
            .read<AppointmentBloc>()
            .add(GetAppointmentsEvent(userId: authState.user.id));
      }
    } catch (e) {
      print('❌ Error loading appointments: $e');
    }
  }

  String _getGreeting(AppLanguage language) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting =
          language == AppLanguage.kinyarwanda ? 'Mugitondo' : 'Good morning';
    } else if (hour < 18) {
      greeting =
          language == AppLanguage.kinyarwanda ? 'Mwankunde' : 'Good afternoon';
    } else {
      greeting =
          language == AppLanguage.kinyarwanda ? 'Mwamasera' : 'Good evening';
    }
    return greeting;
  }

  Widget _buildGreetingSection(AppLanguage language) {
    final authState = context.read<AuthBloc>().state;
    String name = '';
    String photoUrl = '';
    if (authState is AuthAuthenticatedState) {
      name = authState.user.name ?? 'User';
      photoUrl = authState.user.photoUrl ?? '';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(language),
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              language == AppLanguage.kinyarwanda
                  ? 'Muraho, $name 👋'
                  : 'Hello, $name 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        // User avatar
        CircleAvatar(
          radius: 28,
          backgroundColor: AppTheme.lightBlue,
          backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
          child: photoUrl.isEmpty
              ? const Icon(Icons.person, color: AppTheme.primaryBlue)
              : null,
        ),
      ],
    );
  }

  Widget _buildNextAppointmentCard(
      AppointmentEntity appointment, AppLanguage language) {
    return Container(
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language == AppLanguage.kinyarwanda
                ? 'GAHUNDA ZIKURIKIRA'
                : 'NEXT APPOINTMENT',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appointment.dateTime.day} ${_getMonthName(appointment.dateTime.month, language)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.dateTime.year.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointment.status.replaceFirst(
                    appointment.status[0],
                    appointment.status[0].toUpperCase(),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language == AppLanguage.kinyarwanda
                          ? 'N\'imbere ya:'
                          : 'With:',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '${appointment.professionalName ?? 'Doctor'} (${appointment.location ?? 'Clinic'})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month, AppLanguage language) {
    if (language == AppLanguage.kinyarwanda) {
      const monthsRw = [
        'Mut',
        'Gim',
        'Kak',
        'Kne',
        'Gic',
        'Kar',
        'Kiy',
        'Agu',
        'Sek',
        'Elt',
        'Ugh',
        'Kam'
      ];
      return monthsRw[month - 1];
    }
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

  Widget _buildDashboardGridItem({
    required IconData icon,
    required String label,
    required String labelRw,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryBlue,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<AppLanguage>(
              valueListenable: LanguageService.currentLanguage,
              builder: (context, language, _) => Text(
                language == AppLanguage.kinyarwanda ? labelRw : label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
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
          title: Text(language == AppLanguage.kinyarwanda
              ? 'Imbonerahamwe'
              : 'Dashboard'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting section
                    _buildGreetingSection(language),
                    const SizedBox(height: 28),

                    // Next appointment card
                    if (state is AppointmentsLoadedState &&
                        state.appointments.isNotEmpty)
                      Column(
                        children: [
                          _buildNextAppointmentCard(
                              state.appointments.first, language),
                          const SizedBox(height: 28),
                        ],
                      )
                    else if (state is AppointmentLoadingState)
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      )
                    else if (state is AppointmentErrorState)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.errorColor.withValues(alpha: 0.3),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                language == AppLanguage.kinyarwanda
                                    ? 'Ntirokubuo gahunda'
                                    : 'Unable to load appointments',
                                style: const TextStyle(
                                  color: AppTheme.errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: _loadAppointments,
                                icon: const Icon(Icons.refresh),
                                label: Text(language == AppLanguage.kinyarwanda
                                    ? 'Subiramo'
                                    : 'Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Grid navigation items
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                      children: [
                        _buildDashboardGridItem(
                          icon: Icons.calendar_month_outlined,
                          label: 'My Visits',
                          labelRw: 'Isura Ryanje',
                          onTap: () {
                            print('My Visits tapped');
                            // TODO: Navigate to My Visits page
                          },
                        ),
                        _buildDashboardGridItem(
                          icon: Icons.chat_outlined,
                          label: 'Ask Doctor',
                          labelRw: 'Kubuza Muganga',
                          onTap: () {
                            print('Ask Doctor tapped');
                            // TODO: Navigate to Ask Doctor page
                          },
                        ),
                        _buildDashboardGridItem(
                          icon: Icons.lightbulb_outline,
                          label: 'Health Tips',
                          labelRw: 'Ubwenge Ku Nzira',
                          onTap: () {
                            print('Health Tips tapped');
                            // TODO: Navigate to Health Tips page
                          },
                        ),
                        _buildDashboardGridItem(
                          icon: Icons.settings_outlined,
                          label: 'Profile',
                          labelRw: 'Umwirondoro',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ProfileScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddAppointmentPage(),
              ),
            );
            if (result == true) _loadAppointments();
          },
          icon: const Icon(Icons.add),
          label: Text(language == AppLanguage.kinyarwanda
              ? 'Gahunda Nshya'
              : 'New Appointment'),
        ),
      ),
    );
  }
}
