import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

final getItemsByCategoryUsecaseProvider =
    Provider<GetItemsByCategoryUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetItemsByCategoryUsecase(itemRepository: itemRepository);
});

class GetItemsByCategoryUsecase
    implements UsecaseWithParams<List<ItemEntity>, String> {
  final IItemRepository _itemRepository;

  GetItemsByCategoryUsecase({
    required IItemRepository itemRepository,
  }) : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, List<ItemEntity>>> call(String categoryId) {
    return _itemRepository.getItemsByCategory(categoryId);
  }
}
