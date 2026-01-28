import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNo;
  final String? password;
  final String? address;
  final String? profileImage;

  AuthApiModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNo,
    this.password,
    required this.address,
    this.profileImage,
  });

  //toJson
  Map<String,dynamic> toJson(){
    return{
      "firstName":firstName,
      "lastName":lastName,
      "email":email,
      "contactNo":contactNo,
      "password":password,
      "address":address,
      "profileImage":profileImage,
    };
  }


  //fromJson
  factory AuthApiModel.fromJson(Map<String,dynamic>json){
    return AuthApiModel(
      id:json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json ['email'] as String,
      contactNo: json['contactNo'] as String,
      address: json['address'] as String,
      profileImage: json['profileImage'] as String?,
      );
  }

  //toEntity
  AuthEntity toEntity(){
    return AuthEntity(
      authId: id,
      firstName:firstName,
      lastName: lastName,
      email: email,
      contactNo: contactNo,
      address: address ?? '',
      password: password,
      profileImage: profileImage,
    );
  }


  //fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity){
    return AuthApiModel(
      firstName:entity.firstName,
      lastName:entity.lastName,
      email: entity.email,
      password: entity.password,
      contactNo: entity.contactNo,
      address: entity.address,
      profileImage: entity.profileImage, 
    );
  }

  //toENtityList
  static List<AuthEntity> toENtityList(List<AuthApiModel> models){
    return models.map((model)=>model.toEntity()).toList();
  }

}

