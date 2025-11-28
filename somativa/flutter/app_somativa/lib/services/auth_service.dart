// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Endereço do seu Django (use o IP da sua máquina se for rodar no celular físico)
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login/');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Login Sucesso! Token: ${data['token']}");
        // Aqui você salvaria o token para usar depois
        return true;
      } else {
        print("Erro de Login: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return false;
    }
  }

  Future<bool> register(String username, String password, String email) async {
    final url = Uri.parse('$baseUrl/register/'); // Rota criada no Django

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
            {'username': username, 'password': password, 'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // 201 = Criado com sucesso
        print("Usuário criado com sucesso!");
        return true;
      } else {
        print("Erro ao cadastrar: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return false;
    }
  }
}
