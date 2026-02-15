import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import 'package:recell_bazar/features/splash/presentation/pages/splash_screen.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/domain/usecases/get_current_user.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard.dart';
import 'package:recell_bazar/features/onboarding/presentation/pages/onboarding_screen.dart';

/// ----------------------------
/// Fake UserSessionServices
/// ----------------------------
class FakeUserSessionServices implements UserSessionServices {
  final bool loggedIn;
  FakeUserSessionServices({this.loggedIn = false});

  @override
  bool isLoggedIn() => loggedIn;

  @override
  Future<void> clearSession() async {}

  @override
  Future<void> saveUserSession({
    String? address,
    String? contactNo,
    required String email,
    required String firstName,
    required String lastName,
    String? profileImage,
    required String userId,
  }) async {}

  @override
  String? getUserAddress() => null;

  @override
  String? getUserEmail() => null;

  @override
  String? getUserLastName() => null;

  @override
  String? getUserPhoneNumber() => null;

  @override
  String? getUserProfileImage() => null;

  @override
  Future<void> saveProfileImage(String imageUrl) async {}

  @override
  Future<void> clearUserSession() async {}

  @override
  String? getFirstName() => null;

  @override
  String? getUserId() => null;
}

/// ----------------------------
/// Fake GetCurrentUserUsecase
/// ----------------------------
class FakeGetCurrentUserUsecase implements GetCurrentUserUsecase {
  final bool fail;

  FakeGetCurrentUserUsecase({this.fail = false});

  @override
  Future<Either<Failure, AuthEntity>> call() async {
    if (fail) {
      return Left(Failure(message: "Failed to get user"));
    }
    return Right(AuthEntity(
      authId: "123",
      email: "test@test.com",
      firstName: "Test",
      lastName: "User",
      contactNo: "1234567890",
      address: "Fake Address",
      profileImage: null,
    ));
  }
}

/// ----------------------------
/// SplashScreen Tests
/// ----------------------------
void main() {

  testWidgets("SplashScreen logged in navigates to Dashboard",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userSessionServiceProvider
              .overrideWithValue(FakeUserSessionServices(loggedIn: true)),
          getCurrentUserUsecaseProvider
              .overrideWithValue(FakeGetCurrentUserUsecase(fail: false)),
        ],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );

    // SplashScreen text should appear
    expect(find.text("ReCell \n Bazar"), findsOneWidget);

    // Wait for the 3-second timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Should navigate to Dashboard
    expect(find.byType(Dashboard), findsOneWidget);
  });
}
