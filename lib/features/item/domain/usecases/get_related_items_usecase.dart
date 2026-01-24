import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

final getRelatedItemsUsecaseProvider =
    Provider<GetRelatedItemsUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetRelatedItemsUsecase(itemRepository: itemRepository);
});

class GetRelatedItemsUsecase
    implements UsecaseWithParams<List<ItemEntity>, String> {
  final IItemRepository _itemRepository;

  GetRelatedItemsUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  /// [itemId] = the reference item
  @override
  Future<Either<Failure, List<ItemEntity>>> call(String itemId) {
    return _itemRepository.getRelatedItems(itemId);
  }
}
