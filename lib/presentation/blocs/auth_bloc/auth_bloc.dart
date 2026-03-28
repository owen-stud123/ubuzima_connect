import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/domain/repositories/auth_repository.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitialState()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInWithGoogleEvent>(_onSignInWithGoogle);
    on<AuthSendOtpEvent>(_onSendOtp);
    on<AuthVerifyOtpEvent>(_onVerifyOtp);
    on<AuthResendOtpEvent>(_onResendOtp);
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      final isLoggedIn = await _authRepository.isUserLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticatedState(user: user));
          return;
        }
      }
      emit(const AuthUnauthenticatedState());
    } catch (e) {
      emit(const AuthUnauthenticatedState());
    }
  }

  Future<void> _onSignIn(
    AuthSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      await _authRepository.signIn(event.email, event.password);
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticatedState(user: user));
      }
    } on Exception catch (e) {
      emit(AuthErrorState(message: _friendlyError(e.toString())));
    }
  }

  Future<void> _onSignUp(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      await _authRepository.signUp(event.email, event.password, event.fullName);
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        // Send OTP after account creation
        await _authRepository.sendOtp(user.email, user.id);
        emit(AuthOtpSentState(email: user.email, userId: user.id));
      }
    } on Exception catch (e) {
      emit(AuthErrorState(message: _friendlyError(e.toString())));
    }
  }

  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      await _authRepository.signInWithGoogle();
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticatedState(user: user));
      }
    } on Exception catch (e) {
      emit(AuthErrorState(message: _friendlyError(e.toString())));
    }
  }

  Future<void> _onSendOtp(
    AuthSendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      await _authRepository.sendOtp(event.email, event.userId);
      emit(AuthOtpSentState(email: event.email, userId: event.userId));
    } on Exception catch (e) {
      emit(AuthErrorState(message: _friendlyError(e.toString())));
    }
  }

  Future<void> _onVerifyOtp(
    AuthVerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      final isValid = await _authRepository.verifyOtp(event.userId, event.code);
      if (isValid) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          // Auto-login after successful OTP verification
          emit(AuthAuthenticatedState(user: user));
        }
      } else {
        // We need email to rebuild the OTP screen — get it from current user
        final user = await _authRepository.getCurrentUser();
        emit(AuthOtpErrorState(
          message: 'Incorrect or expired code. Please try again.',
          email: user?.email ?? '',
          userId: event.userId,
        ));
      }
    } on Exception catch (e) {
      final user = await _authRepository.getCurrentUser();
      emit(AuthOtpErrorState(
        message: _friendlyError(e.toString()),
        email: user?.email ?? '',
        userId: event.userId,
      ));
    }
  }

  Future<void> _onResendOtp(
    AuthResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      await _authRepository.resendOtp(event.email, event.userId);
      emit(AuthOtpResentState(email: event.email, userId: event.userId));
    } on Exception catch (e) {
      emit(AuthErrorState(message: _friendlyError(e.toString())));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(const AuthUnauthenticatedState());
  }

  String _friendlyError(String raw) {
    if (raw.contains('email-already-in-use')) {
      return 'An account with this email already exists.';
    }
    if (raw.contains('wrong-password') || raw.contains('invalid-credential')) {
      return 'Incorrect email or password.';
    }
    if (raw.contains('user-not-found')) {
      return 'No account found with this email. Please create an account first.';
    }
    if (raw.contains('weak-password')) {
      return 'Password must be at least 6 characters.';
    }
    if (raw.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    }
    if (raw.contains('network-request-failed')) {
      return 'No internet connection. Please check your network.';
    }
    if (raw.contains('too-many-requests')) {
      return 'Too many attempts. Please wait and try again.';
    }
    if (raw.contains('otp-not-verified')) {
      return 'Please verify your account with the code sent to your email first.';
    }
    return 'Something went wrong. Please try again.';
  }
}
