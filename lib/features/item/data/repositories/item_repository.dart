import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/services/connectivity/network_info.dart';
import 'package:recell_bazar/features/item/data/datasources/item_datasource.dart';
import 'package:recell_bazar/features/item/data/datasources/local/item_local_datasource.dart';
import 'package:recell_bazar/features/item/data/datasources/remote/item_remote_datasource.dart';
import 'package:recell_bazar/features/item/data/models/item_api_model.dart';
import 'package:recell_bazar/features/item/data/models/item_hive_model.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

final itemRepositoryProvider = Provider<IItemRepository>((ref) {
  final localDatasource = ref.read(itemLocalDatasourceProvider);
  final remoteDatasource = ref.read(itemRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ItemRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class ItemRepository implements IItemRepository {
  final IItemLocalDataSource _localDataSource;
  final IItemRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ItemRepository({
    required IItemLocalDataSource localDatasource,
    required IItemRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _localDataSource = localDatasource,
        _remoteDataSource = remoteDatasource,
        _networkInfo = networkInfo;

  // ---------------------- Browsing ----------------------

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllItems();
        return Right(ItemApiModel.toEntityList(models));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getAllItems();
        return Right(ItemHiveModel.toEntityList(models));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemById(String itemId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getItemById(itemId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _localDataSource.getItemById(itemId);
        if (model != null) return Right(model.toEntity());
        return const Left(LocalDatabaseFailure(message: 'Item not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByCategory(
      String categoryId) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getItemsByCategory(categoryId);
        return Right(ItemApiModel.toEntityList(models));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getItemsByCategory(categoryId);
        return Right(ItemHiveModel.toEntityList(models));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
    Future<Either<Failure, List<ItemEntity>>> searchItems(
      String phoneModel, String? categoryId) async {
    if (await _networkInfo.isConnected) {
      try {
        final allItems = await _remoteDataSource.getAllItems();
        final filtered = allItems
          .where((item) =>
            item.phoneModel.toLowerCase().contains(phoneModel.toLowerCase()) &&
            (categoryId == null ||
              item.category.toLowerCase() ==
                categoryId.toLowerCase()))
          .toList();
        return Right(ItemApiModel.toEntityList(filtered));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final allItems = await _localDataSource.getAllItems();
        final filtered = allItems
          .where((item) =>
            item.phoneModel.toLowerCase().contains(phoneModel.toLowerCase()) &&
            (categoryId == null ||
              item.category.toLowerCase() ==
                categoryId.toLowerCase()))
          .toList();
        return Right(ItemHiveModel.toEntityList(filtered));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getRelatedItems(
      String itemId) async {
    if (await _networkInfo.isConnected) {
      try {
        final item = await _remoteDataSource.getItemById(itemId);
        final allItems = await _remoteDataSource.getAllItems();
        final related = allItems
            .where((i) =>
                i.id != item.id && i.category.toLowerCase() == item.category.toLowerCase())
            .toList();
        return Right(ItemApiModel.toEntityList(related));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final item = await _localDataSource.getItemById(itemId);
        final allItems = await _localDataSource.getAllItems();
        final related = allItems
            .where((i) =>
                i.itemId != item?.itemId &&
                i.category.toLowerCase() == item?.category.toLowerCase())
            .toList();
        return Right(ItemHiveModel.toEntityList(related));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  // ---------------------- Seller ----------------------

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsBySeller(
      String sellerId) async {
    if (await _networkInfo.isConnected) {
      try {
        debugPrint('ItemRepository.getItemsBySeller: requesting remote items for sellerId=$sellerId');
        final models = await _remoteDataSource.getItemsByUser(sellerId);

        final normRequested = sellerId.trim().toLowerCase();
        final filtered = models.where((m) {
          final sid = (m.sellerId).trim().toLowerCase();
          return sid == normRequested;
        }).toList();

        debugPrint('ItemRepository.getItemsBySeller: remote fetched=${models.length}, filtered=${filtered.length}');
        return Right(ItemApiModel.toEntityList(filtered));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getAllItems();
        debugPrint('ItemRepository.getItemsBySeller (local): requested sellerId=$sellerId, localCount=${models.length}');
        final normRequested = sellerId.trim().toLowerCase();
        final filtered = models.where((m) {
          final sid = (m.sellerId ).trim().toLowerCase();
          final sellerField = (m.seller ).trim().toLowerCase();
          return sid == normRequested || sellerField == normRequested;
        }).toList();
        debugPrint('ItemRepository.getItemsBySeller (local): filtered=${filtered.length}');
        return Right(ItemHiveModel.toEntityList(filtered));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createItem(ItemEntity item) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.createItem(ItemApiModel.fromEntity(item));
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.createItem(ItemHiveModel.fromEntity(item));
        if (result) return const Right(true);
        return const Left(LocalDatabaseFailure(message: 'Failed to create item'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateItem(ItemEntity item) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.updateItem(ItemApiModel.fromEntity(item));
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.updateItem(ItemHiveModel.fromEntity(item));
        if (result) return const Right(true);
        return const Left(LocalDatabaseFailure(message: 'Failed to update item'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteItem(String itemId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteItem(itemId);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.deleteItem(itemId);
        if (result) return const Right(true);
        return const Left(LocalDatabaseFailure(message: 'Failed to delete item'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

@override
Future<Either<Failure, bool>> markItemAsSold(String itemId) async {
  if (await _networkInfo.isConnected) {
    try {
      final item = await _remoteDataSource.getItemById(itemId);
      final updated = item.toEntity().copyWith(isSold: true);
      await _remoteDataSource.updateItem(ItemApiModel.fromEntity(updated));
      return const Right(true);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  } else {
    return const Left(NetworkFailure(message: 'No internet connection'));
  }
}


  // ---------------------- Cart ----------------------

  @override
  Future<Either<Failure, bool>> addToCart(String itemId) async {
    // implement your cart logic
    return const Left(ApiFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, bool>> removeFromCart(String itemId) async {
    return const Left(ApiFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getCartItems() async {
    return const Left(ApiFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, bool>> clearCart() async {
    return const Left(ApiFailure(message: 'Not implemented'));
  }

  // ---------------------- Media ----------------------

  @override
  Future<Either<Failure, String>> uploadPhoto(File photo) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _remoteDataSource.uploadPhoto(photo);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadVideo(File video) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _remoteDataSource.uploadVideo(video);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
