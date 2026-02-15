import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

class SearchItemsParams extends Equatable {
  final String? phoneModel;
  final String? category;

  const SearchItemsParams({
    this.phoneModel,
    this.category,
  });

  @override
  List<Object?> get props => [phoneModel, category];
}



final searchItemsUsecaseProvider = Provider<SearchItemsUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return SearchItemsUsecase(itemRepository: itemRepository);
});

class SearchItemsUsecase
    implements UsecaseWithParams<List<ItemEntity>, SearchItemsParams> {
  final IItemRepository _itemRepository;

  SearchItemsUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, List<ItemEntity>>> call(
      SearchItemsParams params) {
        return _itemRepository.searchItems(
          params.phoneModel ?? '',
      params.category,
    );
  }
}
