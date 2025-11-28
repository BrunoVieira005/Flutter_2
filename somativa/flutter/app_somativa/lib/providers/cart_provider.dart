// cart_provider.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  // Lista privada de itens no carrinho
  final List<Product> _items = [];

  // Getter para acessar a lista de fora (protegendo a original)
  List<Product> get items => _items;

  // Calcular o Subtotal (soma dos produtos)
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  // Calcular o Frete (Regra do documento: > R$ 100 é grátis)
  double get deliveryFee {
    if (subtotal >= 100.00) {
      return 0.00; // Frete Grátis
    } else {
      return 10.00; // Taxa fixa provisória (depois usaremos o ViaCEP)
    }
  }

  // Total Final
  double get total => subtotal + deliveryFee;

  // Adicionar Item
  void addItem(Product product) {
    _items.add(product);
    notifyListeners(); // Avisa o app que algo mudou (para atualizar a tela)
  }

  // Remover Item
  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  // Limpar Carrinho
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
