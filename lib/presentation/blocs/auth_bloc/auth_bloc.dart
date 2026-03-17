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
        }
      } else {
        emit(const AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    try {
      await _authRepository.signIn(event.email, event.password);
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticatedState(user: user));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    try {
      await _authRepository.signUp(event.email, event.password);
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticatedState(user: user));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
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
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());
    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }
}
