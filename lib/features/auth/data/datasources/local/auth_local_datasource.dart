import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/services/hive/hive_service.dart';
import 'package:recell_bazar/features/auth/data/datasources/auth_datasource.dart';
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';


final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> register(AuthHiveModel user) async {
    try {
      await _hiveService.register(user);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = _hiveService.login(email, password);
      return Future.value(user);
    } catch (e) {
      return Future.value(null);
    }
  }


  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logout();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) async {
    try {
      return _hiveService.getUserById(authId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    try {
      return _hiveService.getUserByEmail(email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUser(AuthHiveModel user) async {
    try {
      return await _hiveService.updateUser(user);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String authId) async {
    try {
      await _hiveService.deleteUser(authId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> doesEmailExist(String email) {
    try {
      final exists = _hiveService.doesEmailExist(email);
      return Future.value(exists);
    } catch (e) {
      return Future.value(false);
    }
  }
  
  @override
  Future<AuthHiveModel?> getCurrentUser(String authID) async{
    try {
    return _hiveService.getCurrentUser(authID);
  } catch (e) {
    return null;
  }
  }
}
