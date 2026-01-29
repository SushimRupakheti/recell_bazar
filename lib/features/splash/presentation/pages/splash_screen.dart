import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/domain/usecases/get_current_user.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard.dart';
import 'package:recell_bazar/features/onboarding/presentation/pages/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final userSessionServices = ref.read(userSessionServiceProvider);
    final isLoggedIn = userSessionServices.isLoggedIn();

    if (isLoggedIn) {
      // Refresh current user from repository (local or remote) to ensure
      // session and local cache are up-to-date (profileImage etc.).
      final getCurrent = ref.read(getCurrentUserUsecaseProvider);
      final result = await getCurrent();

      result.fold((failure) {
        // If fetching current user failed, navigate to onboarding.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }, (user) async {
        // Persist latest user fields into SharedPreferences session.
        await userSessionServices.saveUserSession(
          userId: user.authId ?? '',
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          contactNo: user.contactNo,
          address: user.address,
          profileImage: user.profileImage,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", height: 250),
            const SizedBox(height: 10),
            const Text(
              'ReCell \n Bazar',
              style: TextStyle(
                fontSize: 60,
                fontFamily: "Montserrat-Bold",
                color: Color(0xFF0B7C7C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
