// register_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para capturar o texto
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();
  bool _isLoading = false;

  void _fazerCadastro() async {
    // Validação básica
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Preencha todos os campos!")));
      return;
    }

    setState(() => _isLoading = true);

    final sucesso = await _authService.register(
      _usernameController.text,
      _passwordController.text,
      _emailController.text,
    );

    setState(() => _isLoading = false);

    if (sucesso) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Conta criada! Faça login.")));
      // Volta para a tela de Login automaticamente
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao criar conta. Tente outro usuário.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Conta"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.person_add, size: 60, color: Colors.red[800]),
            SizedBox(height: 20),

            // Campo Usuário
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText: "Usuário", border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),

            // Campo Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),

            // Campo Senha
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Senha", border: OutlineInputBorder()),
            ),
            SizedBox(height: 24),

            // Botão Cadastrar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: _isLoading ? null : _fazerCadastro,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("CADASTRAR", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
