import 'package:equatable/equatable.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  error,
}

class CartState extends Equatable {
  final CartStatus status;
  final CartResponse? cart;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
  });

  CartState copyWith({
    CartStatus? status,
    CartResponse? cart,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage];
}
