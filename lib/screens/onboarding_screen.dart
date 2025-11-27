import 'package:flutter/material.dart';
import 'package:recell_bazar/screens/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
          width:double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                Color(0x0ffbfd3d),
                Colors.white,
              ],
            )
          ),
child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Box Border
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.4),
                    width: 12,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Logo Image
                    Image.asset(
                      "lib/assets/images/logo.png", // replace with your PNG
                      height: 300,
                    ),

                    // Main title
                    const Text(
                      "ReCell\nBazar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 45,
                        color: Color(0xFF0B7C7C), // teal
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Subtitle
                    const Text(
                      "“Your trusted second hand marketplace”",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B7C7C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}