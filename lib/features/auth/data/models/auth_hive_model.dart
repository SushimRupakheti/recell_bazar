

import 'package:recell_bazar/core/constants/hive_table_constant.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';



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
  final String? phoneNumber;

  @HiveField(5)
  final String address;

  @HiveField(6)
  final String? password;


  AuthHiveModel({
    String? authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.address,
    this.password,
  }) : authId = authId ?? const Uuid().v4();

  // To Entity
  AuthEntity toEntity({AuthEntity? batch}) {
    return AuthEntity(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
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
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      password: entity.password,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
