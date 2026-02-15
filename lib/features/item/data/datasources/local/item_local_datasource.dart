import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/services/hive/hive_service.dart';
import 'package:recell_bazar/features/item/data/datasources/item_datasource.dart';
import 'package:recell_bazar/features/item/data/models/item_hive_model.dart';

final itemLocalDatasourceProvider = Provider<IItemLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ItemLocalDatasource(hiveService: hiveService);
});

class ItemLocalDatasource implements IItemLocalDataSource {
  final HiveService _hiveService;

  ItemLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<bool> createItem(ItemHiveModel item) async {
    try {
      await _hiveService.createItem(item);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    try {
      await _hiveService.deleteItem(itemId);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<ItemHiveModel>> getAllItems() async {
    try {
      return _hiveService.getAllItems();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<ItemHiveModel?> getItemById(String itemId) async {
    try {
      return _hiveService.getItemById(itemId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ItemHiveModel>> getItemsByUser(String userId) async {
    try {
      return _hiveService.getItemsByUser(userId);
    } catch (_) {
      return [];
    }
  }


  @override
  Future<List<ItemHiveModel>> getItemsByCategory(String categoryId) async {
    try {
      return _hiveService.getItemsByCategory(categoryId);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> updateItem(ItemHiveModel item) async {
    try {
      await _hiveService.updateItem(item);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Mark an item as sold locally
  @override
  Future<bool> markItemAsSold(String itemId) async {
    try {
      final item = await _hiveService.getItemById(itemId);
      if (item == null) return false;

      final updatedItem = item.copyWith(isSold: true); // requires copyWith in HiveModel
      await _hiveService.updateItem(updatedItem);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// TODO: Implement cart-related functions
  @override
  Future<bool> addToCart(String itemId) async {
    // implement cart logic here
    throw UnimplementedError();
  }

  @override
  Future<bool> removeFromCart(String itemId) async {
    // implement cart logic here
    throw UnimplementedError();
  }

  @override
  Future<bool> clearCart() async {
    // implement cart logic here
    throw UnimplementedError();
  }

  @override
  Future<List<ItemHiveModel>> getCartItems() async {
    // implement cart logic here
    throw UnimplementedError();
  }

  /// TODO: Implement search and related items functions
  @override
  Future<List<ItemHiveModel>> searchItems(String phoneModel, {String? categoryId}) async {
    // implement search logic here
    throw UnimplementedError();
  }

  @override
  Future<List<ItemHiveModel>> getRelatedItems(String itemId) async {
    // implement related items logic here
    throw UnimplementedError();
  }
}
