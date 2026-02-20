import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/usecases/login_usecase.dart';
import 'package:recell_bazar/features/auth/domain/usecases/register_usecase.dart';
import 'package:recell_bazar/features/auth/domain/usecases/get_current_user.dart';
import 'package:recell_bazar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';

/// ---------------------------------------------------------
/// MOCK CLASSES
/// ---------------------------------------------------------

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock
    implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  /// ---------------------------------------------------------
  /// FALLBACK VALUES (Fix Mocktail any() Error)
  /// ---------------------------------------------------------
  setUpAll(() {
    registerFallbackValue(
      LoginUsecaseParams(email: "", password: ""),
    );

    registerFallbackValue(
      RegisterUsecaseParams(
        firstName: "",
        lastName: "",
        email: "",
        address: "",
        password: "",
        contactNo: "",
      ),
    );
  });

  late ProviderContainer container;

  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  /// ---------------------------------------------------------
  /// SETUP
  /// ---------------------------------------------------------
  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  /// =========================================================
  /// TEST 1: INITIAL STATE
  /// =========================================================
  test("Initial state should be AuthState.initial", () {
    final state = container.read(authViewModelProvider);

    expect(state.status, AuthStatus.initial);
    expect(state.user, null);
    expect(state.errorMessage, null);
  });

  /// =========================================================
  /// GROUP 1: LOGIN TESTING
  /// =========================================================
  group("Login Tests", () {
    test("Login Success should authenticate user", () async {
      // Expected
      final expectedStatus = AuthStatus.authenticated;

      // Fake User
      final fakeUser = AuthEntity(
        authId: "1",
        firstName: "Sushim",
        lastName: "Rupakheti",
        email: "test@gmail.com",
        address: "Kathmandu",
        contactNo: "9800000000",
      );

      // Mock Success
      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => Right(fakeUser));

      // Call Login
      await container.read(authViewModelProvider.notifier).login(
            email: "test@gmail.com",
            password: "123456",
          );

      // Actual
      final state = container.read(authViewModelProvider);

      expect(state.status, expectedStatus);
      expect(state.user, fakeUser);
      expect(state.errorMessage, null);
    });

    test("Login Failure should return error", () async {
      // Expected
      final expectedStatus = AuthStatus.error;

      // Mock Failure
      when(() => mockLoginUsecase(any())).thenAnswer(
        (_) async => Left(Failure(message: "Invalid Credentials")),
      );

      // Call Login
      await container.read(authViewModelProvider.notifier).login(
            email: "wrong@gmail.com",
            password: "wrongpass",
          );

      // Actual
      final state = container.read(authViewModelProvider);

      expect(state.status, expectedStatus);
      expect(state.user, null);
      expect(state.errorMessage, "Invalid Credentials");
    });
  });

  /// =========================================================
  /// GROUP 2: REGISTER TESTING
  /// =========================================================
  group("Register Tests", () {
    test("Register Success should set registered status", () async {
      // Expected
      final expectedStatus = AuthStatus.registered;

      // Mock Success
      when(() => mockRegisterUsecase(any()))
          .thenAnswer((_) async => const Right(true));

      // Call Register
      await container.read(authViewModelProvider.notifier).register(
            firstName: "Sushim",
            lastName: "Rupakheti",
            email: "new@gmail.com",
            address: "Kathmandu",
            password: "password",
            contactNo: "9800000000",
          );

      // Actual
      final state = container.read(authViewModelProvider);

      expect(state.status, expectedStatus);
      expect(state.errorMessage, null);
    });

    test("Register Failure should return error", () async {
      // Expected
      final expectedStatus = AuthStatus.error;

      // Mock Failure
      when(() => mockRegisterUsecase(any())).thenAnswer(
        (_) async => Left(Failure(message: "Email Already Exists")),
      );

      // Call Register
      await container.read(authViewModelProvider.notifier).register(
            firstName: "Sushim",
            lastName: "Rupakheti",
            email: "duplicate@gmail.com",
            address: "Kathmandu",
            password: "password",
            contactNo: "9800000000",
          );

      // Actual
      final state = container.read(authViewModelProvider);

      expect(state.status, expectedStatus);
      expect(state.errorMessage, "Email Already Exists");
    });
  });

  /// =========================================================
  /// GROUP 3: GET CURRENT USER TESTING
  /// =========================================================
  group("GetCurrentUser Tests", () {
    test("GetCurrentUser Success should authenticate user", () async {
      // Fake User
      final fakeUser = AuthEntity(
        authId: "99",
        firstName: "Current",
        lastName: "User",
        email: "current@gmail.com",
        address: "Kathmandu",
        contactNo: "9800000000",
      );

      // Mock Success
      when(() => mockGetCurrentUserUsecase())
          .thenAnswer((_) async => Right(fakeUser));

      // Call Function
      await container.read(authViewModelProvider.notifier).getCurrentUser();

      // Actual
      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, fakeUser);
    });

    test("GetCurrentUser Failure should unauthenticate", () async {
      // Mock Failure
      when(() => mockGetCurrentUserUsecase()).thenAnswer(
        (_) async => Left(Failure(message: "No User Found")),
      );

      // Ensure logout usecase is stubbed because viewModel awaits it on failure
      when(() => mockLogoutUsecase()).thenAnswer((_) async => const Right(true));

      // Call Function
      await container.read(authViewModelProvider.notifier).getCurrentUser();

      // allow async failure handler (which awaits logout) to complete
      var attempts = 0;
      while (container.read(authViewModelProvider).status == AuthStatus.loading && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 10));
        attempts++;
      }

      // Actual
      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, null);
      expect(state.errorMessage, "No User Found");
    });
  });

  /// =========================================================
  /// GROUP 4: LOGOUT TESTING
  /// =========================================================
  group("Logout Tests", () {
    test("Logout Success should unauthenticate user", () async {
      // Expected
      final expectedStatus = AuthStatus.unauthenticated;

      // Mock Success
      when(() => mockLogoutUsecase())
          .thenAnswer((_) async => const Right(true));

      // Call Logout
      await container.read(authViewModelProvider.notifier).logout();

      // Actual
      final state = container.read(authViewModelProvider);

      expect(state.status, expectedStatus);
      expect(state.user, null);
    });

    test("Logout Failure should return error", () async {
      // Expected
      final expectedStatus = AuthStatus.error;

      // Mock Failure
      when(() => mockLogoutUsecase()).thenAnswer(
        (_) async => Left(Failure(message: "Logout Failed")),
      );

      // Call Logout
      await container.read(authViewModelProvider.notifier).logout();

      // Actual
      final state = container.read(authViewModelProvider);

      expect(state.status, expectedStatus);
      expect(state.errorMessage, "Logout Failed");
    });
  });
}
