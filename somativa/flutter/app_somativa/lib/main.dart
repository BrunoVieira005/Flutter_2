// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importe o Provider
import 'screens/login_screen.dart';
import 'providers/cart_provider.dart'; // Importe seu provider

void main() {
  runApp(
    // Envolvemos o App no ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MangeEatsApp(),
    ),
  );
}

class MangeEatsApp extends StatelessWidget {
  const MangeEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mange Eats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
