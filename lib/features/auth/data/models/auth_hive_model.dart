

import 'package:recell_bazar/core/constants/hive_table_constant.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';


//yo code le chai automated file generate garxa 
//for the generation- use the command(flutter pub run build_runner build --delete-conflicting-outputs)
part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)

class AuthHiveModel extends HiveObject{
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String contactNo;

  @HiveField(5)
  final String address;

  @HiveField(6)
  final String? password;

  @HiveField(7)
  final String? profileImage;


  AuthHiveModel({
    String? authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNo,
    required this.address,
    this.password,
    this.profileImage,
  }) : authId = authId ?? Uuid().v4();

  // To Entity
  AuthEntity toEntity({AuthEntity? batch}) {
    return AuthEntity(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      contactNo: contactNo,
      address: address,
      password: password,
    );
  }

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      contactNo: entity.contactNo,
      address: entity.address,
      password: entity.password,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
