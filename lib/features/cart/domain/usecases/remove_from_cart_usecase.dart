import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

final removeFromCartUsecaseProvider =
    Provider<RemoveFromCartUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return RemoveFromCartUsecase(itemRepository: itemRepository);
});

class RemoveFromCartUsecase implements UsecaseWithParams<bool, String> {
  final IItemRepository _itemRepository;

  RemoveFromCartUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(String itemId) {
    return _itemRepository.removeFromCart(itemId);
  }
}
