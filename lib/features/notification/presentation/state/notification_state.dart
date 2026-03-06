import 'package:equatable/equatable.dart';
import 'package:recell_bazar/features/notification/domain/entities/notification_entity.dart';

enum NotificationStatus {
  initial,
  loading,
  loaded,
  unauthorized,
  error,
}

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const <NotificationEntity>[],
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, notifications, errorMessage];
}
