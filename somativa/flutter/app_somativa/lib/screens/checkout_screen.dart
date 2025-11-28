// checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/viacep_service.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _cepController = TextEditingController();
  final _viaCepService = ViaCepService();
  
  // Variáveis para armazenar o endereço retornado
  String _enderecoCompleto = "Digite seu CEP para buscar o endereço";
  bool _buscando = false;

  void _buscarEndereco() async {
    setState(() => _buscando = true);
    
    final resultado = await _viaCepService.buscarCep(_cepController.text);

    setState(() {
      _buscando = false;
      if (resultado != null) {
        // Formata o endereço conforme requisito 
        _enderecoCompleto = "${resultado['logradouro']}, ${resultado['bairro']} - ${resultado['localidade']}/${resultado['uf']}";
      } else {
        _enderecoCompleto = "CEP não encontrado. Verifique os números.";
      }
    });
  }

  void _finalizarPedido() {
    // Aqui você limparia o carrinho e enviaria para o Django se fosse persistir o pedido
    Provider.of<CartProvider>(context, listen: false).clearCart();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Pedido Confirmado!"),
        content: Text("Sua comida chegará em breve em:\n\n$_enderecoCompleto"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Fecha Dialog
              Navigator.pop(ctx); // Sai do Checkout
              Navigator.pop(ctx); // Sai do Carrinho (Volta pro Menu)
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Acessa os dados do carrinho para exibir totais
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Finalizar Pedido"), backgroundColor: Colors.red),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ÁREA DE ENDEREÇO (Integração ViaCEP)
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Endereço de Entrega", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cepController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "CEP",
                              hintText: "00000000",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _buscando ? null : _buscarEndereco,
                          child: _buscando ? CircularProgressIndicator(color: Colors.white) : Text("BUSCAR"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(_enderecoCompleto, style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            
            Spacer(), // Empurra o resumo para baixo

            // RESUMO DE VALORES
            Text("Resumo do Pedido", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal"),
                Text("R\$ ${cart.subtotal.toStringAsFixed(2)}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Frete"),
                Text(
                  cart.deliveryFee == 0 ? "GRÁTIS" : "R\$ ${cart.deliveryFee.toStringAsFixed(2)}",
                  style: TextStyle(color: cart.deliveryFee == 0 ? Colors.green : Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.red[50],
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text("R\$ ${cart.total.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 20),

            // BOTÃO FINAL
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _finalizarPedido,
                child: Text("CONFIRMAR PEDIDO", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}