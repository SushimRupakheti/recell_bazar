
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDataSource {
  Future<bool> register(AuthHiveModel user);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser(String authId);
  Future<bool> logout();
  Future<bool> doesEmailExist(String email);

  Future<AuthHiveModel?> getUserById(String authId);
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<bool> updateUser(AuthHiveModel user);
  Future<bool> deleteUser(String authId);
}
