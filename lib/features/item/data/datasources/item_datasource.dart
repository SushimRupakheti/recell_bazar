import 'dart:io';

import 'package:recell_bazar/features/item/data/models/item_api_model.dart';
import 'package:recell_bazar/features/item/data/models/item_hive_model.dart';

/// LOCAL DATA SOURCE
abstract interface class IItemLocalDataSource {
  Future<List<ItemHiveModel>> getAllItems();
  Future<ItemHiveModel?> getItemById(String itemId);
  Future<List<ItemHiveModel>> getItemsByUser(String userId);
  Future<List<ItemHiveModel>> getItemsByCategory(String categoryId);
  Future<List<ItemHiveModel>> searchItems(String model, {String? categoryId});
  Future<List<ItemHiveModel>> getRelatedItems(String itemId);
  Future<bool> createItem(ItemHiveModel item);
  Future<bool> updateItem(ItemHiveModel item);
  Future<bool> deleteItem(String itemId);

  // Cart
  Future<bool> addToCart(String itemId);
  Future<bool> removeFromCart(String itemId);
  Future<List<ItemHiveModel>> getCartItems();
  Future<bool> clearCart();

  // Misc
  Future<bool> markItemAsSold(String itemId);
}

/// REMOTE DATA SOURCE
abstract interface class IItemRemoteDataSource {
  Future<String> uploadPhoto(File photo);
  Future<String> uploadVideo(File video);

  Future<ItemApiModel> createItem(ItemApiModel item);
  Future<bool> updateItem(ItemApiModel item);
  Future<bool> deleteItem(String itemId);

  Future<List<ItemApiModel>> getAllItems();
  Future<ItemApiModel> getItemById(String itemId);
  Future<List<ItemApiModel>> getItemsByUser(String userId);
  Future<List<ItemApiModel>> getItemsByCategory(String categoryId);
  Future<List<ItemApiModel>> searchItems(String model, {String? categoryId});
  Future<List<ItemApiModel>> getRelatedItems(String itemId);

  // Cart
  Future<bool> addToCart(String itemId);
  Future<bool> removeFromCart(String itemId);
  Future<List<ItemApiModel>> getCartItems();
  Future<bool> clearCart();

  // marking
  Future<bool> markItemAsSold(bool isSold, String itemId);
}
