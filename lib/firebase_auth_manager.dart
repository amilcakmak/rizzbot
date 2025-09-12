// firebase_auth_manager.dart dosyasında

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

class AuthService {
  static final user = FirebaseAuth.instance.currentUser;

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      await user.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Diğer metotları...
}
