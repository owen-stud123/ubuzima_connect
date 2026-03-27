import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

// CORE
import 'core/theme.dart';

// DATA
import 'data/datasources/firebase_auth_source.dart';
import 'data/datasources/firestore_source.dart';
import 'data/repositories/appointment_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';

// DOMAIN
import 'domain/repositories/appointment_repository.dart';
import 'domain/repositories/auth_repository.dart';

// BLOCS
import 'presentation/blocs/auth_bloc/auth_bloc.dart';
import 'presentation/blocs/auth_bloc/auth_event.dart';
import 'presentation/blocs/auth_bloc/auth_state.dart';
import 'presentation/blocs/appointment_bloc/appointment_bloc.dart';

// PAGES
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/landing_page.dart';
import 'presentation/pages/otp_verification_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authSource = FirebaseAuthSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
      firestore: FirebaseFirestore.instance,
    );

    final firestoreSource = FirestoreSourceImpl(
      firebaseFirestore: FirebaseFirestore.instance,
    );

    final AuthRepository authRepository =
        AuthRepositoryImpl(authSource: authSource);

    final AppointmentRepository appointmentRepository =
        AppointmentRepositoryImpl(firestoreSource: firestoreSource);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => authRepository),
        RepositoryProvider(create: (_) => appointmentRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(const AuthCheckStatusEvent()),
          ),
          BlocProvider(
            create: (context) => AppointmentBloc(
              appointmentRepository: context.read<AppointmentRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UbuzimaConnect',
          theme: AppTheme.lightTheme,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoadingState || state is AuthInitialState) {
                return const _SplashScreen();
              }
              if (state is AuthAuthenticatedState) {
                return const DashboardPage();
              }
              if (state is AuthOtpSentState || state is AuthOtpResentState) {
                final email = state is AuthOtpSentState
                    ? state.email
                    : (state as AuthOtpResentState).email;
                final userId = state is AuthOtpSentState
                    ? state.userId
                    : (state as AuthOtpResentState).userId;
                return OtpVerificationPage(email: email, userId: userId);
              }
              // AuthUnauthenticatedState, AuthErrorState, AuthOtpErrorState
              return const LoginPage();
            },
          ),
        ),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.health_and_safety_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'UbuzimaConnect',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: AppTheme.primaryGreen,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
