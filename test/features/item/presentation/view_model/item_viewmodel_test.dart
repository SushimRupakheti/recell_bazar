import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/usecases/create_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_category_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_seller_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_related_items_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/search_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/update_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/upload_photo_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/upload_video_usecase.dart';
import 'package:recell_bazar/features/item/presentation/state/item_state.dart';
import 'package:recell_bazar/features/item/presentation/view_model/item_viewmodel.dart';

class MockGetAllItemsUsecase extends Mock implements GetAllItemsUsecase {}

class MockGetItemByIdUsecase extends Mock implements GetItemByIdUsecase {}

class MockGetItemsBySellerUsecase extends Mock implements GetItemsBySellerUsecase {}

class MockCreateItemUsecase extends Mock implements CreateItemUsecase {}

class MockUpdateItemUsecase extends Mock implements UpdateItemUsecase {}

class MockDeleteItemUsecase extends Mock implements DeleteItemUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockUploadVideoUsecase extends Mock implements UploadVideoUsecase {}

class MockSearchItemsUsecase extends Mock implements SearchItemsUsecase {}

class MockGetItemsByCategoryUsecase extends Mock implements GetItemsByCategoryUsecase {}

class MockGetRelatedItemsUsecase extends Mock implements GetRelatedItemsUsecase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const GetItemByIdParams(itemId: 'id'));
    registerFallbackValue(const DeleteItemParams(itemId: 'id'));
    registerFallbackValue(
      const SearchItemsParams(phoneModel: 'model', category: 'cat'),
    );
    registerFallbackValue(
      const CreateItemParams(
        sellerId: 'seller',
        photos: <String>[],
        category: 'cat',
        phoneModel: 'model',
        year: 2022,
        finalPrice: '1',
        basePrice: '2',
        batteryHealth: 90,
        description: 'desc',
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
      ),
    );
    registerFallbackValue(const UpdateItemParams(itemId: 'id'));
    registerFallbackValue(File('dummy.file'));
  });

  late ProviderContainer container;
  late MockGetAllItemsUsecase mockGetAllItemsUsecase;
  late MockGetItemByIdUsecase mockGetItemByIdUsecase;
  late MockGetItemsBySellerUsecase mockGetItemsBySellerUsecase;
  late MockCreateItemUsecase mockCreateItemUsecase;
  late MockUpdateItemUsecase mockUpdateItemUsecase;
  late MockDeleteItemUsecase mockDeleteItemUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late MockUploadVideoUsecase mockUploadVideoUsecase;
  late MockSearchItemsUsecase mockSearchItemsUsecase;
  late MockGetItemsByCategoryUsecase mockGetItemsByCategoryUsecase;
  late MockGetRelatedItemsUsecase mockGetRelatedItemsUsecase;

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
      batteryHealth: 90,
      description: 'Good item',
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

  setUp(() {
    mockGetAllItemsUsecase = MockGetAllItemsUsecase();
    mockGetItemByIdUsecase = MockGetItemByIdUsecase();
    mockGetItemsBySellerUsecase = MockGetItemsBySellerUsecase();
    mockCreateItemUsecase = MockCreateItemUsecase();
    mockUpdateItemUsecase = MockUpdateItemUsecase();
    mockDeleteItemUsecase = MockDeleteItemUsecase();
    mockUploadPhotoUsecase = MockUploadPhotoUsecase();
    mockUploadVideoUsecase = MockUploadVideoUsecase();
    mockSearchItemsUsecase = MockSearchItemsUsecase();
    mockGetItemsByCategoryUsecase = MockGetItemsByCategoryUsecase();
    mockGetRelatedItemsUsecase = MockGetRelatedItemsUsecase();

    when(() => mockGetAllItemsUsecase()).thenAnswer((_) async => const Right(<ItemEntity>[]));
    when(() => mockGetItemByIdUsecase(any())).thenAnswer((_) async => Right(sampleItem()));
    when(() => mockGetItemsBySellerUsecase(any())).thenAnswer((_) async => const Right(<ItemEntity>[]));
    when(() => mockCreateItemUsecase(any())).thenAnswer((_) async => const Right(true));
    when(() => mockUpdateItemUsecase(any())).thenAnswer((_) async => const Right(true));
    when(() => mockDeleteItemUsecase(any())).thenAnswer((_) async => const Right(true));
    when(() => mockUploadPhotoUsecase(any())).thenAnswer((_) async => const Right('photo-url'));
    when(() => mockUploadVideoUsecase(any())).thenAnswer((_) async => const Right('video-url'));
    when(() => mockSearchItemsUsecase(any())).thenAnswer((_) async => const Right(<ItemEntity>[]));
    when(() => mockGetItemsByCategoryUsecase(any())).thenAnswer((_) async => const Right(<ItemEntity>[]));
    when(() => mockGetRelatedItemsUsecase(any())).thenAnswer((_) async => const Right(<ItemEntity>[]));

    container = ProviderContainer(
      overrides: [
        getAllItemsUsecaseProvider.overrideWithValue(mockGetAllItemsUsecase),
        getItemByIdUsecaseProvider.overrideWithValue(mockGetItemByIdUsecase),
        getItemsBySellerUsecaseProvider.overrideWithValue(mockGetItemsBySellerUsecase),
        createItemUsecaseProvider.overrideWithValue(mockCreateItemUsecase),
        updateItemUsecaseProvider.overrideWithValue(mockUpdateItemUsecase),
        deleteItemUsecaseProvider.overrideWithValue(mockDeleteItemUsecase),
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhotoUsecase),
        uploadVideoUsecaseProvider.overrideWithValue(mockUploadVideoUsecase),
        searchItemsUsecaseProvider.overrideWithValue(mockSearchItemsUsecase),
        getItemsByCategoryUsecaseProvider.overrideWithValue(mockGetItemsByCategoryUsecase),
        getRelatedItemsUsecaseProvider.overrideWithValue(mockGetRelatedItemsUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('1) initial state is ItemState.initial', () {
    final state = container.read(itemViewModelProvider);
    expect(state.status, ItemStatus.initial);
    expect(state.items, isEmpty);
    expect(state.selectedItem, isNull);
  });

  test('2) getAllItems success sets loaded items', () async {
    final items = <ItemEntity>[sampleItem()];
    when(() => mockGetAllItemsUsecase()).thenAnswer((_) async => Right(items));

    await container.read(itemViewModelProvider.notifier).getAllItems();
    final state = container.read(itemViewModelProvider);

    expect(state.status, ItemStatus.loaded);
    expect(state.items, items);
  });

  test('3) getAllItems failure sets error state', () async {
    when(() => mockGetAllItemsUsecase()).thenAnswer(
      (_) async => const Left(ApiFailure(message: 'Fetch failed')),
    );

    await container.read(itemViewModelProvider.notifier).getAllItems();
    final state = container.read(itemViewModelProvider);

    expect(state.status, ItemStatus.error);
    expect(state.errorMessage, 'Fetch failed');
  });

  test('4) getItemById success sets selected item', () async {
    final item = sampleItem(id: 'detail-1');
    when(() => mockGetItemByIdUsecase(any())).thenAnswer((_) async => Right(item));

    await container.read(itemViewModelProvider.notifier).getItemById('detail-1');
    final state = container.read(itemViewModelProvider);

    expect(state.status, ItemStatus.loaded);
    expect(state.selectedItem, item);
  });

  test('5) getItemById failure sets error state', () async {
    when(() => mockGetItemByIdUsecase(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: 'Not found')),
    );

    await container.read(itemViewModelProvider.notifier).getItemById('missing');
    final state = container.read(itemViewModelProvider);

    expect(state.status, ItemStatus.error);
    expect(state.errorMessage, 'Not found');
  });

  test('6) getItemsByUser success sets items', () async {
    final items = <ItemEntity>[sampleItem(id: 'seller-item')];
    when(() => mockGetItemsBySellerUsecase(any())).thenAnswer((_) async => Right(items));

    await container.read(itemViewModelProvider.notifier).getItemsByUser('seller-1');
    final state = container.read(itemViewModelProvider);

    expect(state.status, ItemStatus.loaded);
    expect(state.items, items);
  });

  test('7) getItemsByUser failure sets error', () async {
    when(() => mockGetItemsBySellerUsecase(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: 'Seller fetch failed')),
    );

    await container.read(itemViewModelProvider.notifier).getItemsByUser('seller-1');
    final state = container.read(itemViewModelProvider);

    expect(state.status, ItemStatus.error);
    expect(state.errorMessage, 'Seller fetch failed');
  });

  test('8) createItem failure sets error state', () async {
    when(() => mockCreateItemUsecase(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: 'Create failed')),
    );

    await container.read(itemViewModelProvider.notifier).createItem(
      sellerId: 'seller-1',
      photos: const <String>[],
      category: 'Apple',
      phoneModel: 'iPhone 13',
      year: 2022,
      finalPrice: '50000',
      basePrice: '60000',
      batteryHealth: 90,
      description: 'desc',
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

    final state = container.read(itemViewModelProvider);
    expect(state.status, ItemStatus.error);
    expect(state.errorMessage, 'Create failed');
  });

  test('9) createItem success calls create + getAll', () async {
    await container.read(itemViewModelProvider.notifier).createItem(
      sellerId: 'seller-1',
      photos: const <String>[],
      category: 'Apple',
      phoneModel: 'iPhone 13',
      year: 2022,
      finalPrice: '50000',
      basePrice: '60000',
      batteryHealth: 90,
      description: 'desc',
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

    verify(() => mockCreateItemUsecase(any())).called(1);
    verify(() => mockGetAllItemsUsecase()).called(1);
  });

  test('10) updateItem failure sets error state', () async {
    when(() => mockUpdateItemUsecase(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: 'Update failed')),
    );

    await container.read(itemViewModelProvider.notifier).updateItem(
      itemId: 'item-1',
      sellerId: 'seller-1',
      photos: const <String>[],
      category: 'Apple',
      phoneModel: 'iPhone 13',
      year: 2022,
      finalPrice: '50000',
      basePrice: '60000',
      batteryHealth: 90,
      description: 'desc',
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

    final state = container.read(itemViewModelProvider);
    expect(state.status, ItemStatus.error);
    expect(state.errorMessage, 'Update failed');
  });

  test('11) updateItem success calls update + getAll', () async {
    await container.read(itemViewModelProvider.notifier).updateItem(
      itemId: 'item-1',
      sellerId: 'seller-1',
      photos: const <String>[],
      category: 'Apple',
      phoneModel: 'iPhone 13',
      year: 2022,
      finalPrice: '50000',
      basePrice: '60000',
      batteryHealth: 90,
      description: 'desc',
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

    verify(() => mockUpdateItemUsecase(any())).called(1);
    verify(() => mockGetAllItemsUsecase()).called(1);
  });

  test('12) deleteItem failure sets error state', () async {
    when(() => mockDeleteItemUsecase(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: 'Delete failed')),
    );

    await container.read(itemViewModelProvider.notifier).deleteItem('item-1');
    final state = container.read(itemViewModelProvider);

    expect(state.status, ItemStatus.error);
    expect(state.errorMessage, 'Delete failed');
  });

  test('13) uploadPhoto success updates uploadedPhotoUrl', () async {
    final url = await container.read(itemViewModelProvider.notifier).uploadPhoto(
          File('photo.png'),
        );
    final state = container.read(itemViewModelProvider);

    expect(url, 'photo-url');
    expect(state.status, ItemStatus.loaded);
    expect(state.uploadedPhotoUrl, 'photo-url');
  });

  test('14) uploadPhoto failure returns null and sets error', () async {
    when(() => mockUploadPhotoUsecase(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: 'Upload photo failed')),
    );

    final url = await container.read(itemViewModelProvider.notifier).uploadPhoto(
          File('photo.png'),
        );
    final state = container.read(itemViewModelProvider);

    expect(url, isNull);
    expect(state.status, ItemStatus.error);
    expect(state.errorMessage, 'Upload photo failed');
  });

  test('15) clearReportState resets status, errors and uploaded urls', () {
    container.read(itemViewModelProvider.notifier).state = const ItemState(
      status: ItemStatus.error,
      errorMessage: 'err',
      uploadedPhotoUrl: 'photo-url',
      uploadedVideoUrl: 'video-url',
    );

    container.read(itemViewModelProvider.notifier).clearReportState();
    final state = container.read(itemViewModelProvider);

    expect(state.status, ItemStatus.initial);
    expect(state.errorMessage, isNull);
    expect(state.uploadedPhotoUrl, isNull);
    expect(state.uploadedVideoUrl, isNull);
  });
}
