import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_client.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/core/services/storage/token_service.dart';
import 'package:recell_bazar/features/item/data/datasources/item_datasource.dart';
import 'package:recell_bazar/features/item/data/models/item_api_model.dart';


final itemRemoteDatasourceProvider = Provider<IItemRemoteDataSource>((ref) {
  return ItemRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

class ItemRemoteDatasource implements IItemRemoteDataSource {
  final ApiClient _apiClient;

  ItemRemoteDatasource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<String> uploadPhoto(File photo) async {
    final fileName = photo.path.split('/').last;
    final formData = FormData.fromMap({
      'itemPhoto': await MultipartFile.fromFile(photo.path, filename: fileName),
    });
    // Get token from token service
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData: formData,
    );

    // Debug: print full response to help diagnose shape
    debugPrint('ItemRemoteDatasource.uploadPhoto response.data: ${response.data}');

    // Attempt to extract URL from common response shapes
    final respData = response.data;

    dynamic candidate;
    if (respData is Map && respData.containsKey('data')) {
      candidate = respData['data'];
    } else {
      candidate = respData;
    }

    // If candidate is a plain string, assume it's the URL
    if (candidate is String) return candidate;

    // If candidate is a map, look for common keys
    if (candidate is Map) {
      if (candidate['url'] != null && candidate['url'] is String) return candidate['url'];
      if (candidate['path'] != null && candidate['path'] is String) return candidate['path'];
      if (candidate['filePath'] != null && candidate['filePath'] is String) return candidate['filePath'];
      if (candidate['data'] != null && candidate['data'] is String) return candidate['data'];

      // Some backends return an array of uploaded file info
      if (candidate['files'] is List && candidate['files'].isNotEmpty) {
        final first = candidate['files'][0];
        if (first is String) return first;
        if (first is Map && first['url'] != null && first['url'] is String) return first['url'];
      }
    }

    // If nothing matched, throw to let upper layers handle/log
    throw Exception('Unexpected upload response shape: ${response.data}');
  }

  @override
  Future<String> uploadVideo(File video) async {
    final fileName = video.path.split('/').last;
    final formData = FormData.fromMap({
      'itemVideo': await MultipartFile.fromFile(video.path, filename: fileName),
    });
    // Get token from token service
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadVideo,
      formData: formData,
    );

    return response.data['data'];
  }

  @override
  Future<ItemApiModel> createItem(ItemApiModel item) async {
    final response = await _apiClient.post(
      ApiEndpoints.items,
      data: item.toJson(),
    );

    return ItemApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ItemApiModel>> getAllItems() async {
    final response = await _apiClient.get(ApiEndpoints.items);
    final raw = response.data;
    final dataList = (raw is Map && (raw['data'] is List || raw['items'] is List))
        ? (raw['data'] ?? raw['items']) as List
        : (raw is List ? raw : <dynamic>[]);

    return dataList.map((json) => ItemApiModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<ItemApiModel> getItemById(String itemId) async {
    final response = await _apiClient.get(ApiEndpoints.itemById(itemId));

    final raw = response.data;
    // Support multiple response shapes: { data: { ... } } or { item: { ... } } or direct object
    dynamic payload;
    if (raw is Map) {
      payload = raw['data'] ?? raw['item'] ?? raw;
    } else {
      payload = raw;
    }

    if (payload is Map<String, dynamic>) {
      return ItemApiModel.fromJson(payload);
    }

    throw Exception('ItemRemoteDatasource.getItemById: unexpected response shape: ${response.data}');
  }

  @override
  Future<List<ItemApiModel>> getItemsByUser(String userId) async {
    debugPrint('ItemRemoteDatasource.getItemsByUser: requesting for userId=$userId');
    try {
      // Try the dedicated endpoint first
      final response = await _apiClient.get(
        ApiEndpoints.itemsByUser(userId),
      );
      final raw = response.data;
        final dataList = (raw is Map && (raw['data'] is List || raw['items'] is List))
          ? (raw['data'] ?? raw['items']) as List
          : (raw is List ? raw : <dynamic>[]);

        final models = dataList.map((json) => ItemApiModel.fromJson(json as Map<String, dynamic>)).toList();
        debugPrint('ItemRemoteDatasource.getItemsByUser: user-endpoint returned ${models.length} items');

        // Always defensively filter by seller id in case backend returns all items
        final normRequested = userId.trim().toLowerCase();
        final filtered = models.where((m) => (m.sellerId ?? '').trim().toLowerCase() == normRequested).toList();
        debugPrint('ItemRemoteDatasource.getItemsByUser: filtered ${filtered.length} items for userId=$userId');
        return filtered;
    } on DioError catch (e) {
      // If the backend doesn't expose the user-specific route, fall back to fetching all items
      debugPrint('ItemRemoteDatasource.getItemsByUser: user-endpoint failed (${e.response?.statusCode}). Falling back to getAllItems');
      final response = await _apiClient.get(ApiEndpoints.items);
      final raw = response.data;
        final dataList = (raw is Map && (raw['data'] is List || raw['items'] is List))
          ? (raw['data'] ?? raw['items']) as List
          : (raw is List ? raw : <dynamic>[]);

        final models = dataList.map((json) => ItemApiModel.fromJson(json as Map<String, dynamic>)).toList();
        debugPrint('ItemRemoteDatasource.getItemsByUser: fallback getAllItems returned ${models.length} items');

        final normRequested = userId.trim().toLowerCase();
        final filtered = models.where((m) => (m.sellerId ?? '').trim().toLowerCase() == normRequested).toList();
        debugPrint('ItemRemoteDatasource.getItemsByUser: fallback filtered ${filtered.length} items for userId=$userId');
        return filtered;
    }
  }





  @override
  Future<List<ItemApiModel>> getItemsByCategory(String categoryId) async {
    final response = await _apiClient.get(
      ApiEndpoints.items,
      queryParameters: {'category': categoryId},
    );
    final raw = response.data;
    final dataList = (raw is Map && (raw['data'] is List || raw['items'] is List))
        ? (raw['data'] ?? raw['items']) as List
        : (raw is List ? raw : <dynamic>[]);

    return dataList.map((json) => ItemApiModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<bool> updateItem(ItemApiModel item) async {
    await _apiClient.put(
      ApiEndpoints.itemById(item.id!),
      data: item.toJson(),
    );
    return true;
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    await _apiClient.delete(
      ApiEndpoints.itemById(itemId),
    );
    return true;
  }

  @override
  Future<bool> addToCart(String itemId) {
    // TODO: implement addToCart
    throw UnimplementedError();
  }

  @override
  Future<bool> clearCart() {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> getCartItems() {
    // TODO: implement getCartItems
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> getRelatedItems(String itemId) {
    // TODO: implement getRelatedItems
    throw UnimplementedError();
  }

  @override
  Future<bool> markItemAsSold(bool isSold, String itemId) {
    // TODO: implement markItemAsSold
    throw UnimplementedError();
  }

  @override
  Future<bool> removeFromCart(String itemId) {
    // TODO: implement removeFromCart
    throw UnimplementedError();
  }

  @override
  Future<List<ItemApiModel>> searchItems(String phoneModel, {String? categoryId}) {
    // TODO: implement searchItems
    throw UnimplementedError();
  }
}
