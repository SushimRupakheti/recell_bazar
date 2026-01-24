import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';

class CreateItemParams extends Equatable {
  final String sellerId;

  // Mandatory fields
  final List<String> photos;
  final String category;
  final String model;
  final double price;
  final int year;
  final String description;
  final String storage;
  final String screenCondition;
  final int batteryHealth;
  final String cameraQuality;
  final bool hasCharger;

  // Extra dynamic questions
  final Map<String, dynamic>? extraAnswers;

  const CreateItemParams({
    required this.sellerId,
    required this.photos,
    required this.category,
    required this.model,
    required this.price,
    required this.year,
    required this.description,
    required this.storage,
    required this.screenCondition,
    required this.batteryHealth,
    required this.cameraQuality,
    required this.hasCharger,
    this.extraAnswers,
  });

  @override
  List<Object?> get props => [
        sellerId,
        photos,
        category,
        model,
        price,
        year,
        description,
        storage,
        screenCondition,
        batteryHealth,
        cameraQuality,
        hasCharger,
        extraAnswers,
      ];
}


final createItemUsecaseProvider = Provider<CreateItemUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return CreateItemUsecase(itemRepository: itemRepository);
});

class CreateItemUsecase
    implements UsecaseWithParams<bool, CreateItemParams> {
  final IItemRepository _itemRepository;

  CreateItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(CreateItemParams params) {
    final itemEntity = ItemEntity(
      sellerId: params.sellerId,
      photos: params.photos,
      category: params.category,
      model: params.model,
      price: params.price,
      year: params.year,
      description: params.description,
      storage: params.storage,
      screenCondition: params.screenCondition,
      batteryHealth: params.batteryHealth,
      cameraQuality: params.cameraQuality,
      hasCharger: params.hasCharger,
      extraAnswers: params.extraAnswers,
    );

    return _itemRepository.createItem(itemEntity);
  }
}
