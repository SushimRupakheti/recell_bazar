import 'package:equatable/equatable.dart';


class AuthEntity extends Equatable {
  final String? authId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String address;
  final String? password;

  const AuthEntity({
    this.authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.address,
    this.password,
  });

  @override
  List<Object?> get props => [
    authId,
    firstName,
    lastName,
    email,
    phoneNumber,
    address,
    password,
  ];
}
