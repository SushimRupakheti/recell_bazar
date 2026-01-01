import 'package:flutter/material.dart';
import 'package:recell_bazar/screens/dashboard.dart';
import 'package:recell_bazar/screens/signup_screen.dart';
import 'package:recell_bazar/core/widgets/my_button.dart';
import 'package:recell_bazar/core/widgets/mytextfeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isTablet ? 60 : 120),

                Image.asset(
                  "assets/images/logo.png",
                  height: isTablet ? 150 : 200,
                ),

                const SizedBox(height: 30),

                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: isTablet ? 36 : 45,
                    color: const Color(0xFF0B7C7C),
                    fontFamily: "Montserrat-Bold",
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      MyTextField(
                        isFocused: isEmailFocused,
                        label: "Email",
                        hint: "Enter your email",
                        prefixIcon: Icons.mail,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) {
                          setState(() => isEmailFocused = true);
                        },
                      ),

                      const SizedBox(height: 15),

                      MyTextField(
                        isFocused: isPasswordFocused,
                        label: "Password",
                        hint: "Enter your password",
                        prefixIcon: Icons.password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        obscureText: true,
                        onChanged: (_) {
                          setState(() => isPasswordFocused = true);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                MyButton(
                  text: "Login",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Dashboard()),
                    );
                  },
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: const Text("Don't have an Account..?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
