
import 'dart:io';

import 'package:recell_bazar/features/auth/data/models/auth_api_model.dart';
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDataSource {
  Future<bool> register(AuthHiveModel user);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser(String authId);
  Future<bool> logout();
  Future<bool> doesEmailExist(String email);
  Future<bool> uploadProfilePicture(String authId, String imagePath);
  

  Future<AuthHiveModel?> getUserById(String authId);
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<bool> updateUser(AuthHiveModel user);
  Future<bool> deleteUser(String authId);
}


abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getUserById(String authId);
  Future<AuthApiModel?> uploadProfilePicture(String authId, File imageFile);
  Future<AuthApiModel?> updateUser(String authId, Map<String, dynamic> data);
  
  // Future<AuthHiveModel?> getCurrentUser();
  // Future<bool> logout();
  // Future<bool> doesEmailExist(String email);
  // Future<bool> updateUser(AuthHiveModel user);
  // Future<bool> deleteUser(String authId);
}