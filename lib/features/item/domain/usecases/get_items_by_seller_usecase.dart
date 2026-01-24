import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

final getItemsBySellerUsecaseProvider =
    Provider<GetItemsBySellerUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetItemsBySellerUsecase(itemRepository: itemRepository);
});

class GetItemsBySellerUsecase
    implements UsecaseWithParams<List<ItemEntity>, String> {
  final IItemRepository _itemRepository;

  GetItemsBySellerUsecase({
    required IItemRepository itemRepository,
  }) : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, List<ItemEntity>>> call(String sellerId) {
    return _itemRepository.getItemsBySeller(sellerId);
  }
}
