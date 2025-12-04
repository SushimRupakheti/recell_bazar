import 'package:flutter/material.dart';
import 'package:recell_bazar/screens/login_screen.dart';
import 'package:recell_bazar/widgets/my_button.dart';
import 'package:recell_bazar/widgets/mytextfeild.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Image.asset("lib/assets/images/logo.png", height: 150),
            const SizedBox(height: 10),
            Text(
              'Register',
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
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            label: "First name", 
                            hint:"First name !", 
                            validator: (value) =>
                            value!.isEmpty ? "Please enter your first name" : null,
                            onChanged:(value){}),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: MyTextField(
                            label: "Second name", 
                            hint:"Second name !", 
                            validator: (value) =>
                            value!.isEmpty ? "Please enter your second name" : null,
                            onChanged:(value){}),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                      label: "Contact no. ",
                      hint: "enter your contact no.",
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your contact no. " : null,
                          onChanged:(value){}),

                    const SizedBox(height: 15),

                    MyTextField(
                      label: "Address", 
                      hint: "enter you address", 
                      prefixIcon: Icons.map,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your contact no. " : null,
                          onChanged:(value){}), 

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
            const SizedBox(height: 30),

            MyButton(text: "Register", onPressed: () {}),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0B7C7C), // text color
              ),
              child: const Text(
                "Already have an Account?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
