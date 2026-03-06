import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/services/connectivity/network_info.dart';
import 'package:recell_bazar/features/notification/data/datasources/notification_datasource.dart';
import 'package:recell_bazar/features/notification/data/datasources/remote/notification_remote_datasource.dart';
import 'package:recell_bazar/features/notification/data/models/notification_api_model.dart';
import 'package:recell_bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:recell_bazar/features/notification/domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepository(
    remoteDataSource: ref.read(notificationRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class NotificationRepository implements INotificationRepository {
  final INotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepository({
    required INotificationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  String _extractMessageFromDio(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return fallback;
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> fetchNotifications() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final models = await _remoteDataSource.fetchNotifications();
      return Right(NotificationApiModel.toEntityList(models));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractMessageFromDio(e, fallback: 'Failed to fetch notifications'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> markAsRead(String notificationId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.markAsRead(notificationId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractMessageFromDio(e, fallback: 'Failed to mark notification as read'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNotification(String notificationId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await _remoteDataSource.deleteNotification(notificationId);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractMessageFromDio(e, fallback: 'Failed to delete notification'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
