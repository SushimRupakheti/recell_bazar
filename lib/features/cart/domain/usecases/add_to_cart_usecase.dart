import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/cart/data/repositories/cart_repository.dart';
import 'package:recell_bazar/features/cart/domain/repositories/cart_repository.dart';

final addToCartUsecaseProvider = Provider<AddToCartUsecase>((ref) {
  final cartRepository = ref.read(cartRepositoryProvider);
  return AddToCartUsecase(cartRepository: cartRepository);
});

class AddToCartUsecase implements UsecaseWithParams<bool, String> {
  final ICartRepository _cartRepository;

  AddToCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, bool>> call(String productId) {
    return _cartRepository.addToCart(productId);
  }
}
