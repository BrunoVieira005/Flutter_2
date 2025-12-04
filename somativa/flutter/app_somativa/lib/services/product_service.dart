import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  // Endereço do Django (10.0.2.2 é o localhost do Android Emulator)
  final String baseUrl = "http://10.0.2.2:8000/api";

  // Método para buscar produtos
  // Exige o token para provar que o usuário está logado
  Future<List<Product>> getProducts(String token) async {
    final url = Uri.parse('$baseUrl/produtos/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // O Django espera o cabeçalho 'Authorization: Token XXXXXX'
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        // O corpo vem como uma lista de objetos JSON
        List<dynamic> body = jsonDecode(response.body);

        // Converte cada item JSON em um objeto Product
        return body.map((dynamic item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
