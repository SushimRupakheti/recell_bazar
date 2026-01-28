import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/auth/data/repositories/auth_repository.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/repositories/auth_repository.dart';

/// Parameters for updating profile picture
class UpdateProfilePictureUsecaseParams {
  final String authId;
  final File imageFile;

  const UpdateProfilePictureUsecaseParams({
    required this.authId,
    required this.imageFile,
  });
}

/// Riverpod provider for the usecase
final updateProfilePictureUsecaseProvider =
    Provider<UpdateProfilePictureUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UpdateProfilePictureUsecase(authRepository: authRepository);
});

/// Usecase class
class UpdateProfilePictureUsecase
    implements UsecaseWithParams<AuthEntity, UpdateProfilePictureUsecaseParams> {
  final IAuthRepository _authRepository;

  UpdateProfilePictureUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

@override
Future<Either<Failure, AuthEntity>> call(
    UpdateProfilePictureUsecaseParams params) {
  // Just pass params to repository, no need to create a temporary AuthEntity
  return _authRepository.updateProfilePicture(
    authId: params.authId,
    imageFile: params.imageFile,
  );
}

}
