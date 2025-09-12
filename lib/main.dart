// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rizzbot/screens/home_screen.dart';
import 'package:rizzbot/screens/login_screen.dart';
import 'package:rizzbot/screens/profile_screen.dart';
import 'package:rizzbot/screens/signup_screen.dart';
import 'package:rizzbot/screens/chat_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rizzbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        ChatScreen.routeName: (context) => const ChatScreen(),
      },
    );
  }
}
