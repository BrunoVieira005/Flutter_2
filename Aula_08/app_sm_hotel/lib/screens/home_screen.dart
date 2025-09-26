import 'package:flutter/material.dart';
import 'package:app_sm_hotel/widgets/destino_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text(
          'S&M Hotel',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.brown[600],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          DestinoCard("Angra dos Reis", "assets/angra.jpeg", 384, 70),
          DestinoCard("Jericoacoara", "assets/jeri.jpeg", 571, 75),
          DestinoCard("Arraial do Cabo", "assets/arraial.jpeg", 534, 65),
          DestinoCard("Florianópolis", "assets/florianopolis.jpeg", 348, 85),
          DestinoCard("Madri", "assets/madri.jpeg", 401, 85),
          DestinoCard("Paris", "assets/paris.jpeg", 546, 95),
          DestinoCard("Orlando", "assets/orlando.jpeg", 616, 105),
          DestinoCard("Las Vegas", "assets/las_vegas.jpeg", 504, 110),
          DestinoCard("Roma", "assets/roma.jpeg", 478, 85),
          DestinoCard("Chile", "assets/chile.jpeg", 446, 95),
        ],
      ),
    );
  }
}
