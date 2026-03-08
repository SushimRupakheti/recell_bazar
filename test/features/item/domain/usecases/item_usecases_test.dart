import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/usecases/create_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_category_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_seller_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_related_items_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/mark_item_as_sold_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/search_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/update_item_usecase.dart';

class FakeItemRepository implements IItemRepository {
  ItemEntity? createdItem;
  ItemEntity? updatedItem;
  String? deletedItemId;
  String? requestedItemId;
  String? requestedCategoryId;
  String? requestedSellerId;
  String? requestedRelatedItemId;
  String? requestedSearchPhoneModel;
  String? requestedSearchCategory;
  String? markedAsSoldItemId;

  Either<Failure, bool> createResult = const Right(true);
  Either<Failure, bool> updateResult = const Right(true);
  Either<Failure, bool> deleteResult = const Right(true);
  Either<Failure, List<ItemEntity>> getAllResult = const Right(<ItemEntity>[]);
  Either<Failure, ItemEntity>? getItemByIdResult;
  Either<Failure, List<ItemEntity>> getByCategoryResult =
      const Right(<ItemEntity>[]);
  Either<Failure, List<ItemEntity>> getBySellerResult = const Right(<ItemEntity>[]);
  Either<Failure, List<ItemEntity>> getRelatedResult = const Right(<ItemEntity>[]);
  Either<Failure, List<ItemEntity>> searchResult = const Right(<ItemEntity>[]);
  Either<Failure, bool> markSoldResult = const Right(true);

  @override
  Future<Either<Failure, bool>> createItem(ItemEntity item) async {
    createdItem = item;
    return createResult;
  }

  @override
  Future<Either<Failure, bool>> updateItem(ItemEntity item) async {
    updatedItem = item;
    return updateResult;
  }

