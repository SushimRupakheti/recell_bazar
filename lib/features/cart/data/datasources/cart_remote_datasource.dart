import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_client.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';

abstract interface class ICartRemoteDataSource {
  Future<void> addToCart(String productId);
  Future<CartResponse> fetchCart();
  Future<void> removeCartItem(String cartItemId);
}

final cartRemoteDataSourceProvider = Provider<ICartRemoteDataSource>((ref) {
  return CartRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class CartRemoteDataSource implements ICartRemoteDataSource {
  final ApiClient _apiClient;

  CartRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<void> addToCart(String productId) async {
    final response = await _apiClient.post(
      ApiEndpoints.cartAdd,
      data: {'productId': productId},
    );

    final raw = response.data;
    if (raw is Map && raw['success'] == true) return;

    // If backend doesn't include success flag, treat 200 as success.
    return;
  }

  @override
  Future<CartResponse> fetchCart() async {
    final response = await _apiClient.get(ApiEndpoints.cart);

    final raw = response.data;
    dynamic payload;
    if (raw is Map) {
      payload = raw['data'] ?? raw;
    } else {
      payload = raw;
    }

    if (payload is Map<String, dynamic>) {
      return CartResponse.fromJson(payload);
    }

    throw Exception('CartRemoteDataSource.fetchCart: unexpected response shape: $raw');
  }

  @override
  Future<void> removeCartItem(String cartItemId) async {
    final response = await _apiClient.delete(ApiEndpoints.cartRemove(cartItemId));

    final raw = response.data;
    if (raw is Map && raw['success'] == true) return;

    return;
  }
}
