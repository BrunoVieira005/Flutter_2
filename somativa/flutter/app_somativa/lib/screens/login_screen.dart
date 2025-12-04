import 'dart:convert'; // Importante para jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Se fizer a requisição direto aqui ou use o service adaptado
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService(); // Seu service
  bool _isLoading = false;

  void _fazerLogin() async {
    setState(() => _isLoading = true);

    // Nota: Estou assumindo que você ajustou o AuthService para retornar o token ou Map
    // Se não, vamos fazer a lógica aqui direta para garantir:
    final url = Uri.parse('http://10.0.2.2:8000/api/login/');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text
        }),
        headers: {'Content-Type': 'application/json'},
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token']; // Extrai o token

        // CORREÇÃO: Passando o token para o MenuScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen(token: token)),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Falha no login.")));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro de conexão.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.fastfood, size: 80, color: Colors.red),
              SizedBox(height: 20),
              Text("MANGE EATS",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800])),
              SizedBox(height: 40),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: "Usuário",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _isLoading ? null : _fazerLogin,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("ENTRAR",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                },
                child: Text("Não tem conta? Cadastre-se"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
