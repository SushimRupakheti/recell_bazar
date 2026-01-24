import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';

abstract interface class IItemRepository {

  // Browsing

  Future<Either<Failure, List<ItemEntity>>> getAllItems();

  Future<Either<Failure, ItemEntity>> getItemById(String itemId);

  Future<Either<Failure, List<ItemEntity>>> getItemsByCategory(
    String categoryId,
  );

  // Model-based search ONLY
  Future<Either<Failure, List<ItemEntity>>> searchItems(
    String model,
    String? categoryId,
  );

  Future<Either<Failure, List<ItemEntity>>> getRelatedItems(
    String itemId,
  );

  // Seller

  Future<Either<Failure, bool>> createItem(ItemEntity item);

  Future<Either<Failure, bool>> updateItem(ItemEntity item);

  Future<Either<Failure, bool>> deleteItem(String itemId);

  Future<Either<Failure, List<ItemEntity>>> getItemsBySeller(
    String sellerId,
  );

  Future<Either<Failure, bool>> markItemAsSold(
    String itemId,
  );


  // Cart

  Future<Either<Failure, bool>> addToCart(String itemId);

  Future<Either<Failure, bool>> removeFromCart(String itemId);

  Future<Either<Failure, List<ItemEntity>>> getCartItems();

  Future<Either<Failure, bool>> clearCart();

// Media

  Future<Either<Failure, String>> uploadPhoto(File photo);

  Future<Either<Failure, String>> uploadVideo(File video);
}
