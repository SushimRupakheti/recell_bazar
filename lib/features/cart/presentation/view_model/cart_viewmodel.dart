import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/cart/data/repositories/cart_repository.dart';
import 'package:recell_bazar/features/cart/domain/repositories/cart_repository.dart';
import 'package:recell_bazar/features/cart/presentation/state/cart_state.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  CartViewModel.new,
);

class CartViewModel extends Notifier<CartState> {
  late final ICartRepository _cartRepository;

  @override
  CartState build() {
    _cartRepository = ref.read(cartRepositoryProvider);
    return const CartState();
  }

  Future<void> fetchCart() async {
    state = state.copyWith(status: CartStatus.loading, resetErrorMessage: true);

    final result = await _cartRepository.fetchCart();

    result.fold(
      (failure) => state = state.copyWith(
        status: CartStatus.error,
        errorMessage: failure.message,
      ),
      (cart) => state = state.copyWith(
        status: CartStatus.loaded,
        cart: cart,
        resetErrorMessage: true,
      ),
    );
  }

  /// Adds product to cart and refreshes the cart on success.
  /// Returns a [Failure] when the request fails (useful for UI-specific messages).
  Future<Failure?> addToCart(String productId) async {
    final result = await _cartRepository.addToCart(productId);

    Failure? failure;
    await result.fold(
      (f) async {
        failure = f;
        state = state.copyWith(status: CartStatus.error, errorMessage: f.message);
      },
      (_) async {
        await fetchCart();
      },
    );

    return failure;
  }

  /// Removes a cart item by cartItem._id and refreshes cart on success.
  Future<Failure?> removeCartItem(String cartItemId) async {
    final result = await _cartRepository.removeCartItem(cartItemId);

    Failure? failure;
    await result.fold(
      (f) async {
        failure = f;
        state = state.copyWith(status: CartStatus.error, errorMessage: f.message);
      },
      (_) async {
        await fetchCart();
      },
    );

    return failure;
  }
}
