import 'package:flutter/material.dart';
import 'package:recell_bazar/screens/signup_screen.dart';
import 'package:recell_bazar/widgets/my_button.dart';
import 'package:recell_bazar/widgets/mytextfeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                "lib/assets/images/logo.png", // replace with your PNG
                height: 200,
              ),
              const SizedBox(height: 30),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 45,
                  color: Color(0xFF0B7C7C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [

                    MyTextField(
                      label: "Email",
                      hint: "Enter your email",
                      prefixIcon: Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your email" : null,
                      onChanged: (value) {},
                    ),
          
                      const SizedBox(height: 15),
          
                    MyTextField(
                      label: "Password",
                      hint: "Enter your password",
                      prefixIcon: Icons.password,
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter password" : null,
                      onChanged: (value) {},
                    ),
                    
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
          
              MyButton(text: "Login", onPressed:(){}),
          
              const SizedBox(height: 10),
          
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0B7C7C), // text color
                ),
                child: const Text(
                  "Don't have an Account?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
