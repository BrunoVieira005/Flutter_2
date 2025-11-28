// product_model.dart

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String type; // 'lanche' ou 'pizza'

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.type,
  });
}

// Lista simulada de produtos (Mock Data)
final List<Product> mockProducts = [
  Product(
      id: '1',
      name: 'X-Bacon',
      price: 25.00,
      type: 'lanche',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
  Product(
      id: '2',
      name: 'X-Salada',
      price: 20.00,
      type: 'lanche',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
  Product(
      id: '3',
      name: 'Calabresa',
      price: 45.00,
      type: 'pizza',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3132/3132693.png'),
  Product(
      id: '4',
      name: 'Mussarela',
      price: 40.00,
      type: 'pizza',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3132/3132693.png'),
  Product(
      id: '5',
      name: 'X-Tudo',
      price: 32.00,
      type: 'lanche',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
  Product(
      id: '6',
      name: 'Portuguesa',
      price: 50.00,
      type: 'pizza',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3132/3132693.png'),
];
