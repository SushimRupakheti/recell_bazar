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
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/repositories/auth_repository.dart';


// Create provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo);
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource authDatasource,
    required IAuthRemoteDataSource authRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _authDataSource = authDatasource,
       _authRemoteDataSource = authRemoteDatasource,
       _networkInfo = networkInfo;

   @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        //remote ma ja
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDataSource.register(apiModel);
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
      final hiveModel = await _authDataSource.getUserByEmail(email);

      if (hiveModel != null && hiveModel.password == password) {
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
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Image upload failed',
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
