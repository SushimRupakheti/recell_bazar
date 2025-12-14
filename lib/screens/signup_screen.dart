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
 bool isFirstNameFocused=false;
 bool isLastNameFocused=false;
 bool isEmailFocused=false;
 bool isPasswordFocused=false;
 bool isContactFocused=false;
 bool isAddressFoucused = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Image.asset("assets/images/logo.png", height: 150),
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
                            isFocused: isAddressFoucused,
                            label: "First name", 
                            hint:"First name !", 
                            validator: (value) =>
                            value!.isEmpty ? "Please enter your first name" : null,
                            onChanged:(value){
                              setState(() {
                                isFirstNameFocused=true;
                              });
                            }),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: MyTextField(
                            isFocused: isLastNameFocused,
                            label: "Last name", 
                            hint:"Last name !", 
                            validator: (value) =>
                            value!.isEmpty ? "Please enter your last name" : null,
                            onChanged:(value){
                              setState(() {
                                isLastNameFocused=true;
                              });
                            }),
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
                      onChanged: (value) {
                        setState(() {
                          isEmailFocused=true;
                        });
                      },
                      isFocused: isEmailFocused,
                    ),

                    const SizedBox(height: 15),

                    MyTextField(
                      isFocused: isContactFocused,
                      label: "Contact no. ",
                      hint: "enter your contact no.",
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your contact no. " : null,
                          onChanged:(value){
                            setState(() {
                              isContactFocused=true;
                            });
                          }),

                    const SizedBox(height: 15),

                    MyTextField(
                      isFocused:isAddressFoucused ,
                      label: "Address", 
                      hint: "enter you address", 
                      prefixIcon: Icons.map,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your contact no. " : null,
                          onChanged:(value){
                            setState(() {
                              isAddressFoucused=true;
                            });
                          }), 

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
