import 'package:flutter/material.dart';
import 'package:rizzbot/features/auth/view/gender_screen.dart';
import 'package:rizzbot/features/auth/view/name_screen.dart';
import 'package:rizzbot/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rizz App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: LoginScreen(),
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        NameScreen.routeName: (context) => NameScreen(),
        GenderScreen.routeName: (context) => GenderScreen(),
      },
    );
  }
}
