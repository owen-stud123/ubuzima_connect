import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthSource {
  Future<User?> getCurrentUser();
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> signUp(String email, String password, String fullName);
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendOtp(String email, String userId);
  Future<bool> verifyOtp(String userId, String code);
  Future<bool> isOtpVerified(String userId);
  Stream<User?> get authStateChanges;
}

class FirebaseAuthSourceImpl implements FirebaseAuthSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  FirebaseAuthSourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;

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
  Future<UserCredential> signUp(
      String email, String password, String fullName) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update display name
    await credential.user?.updateDisplayName(fullName);

    // Send email verification
    await credential.user?.sendEmailVerification();

    // Persist minimal user profile for account existence checks.
    final user = credential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email.trim().toLowerCase(),
        'fullName': fullName.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return credential;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw Exception('Google sign in cancelled');

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
  Future<void> sendOtp(String email, String userId) async {
    // Generate a 6-digit OTP
    final code = (100000 + Random().nextInt(900000)).toString();
    final expiresAt = DateTime.now().add(const Duration(minutes: 10));

    // Store OTP in Firestore
    await _firestore.collection('otps').doc(userId).set({
      'code': code,
      'email': email,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'verified': false,
    });

    // Write to the 'mail' collection — picked up by Firebase Trigger Email extension
    // (https://firebase.google.com/products/extensions/firebase-firestore-send-email)
    await _firestore.collection('mail').add({
      'to': [email],
      'message': {
        'subject':
            'UbuzimaConnect — Kode y\'Inyemezabuguzi / Verification Code',
        'text': 'Murakaza neza kuri UbuzimaConnect!\n\n'
            'Your verification code is: $code\n\n'
            'This code expires in 10 minutes. Do not share it with anyone.\n\n'
            '---\n'
            'Kode yawe ni: $code\n'
            'Kode irangira mu minota 10.',
        'html': '<div style="font-family:sans-serif;max-width:480px;margin:auto;">'
            '<h2 style="color:#1A73A7;">UbuzimaConnect</h2>'
            '<p>Murakaza neza! / Welcome!</p>'
            '<p>Your email verification code is:</p>'
            '<div style="font-size:36px;font-weight:bold;letter-spacing:8px;'
            'color:#2E9E6B;padding:16px;background:#f0faf5;border-radius:8px;'
            'text-align:center;">$code</div>'
            '<p style="color:#757575;font-size:13px;">This code expires in <b>10 minutes</b>. '
            'Do not share it with anyone.</p>'
            '</div>',
      },
    });
  }

  @override
  Future<bool> verifyOtp(String userId, String code) async {
    final doc = await _firestore.collection('otps').doc(userId).get();
    if (!doc.exists) return false;

    final data = doc.data()!;
    final storedCode = data['code'] as String;
    final expiresAt = (data['expiresAt'] as Timestamp).toDate();
    final verified = data['verified'] as bool? ?? false;

    if (verified) return false;
    if (DateTime.now().isAfter(expiresAt)) return false;
    if (storedCode != code) return false;

    // Mark as verified
    await _firestore.collection('otps').doc(userId).update({'verified': true});
    return true;
  }

  @override
  Future<bool> isOtpVerified(String userId) async {
    final doc = await _firestore.collection('otps').doc(userId).get();
    if (!doc.exists) {
      // Legacy users or non-OTP auth flows are treated as verified.
      return true;
    }
    final data = doc.data();
    return (data?['verified'] as bool?) ?? false;
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
