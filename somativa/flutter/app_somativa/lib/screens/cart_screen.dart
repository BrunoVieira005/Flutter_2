import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart'; // Certifique-se que o caminho está correto

class CartScreen extends StatelessWidget {
  // 1. Variável para guardar o Token
  final String token;

  // 2. Construtor para receber o Token
  const CartScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    // O Consumer "escuta" o Provider. Se o carrinho mudar, essa parte reconstrói.
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Seu Carrinho"),
            backgroundColor: Colors.red,
            actions: [
              IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () => cart.clearCart(), // Botão para limpar tudo
              )
            ],
          ),
          body: Column(
            children: [
              // LISTA DE ITENS
              Expanded(
                child: cart.items.isEmpty
                    ? Center(child: Text("Seu carrinho está vazio :("))
                    : ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final product = cart.items[index];
                          return ListTile(
                            leading: Image.network(product.imageUrl, width: 50,
                                errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons
                                  .fastfood); // Fallback se a imagem falhar
                            }),
                            title: Text(product.name),
                            subtitle:
                                Text("R\$ ${product.price.toStringAsFixed(2)}"),
                            trailing: IconButton(
                              icon:
                                  Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                cart.removeItem(
                                    product); // Remove item individual
                              },
                            ),
                          );
                        },
                      ),
              ),

              // RESUMO DE VALORES (Rodapé)
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal:"),
                        Text("R\$ ${cart.subtotal.toStringAsFixed(2)}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Frete:"),
                        Text(
                          cart.deliveryFee == 0
                              ? "GRÁTIS"
                              : "R\$ ${cart.deliveryFee.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: cart.deliveryFee == 0
                                  ? Colors.green
                                  : Colors.black),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TOTAL:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("R\$ ${cart.total.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Botão para Finalizar (Vai para a Tela E - Confirmação/ViaCEP)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        // Só habilita se tiver itens no carrinho
                        onPressed: cart.items.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // 3. Passando o token adiante para o Checkout
                                    builder: (context) =>
                                        CheckoutScreen(token: token),
                                  ),
                                );
                              },
                        child: Text("CONFIRMAR PEDIDO",
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