  @override
  Future<Either<Failure, bool>> deleteItem(String itemId) async {
    deletedItemId = itemId;
    return deleteResult;
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    return getAllResult;
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemById(String itemId) async {
    requestedItemId = itemId;
    return getItemByIdResult ??
        Left(ApiFailure(message: 'getItemByIdResult not configured'));
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByCategory(
    String categoryId,
  ) async {
    requestedCategoryId = categoryId;
    return getByCategoryResult;
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsBySeller(String sellerId) async {
    requestedSellerId = sellerId;
    return getBySellerResult;
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getRelatedItems(String itemId) async {
    requestedRelatedItemId = itemId;
    return getRelatedResult;
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> searchItems(
    String phoneModel,
    String? categoryId,
  ) async {
    requestedSearchPhoneModel = phoneModel;
    requestedSearchCategory = categoryId;
    return searchResult;
  }

  @override
  Future<Either<Failure, bool>> markItemAsSold(String itemId) async {
    markedAsSoldItemId = itemId;
    return markSoldResult;
  }

  @override
  Future<Either<Failure, bool>> addToCart(String itemId) async =>
      const Right(true);

  @override
  Future<Either<Failure, bool>> removeFromCart(String itemId) async =>
      const Right(true);

  @override
  Future<Either<Failure, List<ItemEntity>>> getCartItems() async =>
      const Right(<ItemEntity>[]);

  @override
  Future<Either<Failure, bool>> clearCart() async => const Right(true);

  @override
  Future<Either<Failure, String>> uploadPhoto(File photo) async =>
      const Right('photo-url');

  @override
  Future<Either<Failure, String>> uploadVideo(File video) async =>
      const Right('video-url');
}

ItemEntity sampleItem({String id = 'item-1'}) {
  return ItemEntity(
    itemId: id,
    sellerId: 'seller-1',
    photos: const <String>[],
    category: 'Apple',
    phoneModel: 'iPhone 13',
    finalPrice: '50000',
    basePrice: '60000',
    year: 2022,
    batteryHealth: 88,
    description: 'Good',
    chargerAvailable: true,
    factoryUnlock: true,
    liquidDamage: false,
    switchOn: true,
    receiveCall: true,
    features1Condition: true,
    features2Condition: true,
    cameraCondition: true,
    displayCondition: true,
    displayCracked: false,
    displayOriginal: true,
  );
}

void main() {
  late FakeItemRepository repo;

  setUp(() {
    repo = FakeItemRepository();
  });

  test('1) GetAllItemsUsecase returns repository result', () async {
    final expected = <ItemEntity>[sampleItem()];
    repo.getAllResult = Right(expected);
    final usecase = GetAllItemsUsecase(itemRepository: repo);

    final result = await usecase();

    expect(result, Right(expected));
  });

  test('2) GetItemByIdUsecase forwards itemId', () async {
    final expected = sampleItem(id: 'item-99');
    repo.getItemByIdResult = Right(expected);
    final usecase = GetItemByIdUsecase(itemRepository: repo);

    final result = await usecase(const GetItemByIdParams(itemId: 'item-99'));

    expect(repo.requestedItemId, 'item-99');
    expect(result, Right(expected));
  });

  test('3) GetItemsByCategoryUsecase forwards categoryId', () async {
    final usecase = GetItemsByCategoryUsecase(itemRepository: repo);

    await usecase('Samsung');

    expect(repo.requestedCategoryId, 'Samsung');
  });

  test('4) GetItemsBySellerUsecase forwards sellerId', () async {
    final usecase = GetItemsBySellerUsecase(itemRepository: repo);

    await usecase('seller-77');

    expect(repo.requestedSellerId, 'seller-77');
  });

  test('5) GetRelatedItemsUsecase forwards itemId', () async {
    final usecase = GetRelatedItemsUsecase(itemRepository: repo);

    await usecase('item-12');

    expect(repo.requestedRelatedItemId, 'item-12');
  });

  test('6) SearchItemsUsecase maps null model to empty string', () async {
    final usecase = SearchItemsUsecase(itemRepository: repo);

    await usecase(const SearchItemsParams(phoneModel: null, category: 'Apple'));

    expect(repo.requestedSearchPhoneModel, '');
    expect(repo.requestedSearchCategory, 'Apple');
  });

  test('7) DeleteItemUsecase forwards param itemId', () async {
    final usecase = DeleteItemUsecase(itemRepository: repo);

    await usecase(const DeleteItemParams(itemId: 'item-del'));

    expect(repo.deletedItemId, 'item-del');
  });

  test('8) MarkItemAsSoldUsecase forwards itemId', () async {
    final usecase = MarkItemAsSoldUsecase(itemRepository: repo);

    await usecase('item-sold');

    expect(repo.markedAsSoldItemId, 'item-sold');
  });

  test('9) CreateItemUsecase maps params to ItemEntity correctly', () async {
    final usecase = CreateItemUsecase(itemRepository: repo);
    const params = CreateItemParams(
      sellerId: 'seller-2',
      photos: <String>['p1'],
      category: 'Google',
      phoneModel: 'Pixel 8',
      year: 2023,
      finalPrice: '70000',
      basePrice: '80000',
      batteryHealth: 95,
      description: 'Excellent',
      chargerAvailable: false,
      factoryUnlock: true,
      liquidDamage: false,
      switchOn: true,
      receiveCall: true,
      features1Condition: true,
      features2Condition: true,
      cameraCondition: true,
      displayCondition: true,
      displayCracked: false,
      displayOriginal: true,
    );

    await usecase(params);

    expect(repo.createdItem, isNotNull);
    expect(repo.createdItem!.sellerId, 'seller-2');
    expect(repo.createdItem!.phoneModel, 'Pixel 8');
    expect(repo.createdItem!.finalPrice, '70000');
    expect(repo.createdItem!.chargerAvailable, isFalse);
  });

  test('10) UpdateItemUsecase applies defaults for null fields', () async {
    final usecase = UpdateItemUsecase(itemRepository: repo);
    const params = UpdateItemParams(itemId: 'item-upd');

    await usecase(params);

    expect(repo.updatedItem, isNotNull);
    expect(repo.updatedItem!.itemId, 'item-upd');
    expect(repo.updatedItem!.sellerId, '');
    expect(repo.updatedItem!.phoneModel, '');
    expect(repo.updatedItem!.year, 0);
    expect(repo.updatedItem!.chargerAvailable, isFalse);
  });
}
