import 'package:flutter/material.dart';

class CarrinhoModel with ChangeNotifier {
  double _total = 0.0;
  double _valorBruto = 0.0;
  String _formaPagamento = 'Cartão de Crédito'; 

  double get total => _total;
  double get valorBruto => _valorBruto;
  String get formaPagamento => _formaPagamento;

  void calcularTotal(int diarias, int valorDiaria, int pessoas, int valorPessoa,
      {String formaPagamento = 'Cartão de Crédito'}) {
    _valorBruto = (diarias * valorDiaria) + (pessoas * valorPessoa).toDouble();
    _formaPagamento = formaPagamento;

    if (formaPagamento == 'Pix') {
      _total = _valorBruto * 0.9; // 10% de desconto
    } else {
      _total = _valorBruto;
    }
    notifyListeners();
  }

  void limparCarrinho() {
    _total = 0.0;
    _valorBruto = 0.0;
    _formaPagamento = 'Cartão de Crédito';
    notifyListeners();
  }
}
