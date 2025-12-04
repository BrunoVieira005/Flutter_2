import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/viacep_service.dart';
import '../services/order_service.dart'; // Importe seu service de pedidos
import 'orders_screen.dart'; // Para navegar após o sucesso

class CheckoutScreen extends StatefulWidget {
  // 1. Variável declarada
  final String token;

  // 2. CONSTRUTOR CORRIGIDO (Adicionado required this.token)
  const CheckoutScreen({super.key, required this.token});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _cepController = TextEditingController();
  final _viaCepService = ViaCepService();

  String _enderecoCompleto = "Digite seu CEP para buscar o endereço";
  bool _buscando = false;

  void _buscarEndereco() async {
    setState(() => _buscando = true);
    final resultado = await _viaCepService.buscarCep(_cepController.text);
    setState(() {
      _buscando = false;
      if (resultado != null) {
        _enderecoCompleto =
            "${resultado['logradouro']}, ${resultado['bairro']} - ${resultado['localidade']}/${resultado['uf']}";
      } else {
        _enderecoCompleto = "CEP não encontrado.";
      }
    });
  }

  void _finalizarPedido() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Usa widget.token para acessar a variável da classe de cima
    final sucesso = await OrderService().createOrder(widget.token,
        cartProvider.items, cartProvider.total, _enderecoCompleto);

    if (sucesso) {
      cartProvider.clearCart();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Sucesso!"),
          content: Text("Pedido realizado e salvo no histórico."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(ctx);
                Navigator.pop(ctx);
                // Navega para histórico passando o token
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OrdersScreen(token: widget.token)));
              },
              child: Text("VER PEDIDOS"),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro ao processar pedido.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar:
          AppBar(title: Text("Finalizar Pedido"), backgroundColor: Colors.red),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Endereço de Entrega",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cepController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: "CEP", border: OutlineInputBorder()),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _buscando ? null : _buscarEndereco,
                          child: _buscando
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("BUSCAR"),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(_enderecoCompleto, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            Spacer(),
            Text("TOTAL: R\$ ${cart.total.toStringAsFixed(2)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red)),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _finalizarPedido,
                child: Text("CONFIRMAR PEDIDO",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
