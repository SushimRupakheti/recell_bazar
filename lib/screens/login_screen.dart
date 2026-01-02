import 'package:flutter/material.dart';
import 'package:recell_bazar/screens/dashboard.dart';
import 'package:recell_bazar/screens/signup_screen.dart';
import 'package:recell_bazar/widgets/my_button.dart';
import 'package:recell_bazar/widgets/mytextfeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool isEmailFocused=false;
 bool isPasswordFocused=false;
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
              const SizedBox(height: 120),
              Image.asset(
                "assets/images/logo.png", 
                height: 200,
              ),
              const SizedBox(height: 30),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 45,
                  color: Color(0xFF0B7C7C),
                  fontFamily: "Montserrat-Bold",
                ),
              ),
              const SizedBox(height: 20),
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [

                    MyTextField(
                      isFocused: isEmailFocused,
                      label: "Email",
                      hint: "Enter your email",
                      prefixIcon: Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your email" : null,
                      onChanged: (value) {
                        setState(() {
                          isEmailFocused=true;
                        });
                      },
                    ),
          
                      const SizedBox(height: 15),
          
                    MyTextField(
                      isFocused: isPasswordFocused,
                      label: "Password",
                      hint: "Enter your password",
                      prefixIcon: Icons.password,
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter password" : null,
                      onChanged: (value) {
                        setState(() {
                          isPasswordFocused=true;
                        });
                      },
                    ),
                    
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
          
              MyButton(text: "Login", onPressed:(){
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
              }),
          
              const SizedBox(height: 10),
          
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0B7C7C), 
                ),
                child: const Text(
                  "Don't have an Account..?",
                  style: TextStyle(fontSize: 16, fontFamily: "Montserrat-Regular"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
