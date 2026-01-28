import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser(String authId);
  Future<Either<Failure, bool>> logout();
Future<Either<Failure, AuthEntity>> updateProfilePicture({
  required String authId,
  required File imageFile,
});


}
