import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

final addToCartUsecaseProvider = Provider<AddToCartUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return AddToCartUsecase(itemRepository: itemRepository);
});

class AddToCartUsecase implements UsecaseWithParams<bool, String> {
  final IItemRepository _itemRepository;

  AddToCartUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(String itemId) {
    return _itemRepository.addToCart(itemId);
  }
}
