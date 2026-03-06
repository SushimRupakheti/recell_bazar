import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:recell_bazar/features/notification/domain/usecases/fetch_notifications_usecase.dart';
import 'package:recell_bazar/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:recell_bazar/features/notification/presentation/state/notification_state.dart';

final notificationViewModelProvider = NotifierProvider<NotificationViewModel, NotificationState>(
  NotificationViewModel.new,
);

class NotificationViewModel extends Notifier<NotificationState> {
  late final FetchNotificationsUsecase _fetchNotificationsUsecase;
  late final MarkNotificationAsReadUsecase _markAsReadUsecase;
  late final DeleteNotificationUsecase _deleteNotificationUsecase;

  @override
  NotificationState build() {
    _fetchNotificationsUsecase = ref.read(fetchNotificationsUsecaseProvider);
    _markAsReadUsecase = ref.read(markNotificationAsReadUsecaseProvider);
    _deleteNotificationUsecase = ref.read(deleteNotificationUsecaseProvider);

    return const NotificationState();
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(status: NotificationStatus.loading, resetErrorMessage: true);

    final result = await _fetchNotificationsUsecase();

    result.fold(
      (failure) {
        if (failure is ApiFailure && failure.statusCode == 401) {
          state = state.copyWith(
            status: NotificationStatus.unauthorized,
            errorMessage: failure.message,
          );
          return;
        }
        state = state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        );
      },
      (notifications) {
        state = state.copyWith(
          status: NotificationStatus.loaded,
          notifications: notifications,
          resetErrorMessage: true,
        );
      },
    );
  }

  /// Marks a single notification as read.
  /// Returns a [Failure] when the request fails (useful for showing SnackBars).
  Future<Failure?> markAsRead(String notificationId) async {
    final result = await _markAsReadUsecase(
      MarkNotificationAsReadParams(notificationId: notificationId),
    );

    Failure? failure;
    result.fold(
      (f) {
        failure = f;
        if (f is ApiFailure && f.statusCode == 401) {
          state = state.copyWith(status: NotificationStatus.unauthorized, errorMessage: f.message);
          return;
        }
        state = state.copyWith(errorMessage: f.message);
      },
      (updated) {
        final updatedList = state.notifications
            .map((n) => n.id == updated.id ? updated : n)
            .toList(growable: false);
        state = state.copyWith(
          status: NotificationStatus.loaded,
          notifications: updatedList,
          resetErrorMessage: true,
        );
      },
    );

    return failure;
  }

  /// Deletes a single notification.
  /// Returns a [Failure] when the request fails (useful for showing SnackBars).
  Future<Failure?> deleteNotification(String notificationId) async {
    final result = await _deleteNotificationUsecase(
      DeleteNotificationParams(notificationId: notificationId),
    );

    Failure? failure;
    result.fold(
      (f) {
        failure = f;
        if (f is ApiFailure && f.statusCode == 401) {
          state = state.copyWith(status: NotificationStatus.unauthorized, errorMessage: f.message);
          return;
        }
        state = state.copyWith(errorMessage: f.message);
      },
      (_) {
        final remaining = state.notifications
            .where((n) => n.id != notificationId)
            .toList(growable: false);
        state = state.copyWith(
          status: NotificationStatus.loaded,
          notifications: remaining,
          resetErrorMessage: true,
        );
      },
    );

    return failure;
  }
}
