import 'package:flutter/material.dart';
import 'package:app_delivery/data/app_database.dart'; // Importando o banco de dados
import 'package:sqflite/sqflite.dart'; // Necessário para usar o banco de dados

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String? _errorMessage;

  Future<void> _cadastrar() async {
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

    try {
      final Database db = await AppDatabase.instance.database;

      // Verificando se o email já existe no banco
      final List<Map<String, dynamic>> existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      // Se o email já estiver cadastrado
      if (existingUser.isNotEmpty) {
        setState(() {
          _errorMessage = 'Esse email já está cadastrado.';
        });
        return;
      }

      // Inserindo o usuário no banco de dados
      await db.insert(
        'users',
        {
          'email': email,
          'senha': senha,
        },
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Caso já exista, substitui
      );

      // Ao cadastrar, pode redirecionar para a tela de login ou home
      Navigator.pop(context); // Volta para a tela de login
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao cadastrar usuário. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
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
            ElevatedButton(
              onPressed: _cadastrar,
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
