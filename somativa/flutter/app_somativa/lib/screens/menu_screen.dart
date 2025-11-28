// menu_screen.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:app_somativa/screens/cart_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Filtra as listas
    final lanches = mockProducts.where((p) => p.type == 'lanche').toList();
    final pizzas = mockProducts.where((p) => p.type == 'pizza').toList();

    return DefaultTabController(
      length: 2, // Temos 2 abas: Lanches e Pizzas
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mange Eats", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          centerTitle: true,
          actions: [
            // Ícone do Carrinho (iremos implementar a ação depois)
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                // Navegação para Tela Carrinho
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.lunch_dining), text: "Lanches"),
              Tab(icon: Icon(Icons.local_pizza), text: "Pizzas"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Conteúdo da Aba 1 (Lanches)
            _buildProductGrid(lanches),
            // Conteúdo da Aba 2 (Pizzas)
            _buildProductGrid(pizzas),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para construir o Grid de produtos
  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 colunas
        childAspectRatio: 0.75, // Altura vs Largura do cartão
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagem (usando NetworkImage para as URLs ou AssetImage se tiver local)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(product.imageUrl, fit: BoxFit.contain),
                ),
              ),
              // Nome e Preço
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text(
                      product.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "R\$ ${product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Botão Adicionar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: // Em menu_screen.dart, dentro do itemBuilder do GridView:

                    ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    // ADICIONA O PRODUTO AO CARRINHO
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(product);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${product.name} adicionado!"),
                      duration: Duration(seconds: 1),
                      action: SnackBarAction(
                        label: "VER CARRINHO",
                        onPressed: () {
                          // Navegar para o carrinho (vamos criar jaja)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                        },
                      ),
                    ));
                  },
                  child:
                      Text("Adicionar", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
