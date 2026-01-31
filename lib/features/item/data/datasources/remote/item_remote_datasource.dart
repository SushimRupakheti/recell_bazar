import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_client.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/core/services/storage/token_service.dart';
import 'package:recell_bazar/features/item/data/datasources/item_datasource.dart';
import 'package:recell_bazar/features/item/data/models/item_api_model.dart';


final itemRemoteDatasourceProvider = Provider<IItemRemoteDataSource>((ref) {
  return ItemRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ItemRemoteDatasource implements IItemRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ItemRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<String> uploadPhoto(File photo) async {
    final fileName = photo.path.split('/').last;
    final formData = FormData.fromMap({
      'itemPhoto': await MultipartFile.fromFile(photo.path, filename: fileName),
    });
    // Get token from token service
    final token = await _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['data'];
  }

  @override
  Future<String> uploadVideo(File video) async {
    final fileName = video.path.split('/').last;
    final formData = FormData.fromMap({
      'itemVideo': await MultipartFile.fromFile(video.path, filename: fileName),
    });
    // Get token from token service
    final token = await _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadVideo,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['data'];
  }

  @override
  Future<ItemApiModel> createItem(ItemApiModel item) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.items,
      data: item.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ItemApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ItemApiModel>> getAllItems() async {
    final response = await _apiClient.get(ApiEndpoints.items);
    final data = response.data['data'] as List;
    return data.map((json) => ItemApiModel.fromJson(json)).toList();
  }

  @override
  Future<ItemApiModel> getItemById(String itemId) async {
    final response = await _apiClient.get(ApiEndpoints.itemById(itemId));
    return ItemApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ItemApiModel>> getItemsByUser(String userId) async {
    final response = await _apiClient.get(
      ApiEndpoints.items,
      queryParameters: {'reportedBy': userId},
    );
    final data = response.data['data'] as List;
    return data.map((json) => ItemApiModel.fromJson(json)).toList();
  }





  @override
  Future<List<ItemApiModel>> getItemsByCategory(String categoryId) async {
    final response = await _apiClient.get(
      ApiEndpoints.items,
      queryParameters: {'category': categoryId},
    );
    final data = response.data['data'] as List;
    return data.map((json) => ItemApiModel.fromJson(json)).toList();
  }

  @override
  Future<bool> updateItem(ItemApiModel item) async {
    final token = await _tokenService.getToken();
    await _apiClient.put(
      ApiEndpoints.itemById(item.id!),
      data: item.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }

  @override
  Future<bool> deleteItem(String itemId) async {
    final token = await _tokenService.getToken();
    await _apiClient.delete(
      ApiEndpoints.itemById(itemId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
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
