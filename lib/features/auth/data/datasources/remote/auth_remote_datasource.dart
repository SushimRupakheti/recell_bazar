import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_client.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/data/datasources/auth_datasource.dart';
import 'package:recell_bazar/features/auth/data/models/auth_api_model.dart';



//create provider 
final authRemoteDataSourceProvider = Provider <IAuthRemoteDataSource>((ref){
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionServices:ref.read(userSessionServiceProvider),
  );
});



class AuthRemoteDatasource implements IAuthRemoteDataSource{

  final ApiClient _apiClient;
  final UserSessionServices _userSessionServices;

   AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionServices userSessionServices,
  })  : _apiClient = apiClient,
        _userSessionServices = userSessionServices;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
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
        );
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
}