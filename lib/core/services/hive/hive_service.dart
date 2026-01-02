import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recell_bazar/core/constants/hive_table_constant.dart';
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';


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
    await _authBox.put(user.authId, user);
    return user;
  }

  /// Login user (email + password)
  AuthHiveModel? login(String email, String password) {
    try {
      return _authBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
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
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
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
    return _authBox.values.any((user) => user.email == email);
  }
}
