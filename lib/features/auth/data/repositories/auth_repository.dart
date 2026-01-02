import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/auth/data/datasources/auth_datasource.dart';
import 'package:recell_bazar/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/repositories/auth_repository.dart';


// Create provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  return AuthRepository(authDatasource: authDatasource);
});

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;

  AuthRepository({required IAuthDataSource authDatasource})
    : _authDataSource = authDatasource;

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    try {
      // Normalize email (trim + lowercase) to avoid duplicates caused by case/spacing
      final normalizedEmail = user.email.trim().toLowerCase();

      if (normalizedEmail.isEmpty) {
        return const Left(
          LocalDatabaseFailure(message: "Email is required"),
        );
      }

      // Check if email already exists
      final existingUser = await _authDataSource.getUserByEmail(normalizedEmail);
      if (existingUser != null) {
        return const Left(
          LocalDatabaseFailure(message: "Email already registered"),
        );
      }

      // Create a normalized AuthEntity to store
      final normalizedUser = AuthEntity(
        authId: user.authId,
        firstName: user.firstName.trim(),
        lastName: user.lastName.trim(),
        email: normalizedEmail,
        phoneNumber: user.phoneNumber?.trim(),
        address: user.address.trim(),
        password: user.password?.trim(),
      );

      final authModel = AuthHiveModel.fromEntity(normalizedUser);
      final result = await _authDataSource.register(authModel);

      if (result) {
        return const Right(true);
      }

      return Left(LocalDatabaseFailure(message: "Failed to register user"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedPassword = password.trim();

      if (normalizedEmail.isEmpty || normalizedPassword.isEmpty) {
        return const Left(
          LocalDatabaseFailure(message: "Email and password are required"),
        );
      }

      final model = await _authDataSource.login(normalizedEmail, normalizedPassword);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(
        LocalDatabaseFailure(message: "Invalid email or password"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser(String authId) async {
    try {
      final model = await _authDataSource.getCurrentUser(authId);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
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
}
