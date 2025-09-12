// lib/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

abstract class AuthService {
  Future<String> registerWithEmail(String email, String password);
  Future<bool> loginWithEmail(String email, String password);
  Future<void> logout();
  Future<bool> isPremiumMember();

  static final firebaseAuth = FirebaseAuth.instance;
}

class FirebaseAuthService implements AuthService {
  @override
  Future<String> registerWithEmail(String email, String password) async {
    try {
      await AuthService.firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success";
    } catch (e) {
      throw Exception("Kayıt hatası: $e");
    }
  }

  @override
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      await AuthService.firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await AuthService.firebaseAuth.signOut();
  }

  @override
  Future<bool> isPremiumMember() async {
    // Firebase Firestore’da kontrol yapabilirsin.
    return true; // Placeholder
  }
}
