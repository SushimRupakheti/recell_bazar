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
  });

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
      ];
}
