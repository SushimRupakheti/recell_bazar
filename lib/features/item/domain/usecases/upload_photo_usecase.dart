import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UploadPhotoUsecase(itemRepository: itemRepository);
});

class UploadPhotoUsecase implements UsecaseWithParams<String, File> {
  final IItemRepository _itemRepository;

  UploadPhotoUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, String>> call(File photo) {
    return _itemRepository.uploadPhoto(photo);
  }
}


