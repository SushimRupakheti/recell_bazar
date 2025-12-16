class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int storage;
  final String imageUrl;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.storage,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // For backend integration
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      storage: json['storage'],
      imageUrl: json['image_url'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'storage': storage,
      'image_url': imageUrl,
      'is_favorite': isFavorite,
    };
  }
}
