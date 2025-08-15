import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Controllers to capture user input
  final TextEditingController n1 = TextEditingController();
  final TextEditingController n2 = TextEditingController();

  // Variable to store the sum result
  double sum = 0;

  _sum() {
    setState(() {
      sum = (double.tryParse(n1.text)!) + (double.tryParse(n2.text)!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number 1',
                border: OutlineInputBorder(),
              ),
              controller: n1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Number 2', border: OutlineInputBorder()),
              controller: n2,
            ),
          ),
          Text(
            'Result: ${sum}',
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(onPressed: _sum, child: Text('Calculate'))
        ],
      ),
    );
  }
}
