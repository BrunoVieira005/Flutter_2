import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import '../models/product_model.dart';

class OrderService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  // ENVIAR PEDIDO (CHECKOUT)
  Future<bool> createOrder(String token, List<Product> cartItems, double total,
      String address) async {
    final url = Uri.parse('$baseUrl/pedidos/');

    // Mapeia os itens do carrinho para o JSON que o Django espera
    List<Map<String, dynamic>> itensFormatados = cartItems
        .map((p) => {
              "produto": p.id, // O Django precisa do ID numérico
              "quantidade": 1,
              "preco_no_momento": p.price
            })
        .toList();

    final bodyJson = jsonEncode({
      "total": total,
      "endereco_entrega": address,
      "itens": itensFormatados
    });

    print("Tentando enviar pedido: $bodyJson"); // Debug visual

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: bodyJson,
      );

      if (response.statusCode == 201) {
        print("Pedido criado com sucesso!");
        return true;
      } else {
        // AQUI ESTÁ O SEGREDO: Imprime o erro que o Django devolveu
        print("ERRO AO CRIAR PEDIDO (${response.statusCode}):");
        print(utf8.decode(
            response.bodyBytes)); // Decodifica para ler acentos se houver
        return false;
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return false;
    }
  }

  // BUSCAR MEUS PEDIDOS
  Future<List<Order>> getMyOrders(String token) async {
    final url = Uri.parse('$baseUrl/pedidos/');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Order.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar pedidos');
    }
  }
}
