class Obat {
  String id;
  String name;
  String description;
  double price;
  String category;
  List<String> imageUrl;
  int stock;
  DateTime? createdAt;

  Obat({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.stock,
    this.createdAt,
  });

  // Factory constructor to create an Obat from JSON
  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      imageUrl: List<String>.from(json['imageUrl']),
      stock: json['stock'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert an Obat to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'stock': stock,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
