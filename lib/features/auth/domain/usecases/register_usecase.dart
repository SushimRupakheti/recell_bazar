import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/auth/data/repositories/auth_repository.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/repositories/auth_repository.dart';


class RegisterUsecaseParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String password;
  final String contactNo;


  const RegisterUsecaseParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.password,
    required this.contactNo,

  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    address,
    password,
    contactNo,
  ];
}

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final authEntity = AuthEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      address: params.address,
      password: params.password,
      contactNo: params.contactNo,
      profileImage: null,
    );

    return _authRepository.register(authEntity);
  }
}
