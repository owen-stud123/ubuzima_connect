import 'package:equatable/equatable.dart';
import 'package:ubuzima_connect/domain/repositories/auth_repository.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthAuthenticatedState extends AuthState {
  final AuthUser user;

  const AuthAuthenticatedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}

/// User account created; OTP has been sent to their email.
class AuthOtpSentState extends AuthState {
  final String email;
  final String userId;

  const AuthOtpSentState({required this.email, required this.userId});

  @override
  List<Object?> get props => [email, userId];
}

/// OTP was re-sent successfully.
class AuthOtpResentState extends AuthState {
  final String email;
  final String userId;

  const AuthOtpResentState({required this.email, required this.userId});

  @override
  List<Object?> get props => [email, userId];
}

/// OTP code verified successfully; user should login next.
class AuthOtpVerifiedState extends AuthState {
  final String email;

  const AuthOtpVerifiedState({required this.email});

  @override
  List<Object?> get props => [email];
}

/// OTP code was wrong or expired.
class AuthOtpErrorState extends AuthState {
  final String message;
  final String email;
  final String userId;

  const AuthOtpErrorState({
    required this.message,
    required this.email,
    required this.userId,
  });

  @override
  List<Object?> get props => [message, email, userId];
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
