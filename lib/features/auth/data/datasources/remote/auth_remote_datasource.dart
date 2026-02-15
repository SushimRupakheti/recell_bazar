import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_client.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/core/services/storage/token_service.dart';
import 'package:recell_bazar/features/auth/data/datasources/auth_datasource.dart';
import 'package:recell_bazar/features/auth/data/models/auth_api_model.dart';



//create provider 
//create provider 
final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionServices: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});



class AuthRemoteDatasource implements IAuthRemoteDataSource{

  final ApiClient _apiClient;
  final UserSessionServices _userSessionServices;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionServices userSessionServices,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _userSessionServices = userSessionServices,
        _tokenService = tokenService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    return _getUserByIdInternal(authId);
  }

  // internal implementation to perform the GET request
  Future<AuthApiModel?> _getUserByIdInternal(String authId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userById(authId));
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return AuthApiModel.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async{
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data:{'email':email,'password':password});

      if(response.data['success']==true){
      final data= response.data['data'] as Map<String,dynamic>;
      final user= AuthApiModel.fromJson(data);

      // save to session
      await _userSessionServices.saveUserSession(
        userId: user.id!,
        email: email,
        firstName: user.firstName,
        lastName: user.lastName,
        contactNo: user.contactNo,
        address: user.address,
          profileImage: user.profileImage,
      );
        // Save token if provided by API (check both top-level and inside data)
        String? token;
        if (response.data['token'] != null) {
          token = response.data['token'] as String?;
        } else if (data['token'] != null) {
          token = data['token'] as String?;
        }

          if (token != null && token.isNotEmpty) {
            await _tokenService.saveToken(token);
        }
      return user;
    }
    return null;
  }
  
  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response= await _apiClient.post(
      ApiEndpoints.register,
      data:user.toJson(),
    );
    if(response.data['success']==true){
      final data= response.data['data'] as Map<String,dynamic>;
      final registeredUser= AuthApiModel.fromJson(data);
      return registeredUser;
    }
    return user;
  }

@override
Future<AuthApiModel?> uploadProfilePicture(String authId, File imageFile) async {
  try {
    final formData = FormData.fromMap({
      'profileImage': await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
    });

    // Use ApiClient.uploadFile with a relative path so BaseOptions.baseUrl and
    // interceptors are applied consistently.
    final response = await _apiClient.uploadFile(
      ApiEndpoints.uploadProfilePicture(authId),
      formData: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final updatedUser = AuthApiModel.fromJson(data);
      return updatedUser;
    }

    return null;
  } catch (e) {
    throw e;
  }
}

}