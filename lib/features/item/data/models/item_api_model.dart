import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';

class ItemApiModel {
  final String? id;
  final String sellerId;

  final List<String> photos;

  final String category;
  final String phoneModel;

  final String finalPrice;
  final String basePrice;

  final int year;
  final int batteryHealth;
  final String description;

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
    required this.phoneModel,
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
    required this.finalPrice,
    required this.basePrice,
  });

  Map<String, dynamic> toJson() {
    return {
      "photos": photos,
      "category": category,
      "phoneModel": phoneModel,
      "year": year,
      "batteryHealth": batteryHealth,
      "description": description,
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
      sellerId: (() {
        final s = json['sellerId'];
        if (s == null) return '';
        if (s is String) return s;
        if (s is Map && s.containsKey('_id')) return s['_id'].toString();
        return s.toString();
      })(),
      photos: (() {
        final raw = json['photos'];
        if (raw == null) return <String>[];
        if (raw is List) return raw.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
        // If backend returned a comma-separated string
        if (raw is String && raw.trim().isNotEmpty) return raw.split(',').map((s) => s.trim()).toList();
        return <String>[];
      })(),
      category: json["category"],
      phoneModel: json["phoneModel"],
      year: json["year"],
      batteryHealth: json["batteryHealth"],
      description: json["description"],
      // deviceCondition removed
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
    String resolveUrl(String path) {
      if (path.isEmpty) return '';
      if (path.startsWith('http')) return path;
      // Remove the trailing '/api' from base URL if present so media paths map correctly.
      final mediaBase = ApiEndpoints.baseUrl.replaceFirst('/api', '');
      return mediaBase + (path.startsWith('/') ? path : '/$path');
    }

    final resolvedPhotos = photos.map((p) => resolveUrl(p)).where((s) => s.isNotEmpty).toList();

    return ItemEntity(
      itemId: id,
      sellerId: sellerId,
      photos: resolvedPhotos,
      category: category,
      phoneModel: phoneModel,
      year: year,
      batteryHealth: batteryHealth,
      description: description,
      // deviceCondition removed
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
      phoneModel: entity.phoneModel,
      year: entity.year,
      batteryHealth: entity.batteryHealth,
      description: entity.description,
      // deviceCondition removed,
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
