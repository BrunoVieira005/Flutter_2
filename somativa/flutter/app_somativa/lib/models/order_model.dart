class Order {
  final int id;
  final String status;
  final double total;
  final String date;
  final String address;

  Order(
      {required this.id,
      required this.status,
      required this.total,
      required this.date,
      required this.address});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'] == 'P' ? 'Pendente' : 'Entregue',
      total: double.parse(json['total'].toString()),
      date: json['data_pedido'], // Você pode formatar a data se quiser
      address: json['endereco_entrega'],
    );
  }
}
