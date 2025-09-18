import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizzbot/screens/profile_screen.dart';
import 'package:rizzbot/screens/login_screen.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  AnimationController? _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);

    _checkUserProfile(_auth.currentUser);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _checkUserProfile(User? user) async {
    if (user == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
      return;
    }

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists ||
        userDoc.data() == null ||
        userDoc.data()!['name'] == null) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "✨ RizzBot’a Hoş Geldin! ✨",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "“Onu etkilemek mi istiyorsun? 💫\n"
              "Yoksa işi büyütüp tamamen elde etmek mi?\n"
              "Belki de sadece kendinden soğutmadan muhabbeti akıcı tutmak istiyorsun…\n\n"
              "Ne düşünürsen düşün, doğru yerdesin.\n"
              "RizzBot senin gizli silahın — en doğru cümleleri, en doğru anda sana fısıldar.\n"
              "Şimdi vakit kaybetme, hamleni yap ve farkını ortaya koy. 😉”",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            // You can re-add the user-specific welcome message if you like
            // For example:
            // Text(
            //   "Hoş geldin, ${user?.displayName ?? 'Kullanıcı'}",
            //   style: const TextStyle(
            //     fontSize: 22,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
