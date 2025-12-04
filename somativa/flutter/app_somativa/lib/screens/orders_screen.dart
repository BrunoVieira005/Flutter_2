import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class OrdersScreen extends StatelessWidget {
  final String token;

  const OrdersScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Pedidos"), backgroundColor: Colors.red),
      body: FutureBuilder<List<Order>>(
        future: OrderService().getMyOrders(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Você ainda não fez pedidos."));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.receipt, color: Colors.white),
                  ),
                  title: Text(
                      "Pedido #${order.id} - R\$ ${order.total.toStringAsFixed(2)}"),
                  subtitle: Text("${order.status} \n${order.address}"),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
