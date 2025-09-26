import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_sm_hotel/models/carrinho.dart';
import 'package:app_sm_hotel/screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarrinhoModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S&M Hotel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const LoginScreen(),
    );
  }
}
