import 'package:dartz/dartz.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';

abstract interface class ICartRepository {
  Future<Either<Failure, bool>> addToCart(String productId);

  Future<Either<Failure, CartResponse>> fetchCart();

  Future<Either<Failure, bool>> removeCartItem(String cartItemId);
}
