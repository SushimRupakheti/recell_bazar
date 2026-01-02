import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:recell_bazar/core/widgets/my_button.dart';
import 'package:recell_bazar/core/widgets/mytextfeild.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  bool isFirstNameFocused = false;
  bool isLastNameFocused = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool isContactFocused = false;
  bool isAddressFoucused = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  Future<void> registerUser() async {
    await ref
        .read(authViewModelProvider.notifier)
        .register(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          address: addressController.text,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen<AuthState>(authViewModelProvider, (preious, next){
      if(next.status == AuthStatus.authenticated){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
    } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? "Registration Failed")),
        );
      }
    });
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
                fontFamily: "Montserrat-Bold",
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
                            controller: firstNameController,
                            isFocused: isAddressFoucused,
                            label: "First name",
                            hint: "First name !",
                            validator: (value) => value!.isEmpty
                                ? "Please enter your first name"
                                : null,
                            onChanged: (value) {
                              setState(() {
                                isFirstNameFocused = true;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: MyTextField(
                            controller: lastNameController,
                            isFocused: isLastNameFocused,
                            label: "Last name",
                            hint: "Last name !",
                            validator: (value) => value!.isEmpty
                                ? "Please enter your last name"
                                : null,
                            onChanged: (value) {
                              setState(() {
                                isLastNameFocused = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    MyTextField(
                      controller: emailController,
                      label: "Email",
                      hint: "Enter your email",
                      prefixIcon: Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your email" : null,
                      onChanged: (value) {
                        setState(() {
                          isEmailFocused = true;
                        });
                      },
                      isFocused: isEmailFocused,
                    ),

                    const SizedBox(height: 15),

                    MyTextField(
                      controller: addressController,
                      isFocused: isContactFocused,
                      label: "Contact no. ",
                      hint: "enter your contact no.",
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty
                          ? "Please enter your contact no. "
                          : null,
                      onChanged: (value) {
                        setState(() {
                          isContactFocused = true;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    MyTextField(
                      controller: passwordController,
                      isFocused: isAddressFoucused,
                      label: "Address",
                      hint: "enter you address",
                      prefixIcon: Icons.map,
                      validator: (value) => value!.isEmpty
                          ? "Please enter your contact no. "
                          : null,
                      onChanged: (value) {
                        setState(() {
                          isAddressFoucused = true;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    MyTextField(
                      controller: passwordController,
                      isFocused: isPasswordFocused,
                      label: "Password",
                      hint: "Enter your password",
                      prefixIcon: Icons.password,
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter password" : null,
                      onChanged: (value) {
                        setState(() {
                          isPasswordFocused = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            MyButton(text: "Register", onPressed: registerUser),

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
                "Already have an Account..?",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Montserrat-Regular",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
