import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';


class GetItemByIdParams extends Equatable {
  final String itemId;

  const GetItemByIdParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

final getItemByIdUsecaseProvider = Provider<GetItemByIdUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return GetItemByIdUsecase(itemRepository: itemRepository);
});

class GetItemByIdUsecase
    implements UsecaseWithParams<ItemEntity, GetItemByIdParams> {
  final IItemRepository _itemRepository;

  GetItemByIdUsecase({required IItemRepository itemRepository})
    : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, ItemEntity>> call(GetItemByIdParams params) {
    return _itemRepository.getItemById(params.itemId);
  }
}
