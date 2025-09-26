import 'package:flutter/material.dart';
import 'package:app_sm_hotel/screens/checkout_screen.dart';

class DestinoCard extends StatefulWidget {
  final String nome;
  final String img;
  final int valord;
  final int valorp;

  const DestinoCard(this.nome, this.img, this.valord, this.valorp, {super.key});

  @override
  State<DestinoCard> createState() => _DestinoCardState();
}

class _DestinoCardState extends State<DestinoCard> {
  int nDiarias = 0;
  int nPessoas = 0;
  double valorTotal = 0.0;

  void incrementarDiarias() {
    setState(() {
      nDiarias++;
    });
  }

  void incrementarPessoas() {
    setState(() {
      nPessoas++;
    });
  }

  void decrementarDiarias() {
    setState(() {
      nDiarias--;
      if (nDiarias < 0) {
        // Impede valor da quantidade de diárias ser menor que 0
        nDiarias = 0;
      }
    });
  }

  void decrementarPessoas() {
    setState(() {
      nPessoas--;
      if (nPessoas < 0) {
        // Impede valor da quantidade de pessoas ser menor que 0
        nPessoas = 0;
      }
    });
  }

  void calcularTotal() {
    double valorBruto =
        (nDiarias * widget.valord) + (nPessoas * widget.valorp).toDouble();

// Se o valor de diárias, ou de pessoas, for menor que 1, exibe mensagem informando que deve ser adicionada essa quantidade nos campos
    if (nDiarias < 1 || nPessoas < 1) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.brown[600],
            title: Row(
              children: [
                const SizedBox(width: 5),
                const Text('Aviso',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                const Icon(Icons.warning, color: Colors.yellow),
              ],
            ),
            content: const Text(
              'Para calcular o valor da reserva, devem ser selecionadas no mínimo:\n\n- 1 Diária \n- 1 Pessoa\n\nRevise seu pedido e tente novamente.',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            destinoNome: widget.nome,
            diarias: nDiarias,
            pessoas: nPessoas,
            valorBruto: valorBruto,
          ),
        ),
      );
    }
  }

  void limparCampos() {
    setState(() {
      nDiarias = 0;
      nPessoas = 0;
      valorTotal = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Container para a imagem
          Container(
            width: 393,
            height: 250,
            color: Colors.grey,
            child: Image.asset(widget.img, fit: BoxFit.fill),
          ),
          const SizedBox(
            height: 5,
          ),
          // Nome do destino
          Text(widget.nome,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          // Valores da diária e por pessoa
          Text("R\$ ${widget.valord}/dia - R\$ ${widget.valorp}/pessoa",
              style: const TextStyle(fontSize: 16, color: Colors.red)),

          // Quantidade de dias
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Quantidade de dias: "),
              Text("$nDiarias"),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: incrementarDiarias,
              ),
              IconButton(
                icon: const Icon(Icons.horizontal_rule),
                onPressed: decrementarDiarias,
              ),
            ],
          ),

          // Quantidade de pessoas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Quantidade de pessoas: "),
              Text("$nPessoas"),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: incrementarPessoas,
              ),
              IconButton(
                icon: const Icon(Icons.horizontal_rule),
                onPressed: decrementarPessoas,
              ),
            ],
          ),

          // Valor total
          Text("Valor total R\$: ${valorTotal.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          // Botões de calcular e limpar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: calcularTotal,
                child: const Text("Calcular"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: limparCampos,
                child: const Text("Limpar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
