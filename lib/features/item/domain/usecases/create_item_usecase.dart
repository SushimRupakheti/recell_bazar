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

  // TextFields
  final int year;
  final int batteryHealth;
  final String description;

  //price
  final String finalPrice;
  final String basePrice;

  // Radio Button
  final String deviceCondition;

  // Charger Available
  final bool chargerAvailable;

  // Boolean Evaluation Questions
  final bool factoryUnlock;
  final bool liquidDamage;
  final bool switchOn;
  final bool receiveCall;
  final bool features1Condition;
  final bool features2Condition;
  final bool cameraCondition;
  final bool displayCondition;
  final bool displayCracked;
  final bool displayOriginal;

  const CreateItemParams({
    required this.sellerId,
    required this.photos,
    required this.category,
    required this.model,
    required this.year,
    required this.finalPrice,
    required this.basePrice,
    required this.batteryHealth,
    required this.description,
    required this.deviceCondition,
    required this.chargerAvailable,
    required this.factoryUnlock,
    required this.liquidDamage,
    required this.switchOn,
    required this.receiveCall,
    required this.features1Condition,
    required this.features2Condition,
    required this.cameraCondition,
    required this.displayCondition,
    required this.displayCracked,
    required this.displayOriginal,
  });

  @override
  List<Object?> get props => [
        sellerId,
        photos,
        category,
        model,
        year,
        finalPrice,
        basePrice,
        batteryHealth,
        description,
        deviceCondition,
        chargerAvailable,
        factoryUnlock,
        liquidDamage,
        switchOn,
        receiveCall,
        features1Condition,
        features2Condition,
        cameraCondition,
        displayCondition,
        displayCracked,
        displayOriginal,
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

      year: params.year,

      finalPrice: params.finalPrice,
      basePrice: params.basePrice,
      
      batteryHealth: params.batteryHealth,
      description: params.description,

      deviceCondition: params.deviceCondition,

      chargerAvailable: params.chargerAvailable,

      factoryUnlock: params.factoryUnlock,
      liquidDamage: params.liquidDamage,
      switchOn: params.switchOn,
      receiveCall: params.receiveCall,
      features1Condition: params.features1Condition,
      features2Condition: params.features2Condition,
      cameraCondition: params.cameraCondition,
      displayCondition: params.displayCondition,
      displayCracked: params.displayCracked,
      displayOriginal: params.displayOriginal,
    );

    return _itemRepository.createItem(itemEntity);
  }
}
