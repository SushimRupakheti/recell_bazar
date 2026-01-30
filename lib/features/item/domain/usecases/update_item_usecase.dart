import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';

import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/repositories/item_repository.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';

/// ✅ Update Item Params
class UpdateItemParams extends Equatable {
  final String itemId;

  // Basic Fields
  final List<String>? photos;
  final String? category;
  final String? model;

  // TextField Inputs
  final int? year;
  final int? batteryHealth;
  final String? description;

  // Radio Button Input
  final String? deviceCondition;

  // Charger
  final bool? chargerAvailable;

  // Boolean Evaluation Questions
  final bool? factoryUnlock;
  final bool? liquidDamage;
  final bool? switchOn;
  final bool? receiveCall;
  final bool? features1Condition;
  final bool? features2Condition;
  final bool? cameraCondition;
  final bool? displayCondition;
  final bool? displayCracked;
  final bool? displayOriginal;

  const UpdateItemParams({
    required this.itemId,
    this.photos,
    this.category,
    this.model,
    this.year,
    this.batteryHealth,
    this.description,
    this.deviceCondition,
    this.chargerAvailable,
    this.factoryUnlock,
    this.liquidDamage,
    this.switchOn,
    this.receiveCall,
    this.features1Condition,
    this.features2Condition,
    this.cameraCondition,
    this.displayCondition,
    this.displayCracked,
    this.displayOriginal,
  });

  @override
  List<Object?> get props => [
        itemId,
        photos,
        category,
        model,
        year,
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

/// ✅ Provider for UpdateItemUsecase
final updateItemUsecaseProvider = Provider<UpdateItemUsecase>((ref) {
  final itemRepository = ref.read(itemRepositoryProvider);
  return UpdateItemUsecase(itemRepository: itemRepository);
});

/// ✅ Update Item Usecase
class UpdateItemUsecase implements UsecaseWithParams<bool, UpdateItemParams> {
  final IItemRepository _itemRepository;

  UpdateItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateItemParams params) {
    final itemEntity = ItemEntity(
      itemId: params.itemId,

      // sellerId is not updated here, so keep empty for now
      sellerId: "",

      // Basic Fields
      photos: params.photos ?? [],
      category: params.category ?? "",
      model: params.model ?? "",

      // TextField Inputs
      year: params.year ?? 0,
      batteryHealth: params.batteryHealth ?? 0,
      description: params.description ?? "",

      // Radio Button
      deviceCondition: params.deviceCondition ?? "",

      // Charger
      chargerAvailable: params.chargerAvailable ?? false,

      // Boolean Evaluation Questions
      factoryUnlock: params.factoryUnlock ?? false,
      liquidDamage: params.liquidDamage ?? false,
      switchOn: params.switchOn ?? false,
      receiveCall: params.receiveCall ?? false,
      features1Condition: params.features1Condition ?? false,
      features2Condition: params.features2Condition ?? false,
      cameraCondition: params.cameraCondition ?? false,
      displayCondition: params.displayCondition ?? false,
      displayCracked: params.displayCracked ?? false,
      displayOriginal: params.displayOriginal ?? false,
    );

    return _itemRepository.updateItem(itemEntity);
  }
}
