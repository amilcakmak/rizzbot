import 'package:flutter/material.dart';

class GenderScreen extends StatelessWidget {
  static const String routeName = '/gender-screen';
  const GenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Cinsiyet Ekranı'),
      ),
    );
  }
}
