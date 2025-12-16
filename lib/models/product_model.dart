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

}
