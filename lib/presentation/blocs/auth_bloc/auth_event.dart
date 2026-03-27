import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {
  const AuthCheckStatusEvent();
}

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const AuthSignUpEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

class AuthSignInWithGoogleEvent extends AuthEvent {
  const AuthSignInWithGoogleEvent();
}

class AuthSendOtpEvent extends AuthEvent {
  final String email;
  final String userId;

  const AuthSendOtpEvent({required this.email, required this.userId});

  @override
  List<Object?> get props => [email, userId];
}

class AuthVerifyOtpEvent extends AuthEvent {
  final String userId;
  final String code;

  const AuthVerifyOtpEvent({required this.userId, required this.code});

  @override
  List<Object?> get props => [userId, code];
}

class AuthResendOtpEvent extends AuthEvent {
  final String email;
  final String userId;

  const AuthResendOtpEvent({required this.email, required this.userId});

  @override
  List<Object?> get props => [email, userId];
}

class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}
