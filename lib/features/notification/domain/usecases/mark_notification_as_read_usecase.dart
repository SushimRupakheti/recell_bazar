import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/notification/data/repositories/notification_repository.dart';
import 'package:recell_bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:recell_bazar/features/notification/domain/repositories/notification_repository.dart';

final markNotificationAsReadUsecaseProvider = Provider<MarkNotificationAsReadUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return MarkNotificationAsReadUsecase(notificationRepository: repository);
});

class MarkNotificationAsReadUsecase
    implements UsecaseWithParams<NotificationEntity, MarkNotificationAsReadParams> {
  final INotificationRepository _notificationRepository;

  MarkNotificationAsReadUsecase({
    required INotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  @override
  Future<Either<Failure, NotificationEntity>> call(
    MarkNotificationAsReadParams params,
  ) {
    return _notificationRepository.markAsRead(params.notificationId);
  }
}

class MarkNotificationAsReadParams extends Equatable {
  final String notificationId;

  const MarkNotificationAsReadParams({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}
