import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

class UpdateItemParams extends Equatable {
  final String itemId;

  // Mandatory fields
  final List<String>? photos;
  final String? category;
  final String? model;
  final double? price;
  final String? sellerId;
  final int? year;
  final String? description;
  final String? storage;
  final String? screenCondition;
  final int? batteryHealth;
  final String? cameraQuality;
  final bool? hasCharger;

  // Extra dynamic questions
  final Map<String, dynamic>? extraAnswers;

  const UpdateItemParams({
    required this.itemId,
    this.photos,
    this.category,
    this.model,
    this.price,
    this.year,
    this.description,
    this.storage,
    this.screenCondition,
    this.batteryHealth,
    this.cameraQuality,
    this.hasCharger,
    this.extraAnswers, 
    this.sellerId,
  });

  @override
  List<Object?> get props => [
        itemId,
        photos,
        category,
        model,
        price,
        year,
        description,
        storage,
        sellerId,
        screenCondition,
        batteryHealth,
        cameraQuality,
        hasCharger,
        extraAnswers,
      ];
}

final updateItemUsecaseProvider = Provider<UpdateItemUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UpdateItemUsecase(itemRepository: itemRepository);
});

class UpdateItemUsecase implements UsecaseWithParams<bool, UpdateItemParams> {
  final IItemRepository _itemRepository;

  UpdateItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateItemParams params) {
    final itemEntity = ItemEntity(
      itemId: params.itemId,
      photos: params.photos ?? [],
      category: params.category ?? '',
      model: params.model ?? '',
      price: params.price ?? 0,
      year: params.year ?? 0,
      description: params.description ?? '',
      storage: params.storage ?? '',
      screenCondition: params.screenCondition ?? '',
      batteryHealth: params.batteryHealth ?? 0,
      cameraQuality: params.cameraQuality ?? '',
      hasCharger: params.hasCharger ?? false,
      extraAnswers: params.extraAnswers,
      sellerId: '',
    );

    return _itemRepository.updateItem(itemEntity);
  }
}