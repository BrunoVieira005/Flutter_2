// login_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:app_somativa/screens/register_screen.dart';
import 'package:app_somativa/screens/menu_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _fazerLogin() async {
    setState(() => _isLoading = true);

    final sucesso = await _authService.login(
        _usernameController.text, _passwordController.text);

    setState(() => _isLoading = false);

    if (sucesso) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MenuScreen()));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Bem-vindo ao Mange Eats!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha no login. Verifique seus dados.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50], // Tom leve para combinar com comida
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou Título "Mange Eats"
              Icon(Icons.fastfood, size: 80, color: Colors.red),
              SizedBox(height: 20),
              Text(
                "MANGE EATS",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800]),
              ),
              SizedBox(height: 40),

              // Campo Usuário
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Usuário",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),

              // Campo Senha
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 24),

              // Botão de Login
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

              // Link para Cadastro (Tela B)
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
