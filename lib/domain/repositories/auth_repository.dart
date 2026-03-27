import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  @override
  List<Object?> get props => [id, email, name, photoUrl, isEmailVerified];
}

abstract class AuthRepository {
  Future<AuthUser?> getCurrentUser();
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password, String fullName);
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<bool> isUserLoggedIn();
  Future<void> sendOtp(String email, String userId);
  Future<bool> verifyOtp(String userId, String code);
  Future<void> resendOtp(String email, String userId);
}
