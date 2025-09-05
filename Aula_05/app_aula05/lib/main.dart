import 'package:app_aula05/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AppBD());
}

class AppBD extends StatelessWidget {
  const AppBD({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pets + SQFLITE',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: HomePage(),
    );
  }
}
