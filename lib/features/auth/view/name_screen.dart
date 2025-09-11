import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  static const String routeName = '/name-screen';
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('İsim Ekranı'),
      ),
    );
  }
}
