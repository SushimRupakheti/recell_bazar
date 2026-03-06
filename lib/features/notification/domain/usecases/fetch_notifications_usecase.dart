import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/notification/data/repositories/notification_repository.dart';
import 'package:recell_bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:recell_bazar/features/notification/domain/repositories/notification_repository.dart';

final fetchNotificationsUsecaseProvider = Provider<FetchNotificationsUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return FetchNotificationsUsecase(notificationRepository: repository);
});

class FetchNotificationsUsecase
    implements UsecaseWithoutParams<List<NotificationEntity>> {
  final INotificationRepository _notificationRepository;

  FetchNotificationsUsecase({
    required INotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() {
    return _notificationRepository.fetchNotifications();
  }
}
