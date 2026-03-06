import 'package:equatable/equatable.dart';

/// Backend cart metadata.
class CartMeta extends Equatable {
  final String id;
  final String userId;
  final String? createdAt;
  final String? updatedAt;

  const CartMeta({
    required this.id,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory CartMeta.fromJson(Map<String, dynamic> json) {
    return CartMeta(
      id: (json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [id, userId, createdAt, updatedAt];
}

/// Populated product snapshot returned by GET /api/cart.
class CartProductSnapshot extends Equatable {
  final String id;
  final String phoneModel;
  final String category;
  final String finalPrice;
  final String basePrice;
  final List<String> photos;
  final bool isSold;
  final String status;
  final String description;

  const CartProductSnapshot({
    required this.id,
    required this.phoneModel,
    required this.category,
    required this.finalPrice,
    required this.basePrice,
    required this.photos,
    required this.isSold,
    required this.status,
    required this.description,
  });

  factory CartProductSnapshot.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['photos'];
    final photos = (rawPhotos is List)
        ? rawPhotos
            .map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList()
        : <String>[];

    return CartProductSnapshot(
      id: (json['_id'] ?? '').toString(),
      phoneModel: (json['phoneModel'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      finalPrice: (json['finalPrice'] ?? '').toString(),
      basePrice: (json['basePrice'] ?? '').toString(),
      photos: photos,
      isSold: json['isSold'] == true,
      status: (json['status'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phoneModel': phoneModel,
      'category': category,
      'finalPrice': finalPrice,
      'basePrice': basePrice,
      'photos': photos,
      'isSold': isSold,
      'status': status,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [
        id,
        phoneModel,
        category,
        finalPrice,
        basePrice,
        photos,
        isSold,
        status,
        description,
      ];
}

class CartItem extends Equatable {
  final String id;
  final String cartId;

  /// Either a String product id (e.g. from POST /api/cart/add) OR a populated
  /// [CartProductSnapshot] (from GET /api/cart).
  final Object productId;

  final double priceAtTime;
  final String? createdAt;
  final String? updatedAt;

  const CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.priceAtTime,
    this.createdAt,
    this.updatedAt,
  });

  CartProductSnapshot? get productSnapshot {
    final p = productId;
    return p is CartProductSnapshot ? p : null;
  }

  String get productIdValue {
    final p = productId;
    if (p is String) return p;
    if (p is CartProductSnapshot) return p.id;
    return p.toString();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final dynamic rawProduct = json['productId'];
    final Object productId;
    if (rawProduct is Map<String, dynamic>) {
      productId = CartProductSnapshot.fromJson(rawProduct);
    } else {
      productId = (rawProduct ?? '').toString();
    }

    return CartItem(
      id: (json['_id'] ?? '').toString(),
      cartId: (json['cartId'] ?? '').toString(),
      productId: productId,
      priceAtTime: _parseDouble(json['priceAtTime']),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'cartId': cartId,
      'productId': productId is CartProductSnapshot
          ? (productId as CartProductSnapshot).toJson()
          : productId.toString(),
      'priceAtTime': priceAtTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [id, cartId, productId, priceAtTime, createdAt, updatedAt];
}

class CartResponse extends Equatable {
  final CartMeta? cart;
  final List<CartItem> items;
  final double totalPrice;

  const CartResponse({
    required this.cart,
    required this.items,
    required this.totalPrice,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final cartJson = json['cart'];
    final CartMeta? cart = (cartJson is Map<String, dynamic>) ? CartMeta.fromJson(cartJson) : null;

    final rawItems = json['items'];
    final items = (rawItems is List)
        ? rawItems
            .whereType<Map>()
            .map((e) => CartItem.fromJson(e.cast<String, dynamic>()))
            .toList()
        : <CartItem>[];

    return CartResponse(
      cart: cart,
      items: items,
      totalPrice: _parseDouble(json['totalPrice']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart': cart?.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
    };
  }

  @override
  List<Object?> get props => [cart, items, totalPrice];
}
