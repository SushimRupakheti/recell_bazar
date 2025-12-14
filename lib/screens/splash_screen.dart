import 'dart:async'; // Correct import for Timer

import 'package:flutter/material.dart';

import 'package:recell_bazar/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    });
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
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0B7C7C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
