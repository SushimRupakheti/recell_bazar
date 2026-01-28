import 'package:equatable/equatable.dart';


class AuthEntity extends Equatable {
  final String? authId;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNo;
  final String address;
  final String? password;
  final String? profileImage;

  const AuthEntity({
    this.authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNo,
    required this.address,
    this.password,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
    authId,
    firstName,
    lastName,
    email,
    contactNo,
    address,
    password,
    profileImage,
  ];
}
