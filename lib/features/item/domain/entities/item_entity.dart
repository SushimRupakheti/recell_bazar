import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String? itemId;
  final String sellerId;

  // Mandatory fields
  final List<String> photos;

  // Basic phone info
  final String category;
  final String phoneModel;

  //PRICE
  final String finalPrice;
  final String basePrice;

  // TextFields
  final int year;
  final int batteryHealth;
  final String description;

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

  // Extra Info
  final bool isSold;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ItemEntity({
    this.itemId,
    required this.sellerId,
    required this.photos,

    required this.category,
    required this.phoneModel,

    required this.finalPrice,
    required this.basePrice,

    required this.year,
    required this.batteryHealth,
    required this.description,

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

    this.createdAt,
    this.updatedAt,
    this.isSold = false,
  });


  ItemEntity copyWith({
    String? itemId,
    String? sellerId,
    List<String>? photos,

    String? category,
    String? phoneModel,

    int? year,
    int? batteryHealth,
    String? description,

    String? finalPrice,
    String? basePrice,

    // deviceCondition removed

    bool? chargerAvailable,

    bool? factoryUnlock,
    bool? liquidDamage,
    bool? switchOn,
    bool? receiveCall,
    bool? features1Condition,
    bool? features2Condition,
    bool? cameraCondition,
    bool? displayCondition,
    bool? displayCracked,
    bool? displayOriginal,

    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSold,
  }) {
    return ItemEntity(
      itemId: itemId ?? this.itemId,
      sellerId: sellerId ?? this.sellerId,
      photos: photos ?? this.photos,

      category: category ?? this.category,
      phoneModel: phoneModel ?? this.phoneModel,

      finalPrice: finalPrice ?? this.finalPrice,
      basePrice: basePrice ?? this.basePrice,

      year: year ?? this.year,
      batteryHealth: batteryHealth ?? this.batteryHealth,
      description: description ?? this.description,

      // deviceCondition removed

      chargerAvailable: chargerAvailable ?? this.chargerAvailable,

      factoryUnlock: factoryUnlock ?? this.factoryUnlock,
      liquidDamage: liquidDamage ?? this.liquidDamage,
      switchOn: switchOn ?? this.switchOn,
      receiveCall: receiveCall ?? this.receiveCall,
      features1Condition: features1Condition ?? this.features1Condition,
      features2Condition: features2Condition ?? this.features2Condition,
      cameraCondition: cameraCondition ?? this.cameraCondition,
      displayCondition: displayCondition ?? this.displayCondition,
      displayCracked: displayCracked ?? this.displayCracked,
      displayOriginal: displayOriginal ?? this.displayOriginal,

      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSold: isSold ?? this.isSold,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        sellerId,
        photos,

        category,
        phoneModel,

        finalPrice,
        basePrice,

        year,
        batteryHealth,
        description,

        // deviceCondition removed

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

        createdAt,
        updatedAt,
        isSold,
      ];
}
