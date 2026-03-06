import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_client.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/features/notification/data/datasources/notification_datasource.dart';
import 'package:recell_bazar/features/notification/data/models/notification_api_model.dart';

final notificationRemoteDataSourceProvider = Provider<INotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
  );
});

class NotificationRemoteDataSource implements INotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<NotificationApiModel>> fetchNotifications() async {
    final response = await _apiClient.get(ApiEndpoints.notifications);
    final raw = response.data;

    final dataList = (raw is Map && raw['data'] is List)
        ? raw['data'] as List
        : <dynamic>[];

    return dataList
        .whereType<Map>()
        .map((json) => NotificationApiModel.fromJson(json.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<NotificationApiModel> markAsRead(String notificationId) async {
    final response = await _apiClient.put(
      ApiEndpoints.markNotificationAsRead(notificationId),
    );

    final raw = response.data;
    dynamic payload;
    if (raw is Map) {
      payload = raw['data'] ?? raw['notification'] ?? raw;
    } else {
      payload = raw;
    }

    if (payload is Map<String, dynamic>) {
      return NotificationApiModel.fromJson(payload);
    }

    if (payload is Map) {
      return NotificationApiModel.fromJson(payload.cast<String, dynamic>());
    }

    throw Exception(
      'NotificationRemoteDataSource.markAsRead: unexpected response shape: ${response.data}',
    );
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _apiClient.delete(
      ApiEndpoints.notificationById(notificationId),
    );
  }
}
