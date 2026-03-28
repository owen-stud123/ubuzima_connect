import 'package:ubuzima_connect/data/datasources/firebase_auth_source.dart';
import 'package:ubuzima_connect/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthSource _authSource;

  AuthRepositoryImpl({required FirebaseAuthSource authSource})
      : _authSource = authSource;

  @override
  Future<AuthUser?> getCurrentUser() async {
    final user = await _authSource.getCurrentUser();
    if (user == null) return null;
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
      isEmailVerified: true,
    );
  }

  @override
  Future<void> signIn(String email, String password) async {
    await _authSource.signIn(email, password);
  }

  @override
  Future<void> signUp(String email, String password, String fullName) async {
    await _authSource.signUp(email, password, fullName);
  }

  @override
  Future<void> signInWithGoogle() async {
    await _authSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _authSource.signOut();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final user = await _authSource.getCurrentUser();
    return user != null;
  }

  @override
  Future<void> sendOtp(String email, String userId) async {
    await _authSource.sendOtp(email, userId);
  }

  @override
  Future<bool> verifyOtp(String userId, String code) async {
    return await _authSource.verifyOtp(userId, code);
  }

  @override
  Future<void> resendOtp(String email, String userId) async {
    await _authSource.sendOtp(email, userId);
  }
}
