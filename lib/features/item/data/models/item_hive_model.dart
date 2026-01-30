import 'package:hive/hive.dart';
import 'package:recell_bazar/core/constants/hive_table_constant.dart';
import 'package:uuid/uuid.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';

part 'item_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.itemTypeId)
class ItemHiveModel extends HiveObject {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String sellerId;

  @HiveField(2)
  final String seller; // optional, from API if needed

  @HiveField(3)
  final List<String> photos;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String model;

  @HiveField(6)
  final int year;

  @HiveField(7)
  final int batteryHealth;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final String deviceCondition;

  @HiveField(10)
  final bool chargerAvailable;

  // Boolean evaluation fields
  @HiveField(11)
  final bool factoryUnlock;
  @HiveField(12)
  final bool liquidDamage;
  @HiveField(13)
  final bool switchOn;
  @HiveField(14)
  final bool receiveCall;
  @HiveField(15)
  final bool features1Condition;
  @HiveField(16)
  final bool features2Condition;
  @HiveField(17)
  final bool cameraCondition;
  @HiveField(18)
  final bool displayCondition;
  @HiveField(19)
  final bool displayCracked;
  @HiveField(20)
  final bool displayOriginal;

  @HiveField(21)
  final DateTime? createdAt;

  @HiveField(22)
  final DateTime? updatedAt;

  @HiveField(23)
  final bool isSold;

  ItemHiveModel({
    String? itemId,
    required this.sellerId,
    this.seller = '',
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
    this.createdAt,
    this.updatedAt,
    this.isSold = false,
  }) : itemId = itemId ?? const Uuid().v4();

  ItemHiveModel copyWith({
    String? itemId,
    String? sellerId,
    String? seller,
    List<String>? photos,
    String? category,
    String? model,
    int? year,
    int? batteryHealth,
    String? description,
    String? deviceCondition,
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
    return ItemHiveModel(
      itemId: itemId ?? this.itemId,
      sellerId: sellerId ?? this.sellerId,
      seller: seller ?? this.seller,
      photos: photos ?? this.photos,
      category: category ?? this.category,
      model: model ?? this.model,
      year: year ?? this.year,
      batteryHealth: batteryHealth ?? this.batteryHealth,
      description: description ?? this.description,
      deviceCondition: deviceCondition ?? this.deviceCondition,
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

  // Convert Hive model to Entity
  ItemEntity toEntity() {
    return ItemEntity(
      itemId: itemId,
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
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSold: isSold,
    );
  }

  // Convert Entity to Hive model
  factory ItemHiveModel.fromEntity(ItemEntity entity) {
    return ItemHiveModel(
      itemId: entity.itemId,
      sellerId: entity.sellerId,
      seller: '',
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
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSold: entity.isSold,
    );
  }

  // Convert list of Hive models to Entity list
  static List<ItemEntity> toEntityList(List<ItemHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
