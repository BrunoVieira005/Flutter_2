// viacep_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Map<String, dynamic>?> buscarCep(String cep) async {
    // Remove caracteres não numéricos caso o usuário digite traço/ponto
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepLimpo.length != 8) return null;

    final url = Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);
        if (dados.containsKey('erro')) return null; // CEP inexistente
        return dados;
      }
    } catch (e) {
      print("Erro ViaCEP: $e");
    }
    return null;
  }
}
