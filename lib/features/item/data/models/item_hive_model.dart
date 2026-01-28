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
  final double price;

  @HiveField(7)
  final int year;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final String storage;

  @HiveField(10)
  final String screenCondition;

  @HiveField(11)
  final int batteryHealth;

  @HiveField(12)
  final String cameraQuality;

  @HiveField(13)
  final bool hasCharger;

  @HiveField(14)
  final Map<String, dynamic>? extraAnswers;

  @HiveField(15)
  final DateTime? createdAt;

  @HiveField(16)
  final DateTime? updatedAt;

  @HiveField(17)
  final bool isSold;

  ItemHiveModel({
    String? itemId,
    required this.sellerId,
    this.seller = '',
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
    required this.isSold,
    this.createdAt,
    this.updatedAt,
  }) : itemId = itemId ?? const Uuid().v4();

    ItemHiveModel copyWith({
        String? itemId,
        String? sellerId,
        String? seller,
        List<String>? photos,
        String? category,
        String? model,
        double? price,
        int? year,
        String? description,
        String? storage,
        String? screenCondition,
        int? batteryHealth,
        String? cameraQuality,
        bool? hasCharger,
        Map<String, dynamic>? extraAnswers,
        bool isSold = false,
        DateTime? createdAt,
        DateTime? updatedAt,
      }){
        return ItemHiveModel(
          itemId: itemId ?? this.itemId,
          sellerId: sellerId ?? this.sellerId,
          seller: seller ?? this.seller,
          photos: photos ?? this.photos,
          category: category ?? this.category,
          model: model ?? this.model,
          price: price ?? this.price,
          year: year ?? this.year,
          description: description ?? this.description,
          storage: storage ?? this.storage,
          screenCondition: screenCondition ?? this.screenCondition,
          batteryHealth: batteryHealth ?? this.batteryHealth,
          cameraQuality: cameraQuality ?? this.cameraQuality,
          hasCharger: hasCharger ?? this.hasCharger,
          extraAnswers: extraAnswers ?? this.extraAnswers,
          isSold: isSold,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
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
      price: price,
      year: year,
      description: description,
      storage: storage,
      screenCondition: screenCondition,
      batteryHealth: batteryHealth,
      cameraQuality: cameraQuality,
      hasCharger: hasCharger,
      extraAnswers: extraAnswers,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert Entity to Hive model
  factory ItemHiveModel.fromEntity(ItemEntity entity) {
    return ItemHiveModel(
      itemId: entity.itemId,
      sellerId: entity.sellerId,
      seller: '', // optional, can be filled from entity if you add seller name
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
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt, isSold: false,
    );
  }

  // Convert list of Hive models to Entity list
  static List<ItemEntity> toEntityList(List<ItemHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
