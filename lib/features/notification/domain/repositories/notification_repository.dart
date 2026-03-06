import 'package:dartz/dartz.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/notification/domain/entities/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications();

  Future<Either<Failure, NotificationEntity>> markAsRead(
    String notificationId,
  );

  Future<Either<Failure, bool>> deleteNotification(
    String notificationId,
  );
}
