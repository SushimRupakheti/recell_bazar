import 'package:recell_bazar/features/notification/data/models/notification_api_model.dart';

abstract interface class INotificationRemoteDataSource {
  Future<List<NotificationApiModel>> fetchNotifications();

  Future<NotificationApiModel> markAsRead(String notificationId);

  Future<void> deleteNotification(String notificationId);
}
