import 'package:equatable/equatable.dart';
import 'package:recell_bazar/features/notification/domain/entities/item_snapshot.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String user;
  final String title;
  final String message;
  /// One of: ADMIN_CUSTOM | APPROVED | REJECTED | SOLD
  final String type;
  final ItemSnapshot? item;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.user,
    required this.title,
    required this.message,
    required this.type,
    required this.item,
    required this.isRead,
    required this.createdAt,
  });

  NotificationEntity copyWith({
    String? id,
    String? user,
    String? title,
    String? message,
    String? type,
    ItemSnapshot? item,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      item: item ?? this.item,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        title,
        message,
        type,
        item,
        isRead,
        createdAt,
      ];
}
