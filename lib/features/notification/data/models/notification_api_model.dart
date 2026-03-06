import 'package:recell_bazar/features/notification/data/models/item_snapshot_api_model.dart';
import 'package:recell_bazar/features/notification/domain/entities/notification_entity.dart';

class NotificationApiModel {
  final String id;
  final String user;
  final String title;
  final String message;
  final String type;
  final ItemSnapshotApiModel? item;
  final bool isRead;
  final DateTime createdAt;

  NotificationApiModel({
    required this.id,
    required this.user,
    required this.title,
    required this.message,
    required this.type,
    required this.item,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt']?.toString();
    DateTime parsedCreatedAt;
    try {
      parsedCreatedAt = createdAtRaw != null ? DateTime.parse(createdAtRaw) : DateTime.fromMillisecondsSinceEpoch(0);
    } catch (_) {
      parsedCreatedAt = DateTime.fromMillisecondsSinceEpoch(0);
    }

    final itemRaw = json['item'];
    final ItemSnapshotApiModel? parsedItem = itemRaw is Map<String, dynamic>
        ? ItemSnapshotApiModel.fromJson(itemRaw)
        : (itemRaw is Map ? ItemSnapshotApiModel.fromJson(itemRaw.cast<String, dynamic>()) : null);

    return NotificationApiModel(
      id: json['_id']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      item: parsedItem,
      isRead: json['isRead'] == true,
      createdAt: parsedCreatedAt,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      user: user,
      title: title,
      message: message,
      type: type,
      item: item?.toEntity(),
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  static List<NotificationEntity> toEntityList(List<NotificationApiModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
