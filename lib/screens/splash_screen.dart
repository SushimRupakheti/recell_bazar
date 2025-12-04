import 'dart:async'; // Correct import for Timer

import 'package:flutter/material.dart';
import 'package:recell_bazar/screens/login_screen.dart';
import 'package:recell_bazar/screens/main_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
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
            Image.asset("lib/assets/images/logo.png", height: 250),
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
