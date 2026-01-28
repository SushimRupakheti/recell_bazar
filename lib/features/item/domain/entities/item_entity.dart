import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String? itemId;
  final String sellerId;

  // Mandatory fields
  final List<String> photos;
  final String category; // smartphone
  final String model;
  final double price;
  final int year;
  final String description;
  final String storage;
  final String screenCondition;
  final int batteryHealth; // percentage
  final String cameraQuality;
  final bool hasCharger;

  // Extra dynamic questions
  final Map<String, dynamic>? extraAnswers;
  final bool isSold;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ItemEntity({
    this.itemId,
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
    this.createdAt,
    this.updatedAt,  
    this.isSold=false,
  });

  ItemEntity copyWith({
    String? itemId,
    String? sellerId,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isSold = false,
  }) {
    return ItemEntity(
      itemId: itemId ?? this.itemId,
      sellerId: sellerId ?? this.sellerId,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSold: isSold,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
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
        createdAt,
        updatedAt,
        isSold,
      ];
}
