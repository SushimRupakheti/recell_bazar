import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

class DeleteItemParams extends Equatable {
  final String itemId;

  const DeleteItemParams({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

final deleteItemUsecaseProvider = Provider<DeleteItemUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return DeleteItemUsecase(itemRepository: itemRepository);
});

class DeleteItemUsecase
    implements UsecaseWithParams<bool, DeleteItemParams> {
  final IItemRepository _itemRepository;

  DeleteItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteItemParams params) {
    return _itemRepository.deleteItem(params.itemId);
  }
}
