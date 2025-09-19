import 'package:app_delivery/data/app_database.dart';
import 'package:app_delivery/ui/_core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app_delivery/ui/widgets/home/home_screen.dart';
import 'package:app_delivery/ui/widgets/home/register_screen.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    setState(() {
      _errorMessage = null;
    });

    // Validação de campos
    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha todos os campos.';
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _errorMessage = 'Email inválido.';
      });
      return;
    }

    if (senha.length < 6) {
      setState(() {
        _errorMessage = 'A senha deve ter pelo menos 6 caracteres.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Conectando ao banco de dados
      final Database db = await AppDatabase.instance.database;

      // Consultando se o usuário existe
      final List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ? AND senha = ?',
        whereArgs: [email, senha],
      );

      // Se encontrar um usuário com email e senha válidos
      if (result.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Email ou senha incorretos.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao acessar o banco de dados. Tente novamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _fazerLogin,
                    child: Text('Entrar'),
                  ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'Não tem uma conta? Cadastre-se',
                style: TextStyle(color: AppColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}