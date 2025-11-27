import 'package:flutter/material.dart';
import 'package:recell_bazar/screens/login_screen.dart';
import 'package:recell_bazar/screens/main_dashboard_screen.dart';
import 'package:recell_bazar/screens/onboarding_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
