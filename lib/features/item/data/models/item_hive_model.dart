import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'item_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.iteTypeId)
class ItemHiveModel extends HiveObject {

  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String sellerId;

  @HiveField(2)
  final List<String> photos;

  @HiveField(3)
  final String category; // smartphone

  @HiveField(4)
  final String model;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final int year;

  @HiveField(7)
  final String description;

  @HiveField(8)
  final String storage;

  @HiveField(9)
  final String screenCondition;

  @HiveField(10)
  final int batteryHealth;

  @HiveField(11)
  final String cameraQuality;

  @HiveField(12)
  final bool hasCharger;

  @HiveField(13)
  final Map<String, dynamic>? extraAnswers;


  ItemHiveModel({
    String? itemId,
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
  }) : itemId = itemId ?? Uuid().v4();

  ItemEntity toEntity() {
    return ItemEntity(
      itemId: itemId,
      sellerId: sellerId,
      photos: photos,
      category: category,
      model: model,
      price: price,
      year: year,
      description: description,
      storage: storage,
      screenCondition: screenCondition,
      batteryHealth: batteryHealth,
      cameraQuality: cameraQuality,
      hasCharger: hasCharger,
      extraAnswers: extraAnswers,
    );
  }

  factory ItemHiveModel.fromEntity(ItemEntity entity) {
    return ItemHiveModel(
      itemId: entity.itemId,
      sellerId: entity.sellerId,
      photos: entity.photos,
      category: entity.category,
      model: entity.model,
      price: entity.price,
      year: entity.year,
      description: entity.description,
      storage: entity.storage,
      screenCondition: entity.screenCondition,
      batteryHealth: entity.batteryHealth,
      cameraQuality: entity.cameraQuality,
      hasCharger: entity.hasCharger,
      extraAnswers: entity.extraAnswers,
    );
  }

  static List<ItemEntity> toEntityList(List<ItemHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
