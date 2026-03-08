import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:recell_bazar/features/auth/domain/usecases/get_current_user.dart';
import 'package:recell_bazar/features/auth/domain/usecases/login_usecase.dart';
import 'package:recell_bazar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:recell_bazar/features/auth/domain/usecases/register_usecase.dart';
import 'package:recell_bazar/features/auth/domain/usecases/update_profile_image_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRepository implements IAuthRepository {
  AuthEntity? registeredUser;
  String? loginEmail;
  String? loginPassword;
  String? requestedCurrentUserId;
  String? updateProfileAuthId;
  File? updateProfileImageFile;
  int logoutCalls = 0;

  Either<Failure, bool> registerResult = const Right(true);
  Either<Failure, AuthEntity>? loginResult;
  Either<Failure, AuthEntity>? getCurrentUserResult;
  Either<Failure, bool> logoutResult = const Right(true);
  Either<Failure, AuthEntity>? updateProfilePictureResult;

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    registeredUser = user;
    return registerResult;
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    loginEmail = email;
    loginPassword = password;
    return loginResult ?? Left(ApiFailure(message: 'loginResult not configured'));
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser(String authId) async {
    requestedCurrentUserId = authId;
    return getCurrentUserResult ??
        Left(ApiFailure(message: 'getCurrentUserResult not configured'));
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    logoutCalls++;
    return logoutResult;
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfilePicture({
    required String authId,
    required File imageFile,
  }) async {
    updateProfileAuthId = authId;
    updateProfileImageFile = imageFile;
    return updateProfilePictureResult ??
        Left(ApiFailure(message: 'updateProfilePictureResult not configured'));
  }
}

AuthEntity buildUser({
  String? id = 'u-1',
  String firstName = 'Test',
  String lastName = 'User',
  String email = 'test@example.com',
  String phone = '9800000000',
  String address = 'Kathmandu',
  String? password,
  String? profileImage,
}) {
  return AuthEntity(
    authId: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    contactNo: phone,
    address: address,
    password: password,
    profileImage: profileImage,
  );
}

void main() {
  late FakeAuthRepository repo;

  setUp(() {
    repo = FakeAuthRepository();
  });

  test('1) RegisterUsecase maps params into AuthEntity and calls repository', () async {
    final usecase = RegisterUsecase(authRepository: repo);
    const params = RegisterUsecaseParams(
      firstName: 'Alice',
      lastName: 'Smith',
      email: 'alice@example.com',
      address: 'Lalitpur',
      password: 'secret123',
      contactNo: '9811111111',
    );

    final result = await usecase(params);

    expect(result, const Right(true));
    expect(repo.registeredUser, isNotNull);
    expect(repo.registeredUser!.firstName, 'Alice');
    expect(repo.registeredUser!.lastName, 'Smith');
    expect(repo.registeredUser!.email, 'alice@example.com');
    expect(repo.registeredUser!.address, 'Lalitpur');
    expect(repo.registeredUser!.password, 'secret123');
    expect(repo.registeredUser!.contactNo, '9811111111');
  });

  test('2) RegisterUsecase returns failure from repository', () async {
    repo.registerResult = const Left(ApiFailure(message: 'Email already exists'));
    final usecase = RegisterUsecase(authRepository: repo);
    const params = RegisterUsecaseParams(
      firstName: 'Bob',
      lastName: 'Jones',
      email: 'bob@example.com',
      address: 'Pokhara',
      password: '123456',
      contactNo: '9822222222',
    );

    final result = await usecase(params);

    expect(result, const Left(ApiFailure(message: 'Email already exists')));
  });

  test('3) LoginUsecase forwards email and password', () async {
    final expected = buildUser(id: 'u-login');
    repo.loginResult = Right(expected);
    final usecase = LoginUsecase(authRepository: repo);
    const params = LoginUsecaseParams(
      email: 'login@test.com',
      password: 'pass123',
    );

    final result = await usecase(params);

    expect(repo.loginEmail, 'login@test.com');
    expect(repo.loginPassword, 'pass123');
    expect(result, Right(expected));
  });

  test('4) LoginUsecase returns repository failure', () async {
    repo.loginResult = const Left(ApiFailure(message: 'Invalid credentials'));
    final usecase = LoginUsecase(authRepository: repo);
    const params = LoginUsecaseParams(
      email: 'bad@test.com',
      password: 'wrong',
    );

    final result = await usecase(params);

    expect(result, const Left(ApiFailure(message: 'Invalid credentials')));
  });

  test('5) LogoutUsecase delegates to repository', () async {
    final usecase = LogoutUsecase(authRepository: repo);

    final result = await usecase();

    expect(result, const Right(true));
    expect(repo.logoutCalls, 1);
  });

  test('6) GetCurrentUserUsecase returns LocalDatabaseFailure when no user id', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final session = UserSessionServices(prefs: prefs);
    final usecase = GetCurrentUserUsecase(
      authRepository: repo,
      userSession: session,
    );

    final result = await usecase();

    expect(
      result,
      const Left(LocalDatabaseFailure(message: 'No current user found')),
    );
  });

  test('7) GetCurrentUserUsecase reads session user id and fetches user', () async {
    SharedPreferences.setMockInitialValues({'user_id': 'u-session'});
    final prefs = await SharedPreferences.getInstance();
    final session = UserSessionServices(prefs: prefs);
    final expected = buildUser(id: 'u-session');
    repo.getCurrentUserResult = Right(expected);
    final usecase = GetCurrentUserUsecase(
      authRepository: repo,
      userSession: session,
    );

    final result = await usecase();

    expect(repo.requestedCurrentUserId, 'u-session');
    expect(result, Right(expected));
  });

  test('8) GetCurrentUserUsecase propagates repository failure', () async {
    SharedPreferences.setMockInitialValues({'user_id': 'u-fail'});
    final prefs = await SharedPreferences.getInstance();
    final session = UserSessionServices(prefs: prefs);
    repo.getCurrentUserResult = const Left(ApiFailure(message: 'User not found'));
    final usecase = GetCurrentUserUsecase(
      authRepository: repo,
      userSession: session,
    );

    final result = await usecase();

    expect(result, const Left(ApiFailure(message: 'User not found')));
  });

  test('9) UpdateProfilePictureUsecase forwards authId and image file', () async {
    final expected = buildUser(id: 'u-2', profileImage: '/uploads/new.png');
    repo.updateProfilePictureResult = Right(expected);
    final usecase = UpdateProfilePictureUsecase(authRepository: repo);
    final file = File('dummy_profile_image.png');
    final params = UpdateProfilePictureUsecaseParams(
      authId: 'u-2',
      imageFile: file,
    );

    final result = await usecase(params);

    expect(repo.updateProfileAuthId, 'u-2');
    expect(repo.updateProfileImageFile, file);
    expect(result, Right(expected));
  });

  test('10) UpdateProfilePictureUsecase returns failure from repository', () async {
    repo.updateProfilePictureResult =
        const Left(ApiFailure(message: 'Upload failed'));
    final usecase = UpdateProfilePictureUsecase(authRepository: repo);
    final params = UpdateProfilePictureUsecaseParams(
      authId: 'u-3',
      imageFile: File('broken_file.png'),
    );

    final result = await usecase(params);

    expect(result, const Left(ApiFailure(message: 'Upload failed')));
  });
}
