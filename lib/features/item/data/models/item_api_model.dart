import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';

class ItemApiModel {
  final String? id;
  final String sellerId;

  final List<String> photos;

  final String category;
  final String model;

  final String finalPrice;
  final String basePrice;

  final int year;
  final int batteryHealth;
  final String description;

  final String deviceCondition;

  final bool chargerAvailable;

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

  ItemApiModel({
    this.id,
    required this.sellerId,
    required this.photos,
    required this.category,
    required this.model,
    required this.year,
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
    required this.finalPrice,
    required this.basePrice,
  });

  Map<String, dynamic> toJson() {
    return {
      "photos": photos,
      "category": category,
      "model": model,
      "year": year,
      "batteryHealth": batteryHealth,
      "description": description,
      "deviceCondition": deviceCondition,
      "chargerAvailable": chargerAvailable,
      "factoryUnlock": factoryUnlock,
      "liquidDamage": liquidDamage,
      "switchOn": switchOn,
      "receiveCall": receiveCall,
      "features1Condition": features1Condition,
      "features2Condition": features2Condition,
      "cameraCondition": cameraCondition,
      "displayCondition": displayCondition,
      "displayCracked": displayCracked,
      "displayOriginal": displayOriginal,
      "sellerId": sellerId,
      "finalPrice": finalPrice,
      "basePrice": basePrice,
    };
  }

  factory ItemApiModel.fromJson(Map<String, dynamic> json) {
    return ItemApiModel(
      id: json["_id"],
      sellerId: json["sellerId"],
      photos: List<String>.from(json["photos"]),
      category: json["category"],
      model: json["model"],
      year: json["year"],
      batteryHealth: json["batteryHealth"],
      description: json["description"],
      deviceCondition: json["deviceCondition"],
      chargerAvailable: json["chargerAvailable"],
      factoryUnlock: json["factoryUnlock"],
      liquidDamage: json["liquidDamage"],
      switchOn: json["switchOn"],
      receiveCall: json["receiveCall"],
      features1Condition: json["features1Condition"],
      features2Condition: json["features2Condition"],
      cameraCondition: json["cameraCondition"],
      displayCondition: json["displayCondition"],
      displayCracked: json["displayCracked"],
      displayOriginal: json["displayOriginal"],
      finalPrice: json["finalPrice"],
      basePrice: json["basePrice"],
    );
  }

  ItemEntity toEntity() {
    return ItemEntity(
      itemId: id,
      sellerId: sellerId,
      photos: photos,
      category: category,
      model: model,
      year: year,
      batteryHealth: batteryHealth,
      description: description,
      deviceCondition: deviceCondition,
      chargerAvailable: chargerAvailable,
      factoryUnlock: factoryUnlock,
      liquidDamage: liquidDamage,
      switchOn: switchOn,
      receiveCall: receiveCall,
      features1Condition: features1Condition,
      features2Condition: features2Condition,
      cameraCondition: cameraCondition,
      displayCondition: displayCondition,
      displayCracked: displayCracked,
      displayOriginal: displayOriginal,
      finalPrice: finalPrice,
      basePrice: basePrice,
    );
  }

  factory ItemApiModel.fromEntity(ItemEntity entity) {
    return ItemApiModel(
      id: entity.itemId,
      sellerId: entity.sellerId,
      photos: entity.photos,
      category: entity.category,
      model: entity.model,
      year: entity.year,
      batteryHealth: entity.batteryHealth,
      description: entity.description,
      deviceCondition: entity.deviceCondition,
      chargerAvailable: entity.chargerAvailable,
      factoryUnlock: entity.factoryUnlock,
      liquidDamage: entity.liquidDamage,
      switchOn: entity.switchOn,
      receiveCall: entity.receiveCall,
      features1Condition: entity.features1Condition,
      features2Condition: entity.features2Condition,
      cameraCondition: entity.cameraCondition,
      displayCondition: entity.displayCondition,
      displayCracked: entity.displayCracked,
      displayOriginal: entity.displayOriginal,
      finalPrice: entity.finalPrice,
      basePrice: entity.basePrice,
    );
  }
    static List<ItemEntity> toEntityList(List<ItemApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
