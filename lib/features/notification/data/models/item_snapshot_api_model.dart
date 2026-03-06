import 'package:recell_bazar/features/notification/domain/entities/item_snapshot.dart';

class ItemSnapshotApiModel {
  final String id;
  final String phoneModel;
  final String category;
  final List<String> photos;
  final String finalPrice;
  final String status;

  ItemSnapshotApiModel({
    required this.id,
    required this.phoneModel,
    required this.category,
    required this.photos,
    required this.finalPrice,
    required this.status,
  });

  factory ItemSnapshotApiModel.fromJson(Map<String, dynamic> json) {
    return ItemSnapshotApiModel(
      id: json['_id']?.toString() ?? '',
      phoneModel: json['phoneModel']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      photos: (() {
        final raw = json['photos'];
        if (raw == null) return <String>[];
        if (raw is List) {
          return raw
              .map((e) => e?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList();
        }
        if (raw is String && raw.trim().isNotEmpty) {
          return raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        }
        return <String>[];
      })(),
      finalPrice: json['finalPrice']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  ItemSnapshot toEntity() {
    return ItemSnapshot(
      id: id,
      phoneModel: phoneModel,
      category: category,
      photos: photos,
      finalPrice: finalPrice,
      status: status,
    );
  }
}
