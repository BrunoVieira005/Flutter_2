import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_sm_hotel/screens/home_screen.dart';
import 'package:app_sm_hotel/screens/cadastro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _login() async {
    final response = await http.get(
      Uri.parse(
          // Para funcionar:
          // Rodar: json-server --watch db.json --port 3000
          // Substituir o IP abaixo pelo IP de sua máquina
          // Feitas as etapas, já é possível tentar o login com algum usuário existente no arquivo solto db.json que se encontra na raíz do projeto ou com um novo cadastro.
          'http://10.109.83.12:3000/usuario?email=${_emailController.text}&senha=${_senhaController.text}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> usuarios = jsonDecode(response.body);
      if (usuarios.isNotEmpty) {
        // Usuário encontrado, navega para a tela Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Usuário não encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha incorretos')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao conectar ao servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text(
          'Login - S&M Hotel',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.brown[600],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CadastroScreen()),
                );
              },
              child: const Text('Não tem uma conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
