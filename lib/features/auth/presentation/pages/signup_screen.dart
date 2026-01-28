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
  final _formKey = GlobalKey<FormState>();

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
  final contactNoController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     try {
  //       if (Hive.isBoxOpen(HiveTableConstant.userTable)) {
  //         final box = Hive.box<AuthHiveModel>(HiveTableConstant.userTable);
  //         await box.clear();
  //       } else {
  //         try {
  //           await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);
  //         } catch (_) {}

  //         final box = Hive.box<AuthHiveModel>(HiveTableConstant.userTable);
  //         await box.clear();
  //       }
  //     } catch (e) {
  //       debugPrint("Error clearing user box: $e");
  //     }
  //   });
  // }


  Future<void> _handleSignup() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    final password = passwordController.text.trim();

    await ref
        .read(authViewModelProvider.notifier)
        .register(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          address: addressController.text.trim(),
          password: password,
          contactNo: contactNoController.text.trim(),
          batchId: "",
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
     if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next.status == AuthStatus.registered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration Successful. Please login."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [ 
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: firstNameController,
                            isFocused: isFirstNameFocused,
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
                          value!.trim().isEmpty ? "Please enter your email" : null,
                      onChanged: (value) {
                        setState(() {
                          isEmailFocused = true;
                        });
                      },
                      isFocused: isEmailFocused,
                    ),

                    const SizedBox(height: 15),

                    MyTextField(
                      controller: contactNoController,
                      isFocused: isContactFocused,
                      label: "Contact no. ",
                      hint: "enter your contact no.",
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.trim().isEmpty
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
                      controller: addressController,
                      isFocused: isAddressFoucused,
                      label: "Address",
                      hint: "enter your address",
                      prefixIcon: Icons.map,
                      validator: (value) => value!.trim().isEmpty
                          ? "Please enter your address"
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
                          value!.trim().isEmpty ? "Please enter password" : null,
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

            MyButton(
              text: authState.status == AuthStatus.loading ? "Registering..." : "Register",
              onPressed: authState.status == AuthStatus.loading ? () {} : _handleSignup,
            ),

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
