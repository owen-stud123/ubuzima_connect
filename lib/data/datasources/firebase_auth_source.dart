import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthSource {
  Future<User?> getCurrentUser();
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> signUp(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}

class FirebaseAuthSourceImpl implements FirebaseAuthSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthSourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<UserCredential> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();

    if (account == null) {
      throw Exception("Google sign in cancelled");
    }

    final auth = await account.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
