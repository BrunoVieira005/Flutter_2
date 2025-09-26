import 'package:flutter/material.dart';
import 'package:app_sm_hotel/models/carrinho.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final String destinoNome;
  final int diarias;
  final int pessoas;
  final double valorBruto;

  const CheckoutScreen({
    super.key,
    required this.destinoNome,
    required this.diarias,
    required this.pessoas,
    required this.valorBruto,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _formaPagamento = 'Cartão de Crédito';
  double _valorFinal = 0.0;

  @override
  void initState() {
    super.initState();
    _atualizarValor();
  }

  void _atualizarValor() {
    setState(() {
      _valorFinal = _formaPagamento == 'Pix'
          ? widget.valorBruto * 0.90
          : widget.valorBruto;
    });
  }

  void _finalizarCompra() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Compra Finalizada'),
          content:
              Text('Sua reserva para ${widget.destinoNome} foi confirmada!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
        centerTitle: true,
        backgroundColor: Colors.brown[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo da Compra',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Destino: ${widget.destinoNome}',
                style: const TextStyle(fontSize: 18)),
            Text('Diárias: ${widget.diarias}',
                style: const TextStyle(fontSize: 18)),
            Text('Pessoas: ${widget.pessoas}',
                style: const TextStyle(fontSize: 18)),
            const Divider(height: 30),
            Text('Valor Bruto: R\$ ${widget.valorBruto.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text(
              'Forma de Pagamento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Cartão de Crédito'),
              value: 'Cartão de Crédito',
              groupValue: _formaPagamento,
              onChanged: (value) {
                setState(() {
                  _formaPagamento = value!;
                  _atualizarValor();
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Pix (10% de desconto)'),
              value: 'Pix',
              groupValue: _formaPagamento,
              onChanged: (value) {
                setState(() {
                  _formaPagamento = value!;
                  _atualizarValor();
                });
              },
            ),
            const Divider(height: 30),
            Text(
              'Valor Total: R\$ ${_valorFinal.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _finalizarCompra,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Finalizar Compra',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
