import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/notification/data/repositories/notification_repository.dart';
import 'package:recell_bazar/features/notification/domain/repositories/notification_repository.dart';

final deleteNotificationUsecaseProvider = Provider<DeleteNotificationUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return DeleteNotificationUsecase(notificationRepository: repository);
});

class DeleteNotificationUsecase
    implements UsecaseWithParams<bool, DeleteNotificationParams> {
  final INotificationRepository _notificationRepository;

  DeleteNotificationUsecase({
    required INotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteNotificationParams params) {
    return _notificationRepository.deleteNotification(params.notificationId);
  }
}

class DeleteNotificationParams extends Equatable {
  final String notificationId;

  const DeleteNotificationParams({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}
