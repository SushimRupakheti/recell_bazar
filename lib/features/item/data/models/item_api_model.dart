

import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';

class ItemApiModel {
  final String? id;
  final String seller;
  
  // mandatory feilds
  final List<String> photos;
  final String category; // smartphone
  final String model;
  final double price;
  final int year;
  final String description;
  final String storage;
  final String screenCondition;
  final int batteryHealth; // %
  final String cameraQuality;
  final bool hasCharger;
  final String sellerId;

  final Map<String, dynamic>? extraAnswers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Constructor
  ItemApiModel({
    this.id,
    required this.seller,
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
    this.createdAt,
    this.updatedAt, 
    required this.sellerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'photos': photos,
      'category': category,
      'model': model,
      'price': price,
      'year': year,
      'description': description,
      'storage': storage,
      'screenCondition': screenCondition,
      'batteryHealth': batteryHealth,
      'cameraQuality': cameraQuality,
      'hasCharger': hasCharger,
      'sellerId': sellerId,
      if (extraAnswers != null) 'extraAnswers': extraAnswers,
    };
  }


  factory ItemApiModel.fromJson(Map<String, dynamic> json) {
    return ItemApiModel(
      id: json['_id'],
      seller: json['seller'],
      photos: List<String>.from(json['photos']),
      category: json['category'],
      model: json['model'],
      price: (json['price'] as num).toDouble(),
      year: json['year'],
      description: json['description'],
      sellerId: json['sellerId'],
      storage: json['storage'],
      screenCondition: json['screenCondition'],
      batteryHealth: json['batteryHealth'],
      cameraQuality: json['cameraQuality'],
      hasCharger: json['hasCharger'],
      extraAnswers: json['extraAnswers'] != null
          ? Map<String, dynamic>.from(json['extraAnswers'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }


  ItemEntity toEntity() {
    return ItemEntity(
      itemId: id,
      sellerId: seller,
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

  factory ItemApiModel.fromEntity(ItemEntity entity) {
    return ItemApiModel(
      id: entity.itemId,
      seller: entity.sellerId,
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
      sellerId: entity.sellerId,
      hasCharger: entity.hasCharger,
      extraAnswers: entity.extraAnswers,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<ItemEntity> toEntityList(List<ItemApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
