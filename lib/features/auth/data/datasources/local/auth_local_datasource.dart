import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/services/hive/hive_service.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/data/datasources/auth_datasource.dart';
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';


final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  
  return AuthLocalDatasource(hiveService: hiveService, userSessionServices: userSessionService);
});

class AuthLocalDatasource implements IAuthLocalDataSource {
  final HiveService _hiveService;
  final UserSessionServices _userSessionServices;


  AuthLocalDatasource({required HiveService hiveService,required UserSessionServices userSessionServices})
    : _hiveService = hiveService,
    _userSessionServices= userSessionServices;

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
      if(user != null){
        await _userSessionServices.saveUserSession(userId: user.authId!, email: user.email, firstName: user.firstName, lastName: user.lastName);
      }
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
