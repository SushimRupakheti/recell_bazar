import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

final getAllItemsUsecaseProvider = Provider<GetAllItemsUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetAllItemsUsecase(itemRepository: itemRepository);
});

class GetAllItemsUsecase
    implements UsecaseWithoutParams<List<ItemEntity>> {
  final IItemRepository _itemRepository;

  GetAllItemsUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, List<ItemEntity>>> call() {
    return _itemRepository.getAllItems();
  }
}
