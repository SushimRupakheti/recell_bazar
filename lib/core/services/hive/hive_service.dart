import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recell_bazar/core/constants/hive_table_constant.dart';
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';
import 'package:recell_bazar/features/item/data/models/item_hive_model.dart';
import 'package:uuid/uuid.dart';


final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  /// Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init('${directory.path}/${HiveTableConstant.dbName}');
    _registerAdapters();
    await _openBoxes();
    await _cleanupEmptyEmailUsers();
  }

  /// Register all Hive adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  /// Open all required boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<ItemHiveModel>(HiveTableConstant.itemTable);

  }

  /// Perform a one-time cleanup for empty-email users (debug builds only)
  Future<void> _cleanupEmptyEmailUsers() async {
    final emptyKeys = _authBox.keys.where((k) {
      final user = _authBox.get(k);
      return user != null && user.email.trim().isEmpty;
    }).toList();

    if (emptyKeys.isNotEmpty) {
      debugPrint('HiveService.init: found empty-email user keys=$emptyKeys');
      if (kDebugMode) {
        for (final key in emptyKeys) {
          await _authBox.delete(key);
          debugPrint('HiveService.init: deleted empty-email user key=$key');
        }
      }
    }
  }
  /// Close all Hive boxes
  Future<void> close() async {
    await Hive.close();
  }

  /// Internal getter for user box
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.userTable);

  /// Register user
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    final id = user.authId ?? Uuid().v4();
    debugPrint('HiveService.register: id=$id email=${user.email}');
    await _authBox.put(id, user);
    debugPrint('HiveService.register: boxSize=${_authBox.length}, keys=${_authBox.keys.toList()}');
    return user;
  }

  /// Login user (email + password)
  AuthHiveModel? login(String email, String password) {
    final lookupEmail = email.trim().toLowerCase();
    final lookupPassword = password.trim();

    if (lookupEmail.isEmpty || lookupPassword.isEmpty) {
      debugPrint('HiveService.login: empty email or password provided - email="$lookupEmail"');
      return null;
    }

    try {
      final matched = _authBox.values.firstWhere(
        (user) =>
            user.email.trim().toLowerCase() == lookupEmail &&
            (user.password ?? "") == lookupPassword,
      );
      debugPrint('HiveService.login: success email=$lookupEmail');
      return matched;
    } catch (e) {
      debugPrint('HiveService.login: failed for email=$lookupEmail: $e');
      return null;
    }
  }

  /// Logout (placeholder)
  Future<void> logout() async {}

  /// Get current user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  /// Get user by ID
  AuthHiveModel? getUserById(String authId) {
    return _authBox.get(authId);
  }

  /// Get user by email
  AuthHiveModel? getUserByEmail(String email) {
    final lookupEmail = email.trim().toLowerCase();

    if (lookupEmail.isEmpty) {
      debugPrint('HiveService.getUserByEmail: empty lookup, returning null');
      return null;
    }

    try {
      final matched = _authBox.values.firstWhere(
        (user) => user.email.trim().toLowerCase() == lookupEmail,
      );
      debugPrint('HiveService.getUserByEmail: found email=$lookupEmail');
      return matched;
    } catch (e) {
      debugPrint('HiveService.getUserByEmail: not found email=$lookupEmail');
      return null;
    }
  }

  /// Update user
  Future<bool> updateUser(AuthHiveModel user) async {
    if (_authBox.containsKey(user.authId)) {
      await _authBox.put(user.authId, user);
      return true;
    }
    return false;
  }

  /// Delete user
  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);
  }

  /// Check if email already exists
  bool doesEmailExist(String email) {
    final lookupEmail = email.trim().toLowerCase();
    if (lookupEmail.isEmpty) {
      debugPrint('HiveService.doesEmailExist: empty lookup, returning false');
      return false;
    }
    final exists = _authBox.values.any((user) => user.email.trim().toLowerCase() == lookupEmail);
    debugPrint('HiveService.doesEmailExist: email=$lookupEmail exists=$exists');
    return exists;
  }

/// Open boxes in _openBoxes


/// Internal getter for item box
Box<ItemHiveModel> get _itemBox =>
    Hive.box<ItemHiveModel>(HiveTableConstant.itemTable);

Future<void> createItem(ItemHiveModel item) async {
  await _itemBox.put(item.itemId, item);
}

/// Get an item by ID
Future<ItemHiveModel?> getItemById(String itemId) async {
  return _itemBox.get(itemId);
}

/// Update an item
Future<void> updateItem(ItemHiveModel item) async {
  await _itemBox.put(item.itemId, item);
}

/// Delete an item
Future<void> deleteItem(String itemId) async {
  await _itemBox.delete(itemId);
}

/// Get all items
Future<List<ItemHiveModel>> getAllItems() async {
  return _itemBox.values.toList();
}

/// Get items by user
Future<List<ItemHiveModel>> getItemsByUser(String userId) async {
  return _itemBox.values.where((item) => item.sellerId == userId).toList();
}

/// Get items by category
Future<List<ItemHiveModel>> getItemsByCategory(String categoryId) async {
  return _itemBox.values.where((item) => item.category == categoryId).toList();
}

/// Get lost items (example: based on status)
Future<List<ItemHiveModel>> getLostItems() async {
  return _itemBox.values.where((item) => item.extraAnswers?['status'] == 'lost').toList();
}

/// Get found items
Future<List<ItemHiveModel>> getFoundItems() async {
  return _itemBox.values.where((item) => item.extraAnswers?['status'] == 'found').toList();
}
}