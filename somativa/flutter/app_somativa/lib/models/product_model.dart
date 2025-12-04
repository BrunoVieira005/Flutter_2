class Product {
  final int id;
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

  // Adicione esta fábrica (factory) que converte o JSON do Django para o Objeto Flutter
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['nome'], // O Django manda 'nome', nós usamos 'name'
      price: double.parse(json['preco'].toString()),
      type: json['categoria'],
      imageUrl: json['imagem_url'] ?? '', // Evita erro se vier nulo
    );
  }
}
