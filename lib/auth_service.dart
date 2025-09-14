// lib/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<UserCredential> registerWithEmail(String email, String password);
  Future<UserCredential> loginWithEmail(String email, String password);
  Future<void> logout();
  User? get currentUser;
  // DÜZELTME: Bu bir metot olmalı, getter değil.
  Stream<User?> authStateChanges();
}

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  @override
  Future<UserCredential> registerWithEmail(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> loginWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return _firebaseAuth.signOut();
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  // DÜZELTME: Metot çağrılmalı (parantezler eklendi).
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
}
