import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/services/connectivity/network_info.dart';
import 'package:recell_bazar/features/auth/data/datasources/auth_datasource.dart';
import 'package:recell_bazar/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:recell_bazar/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:recell_bazar/features/auth/data/models/auth_api_model.dart';
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/repositories/auth_repository.dart';


// Create provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSession = ref.read(userSessionServiceProvider);

  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDatasource,
    networkInfo: networkInfo,
    userSession: userSession,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;
  final UserSessionServices _userSession;

  AuthRepository({
    required IAuthLocalDataSource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
    required UserSessionServices userSession,
  })  : _authDataSource = authDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo,
       _userSession = userSession;

   @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        //remote ma ja
        final apiModel = AuthApiModel.fromEntity(user);
        final registered = await _authRemoteDataSource.register(apiModel);

        // If remote returned a registered user, persist locally with the remote id
        try {
          final entity = registered.toEntity();
          final hiveModel = AuthHiveModel.fromEntity(entity);
          await _authDataSource.register(hiveModel);

          // Save session so app restarts keep the user logged in
          await _userSession.saveUserSession(
            userId: entity.authId ?? '',
            email: entity.email,
            firstName: entity.firstName,
            lastName: entity.lastName,
            contactNo: entity.contactNo,
            address: entity.address,
            profileImage: entity.profileImage,
          );
        } catch (_) {
          // ignore local persistence errors
        }

        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Registration failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    } else {
      try {
        // Check if email already exists
        final existingUser = await _authDataSource.getUserByEmail(user.email);
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }

        final authModel = AuthHiveModel.fromEntity(user);
        final result = await _authDataSource.register(authModel);

        if (result) {
          return const Right(true);
        }

        return Left(LocalDatabaseFailure(message: "Failed to register user"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
   Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    // ONLINE
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);

        if (apiModel == null) {
          return const Left(ApiFailure(message: "Invalid email or password"));
        }

        // Persist remote user locally so `getCurrentUser` can fall back to Hive
        try {
          final entity = apiModel.toEntity();
          final hiveModel = AuthHiveModel.fromEntity(entity);
          await _authDataSource.register(hiveModel);
        } catch (_) {
          // ignore local persistence errors
        }

        return Right(apiModel.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Login failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }

    // OFFLINE
    try {
      // Use the local datasource `login` which already saves the session
      // into SharedPreferences via `UserSessionServices`.
      final hiveModel = await _authDataSource.login(email, password);

      if (hiveModel != null) {
        return Right(hiveModel.toEntity());
      }

      return const Left(LocalDatabaseFailure(message: "Invalid credentials"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser(String authId) async {
    try {
      // Try local first
      final model = await _authDataSource.getCurrentUser(authId);
      if (model != null) {
        // If we have network, prefer the remote record to ensure fields
        // like `profileImage` are up-to-date. If remote fetch fails,
        // fall back to the local model.
        if (await _networkInfo.isConnected) {
          try {
            final apiModel = await _authRemoteDataSource.getUserById(authId);
            if (apiModel != null) {
              final entity = apiModel.toEntity();
              // Save to local hive for future fast access
              final hiveModel = AuthHiveModel.fromEntity(entity);
              await _authDataSource.updateUser(hiveModel);
              return Right(entity);
            }
          } catch (_) {
            // ignore and fall back to local
          }
        }

        final entity = model.toEntity();
        return Right(entity);
      }

      // If not found locally, and we have network, try remote and sync locally
      if (await _networkInfo.isConnected) {
        try {
          final apiModel = await _authRemoteDataSource.getUserById(authId);
          if (apiModel != null) {
            final entity = apiModel.toEntity();
            // Save to local hive for future fast access
            final hiveModel = AuthHiveModel.fromEntity(entity);
            await _authDataSource.register(hiveModel);
            return Right(entity);
          }
          // If remote didn't return a user, try to find a local user by the
          // saved email in SharedPreferences. This helps when the saved
          // `authId` came from the remote server but local Hive used a
          // different generated id (or vice-versa).
          final savedEmail = _userSession.getUserEmail();
          if (savedEmail != null) {
            final localByEmail = await _authDataSource.getUserByEmail(savedEmail);
            if (localByEmail != null) {
              return Right(localByEmail.toEntity());
            }
          }

          return const Left(LocalDatabaseFailure(message: "No user logged in"));
        } catch (e) {
          return Left(LocalDatabaseFailure(message: e.toString()));
        }
      }

      return const Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDataSource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }


@override
Future<Either<Failure, AuthEntity>> updateProfilePicture({
  required String authId,
  required File imageFile,
}) async {
  if (await _networkInfo.isConnected) {
    try {
      
      // Upload image to backend and get updated API model
      final updatedApiModel =
          await _authRemoteDataSource.uploadProfilePicture(authId, imageFile);

      // Check for null
      if (updatedApiModel == null) {
        return const Left(ApiFailure(message: "Image upload failed"));
      }

      // Convert API model to entity
      final updatedEntity = updatedApiModel.toEntity();

      // Update Hive locally
      final hiveModel = AuthHiveModel.fromEntity(updatedEntity);
      await _authDataSource.updateUser(hiveModel);

      // Return updated user
      return Right(updatedEntity);
    } on DioException catch (e) {
      // Defensive handling: backend may return HTML (e.g., 404 page) or a Map.
      String message = 'Image upload failed';
      final respData = e.response?.data;
      if (respData is Map && respData['message'] is String) {
        message = respData['message'];
      } else if (e.response?.statusMessage != null) {
        message = e.response!.statusMessage!;
      } else if (e.message != null) {
        message = e.message!;
      }

      return Left(
        ApiFailure(
          message: message,
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  } else {
    return const Left(LocalDatabaseFailure(message: "No internet connection"));
  }
}

}
