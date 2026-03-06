import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/cart/data/repositories/cart_repository.dart';
import 'package:recell_bazar/features/cart/domain/repositories/cart_repository.dart';

final removeFromCartUsecaseProvider =
    Provider<RemoveFromCartUsecase>((ref) {
  final cartRepository = ref.read(cartRepositoryProvider);
  return RemoveFromCartUsecase(cartRepository: cartRepository);
});

class RemoveFromCartUsecase implements UsecaseWithParams<bool, String> {
  final ICartRepository _cartRepository;

  RemoveFromCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, bool>> call(String cartItemId) {
    return _cartRepository.removeCartItem(cartItemId);
  }
}
