import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

// CORE
import 'core/theme.dart';
import 'firebase_options.dart';

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
import 'presentation/blocs/dashboard_bloc/dashboard_bloc.dart';

// PAGES
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX 1: Add firestore parameter
    final authSource = FirebaseAuthSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
      firestore: FirebaseFirestore.instance, // ✅ REQUIRED
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
            )..add(AuthCheckStatusEvent()),
          ),
          BlocProvider(
            create: (context) => AppointmentBloc(
              appointmentRepository: context.read<AppointmentRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => DashboardBloc(
              context.read<AppointmentRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ubuzima Connect',

          // ✅ FIX 2: theme is fine
          theme: AppTheme.lightTheme,

          // ❌ FIX 2: REMOVE this (you don’t have darkTheme)
          // darkTheme: AppTheme.darkTheme,

          themeMode: ThemeMode.system,

          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is AuthAuthenticatedState) {
                return const DashboardPage();
              }
              if (state is AuthUnauthenticatedState) {
                return const LoginPage();
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
