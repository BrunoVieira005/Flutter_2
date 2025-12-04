import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import necessário para o Provider
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../providers/cart_provider.dart'; // Import do CartProvider
import 'cart_screen.dart';
import 'orders_screen.dart';

class MenuScreen extends StatefulWidget {
  final String token;

  const MenuScreen({super.key, required this.token});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService().getProducts(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mange Eats", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          actions: [
            // Botão Histórico
            IconButton(
              icon: Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // CORREÇÃO: Passando o token
                    builder: (context) => OrdersScreen(token: widget.token),
                  ),
                );
              },
            ),
            // Botão Carrinho
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // CORREÇÃO: Passando o token
                    builder: (context) => CartScreen(token: widget.token),
                  ),
                );
              },
            ),
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
        body: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Nenhum produto encontrado."));
            }

            final products = snapshot.data!;
            final lanches = products.where((p) => p.type == 'lanche').toList();
            final pizzas = products.where((p) => p.type == 'pizza').toList();

            return TabBarView(
              children: [
                _buildProductGrid(lanches),
                _buildProductGrid(pizzas),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) =>
                      Icon(Icons.fastfood, size: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(product.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("R\$ ${product.price.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(product);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${product.name} adicionado!"),
                      duration: Duration(seconds: 1),
                      action: SnackBarAction(
                        label: "VER CARRINHO",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  // CORREÇÃO: Passando o token aqui também!
                                  builder: (context) =>
                                      CartScreen(token: widget.token)));
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
