import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard.dart';
import 'package:recell_bazar/features/auth/presentation/pages/signup_screen.dart';
import 'package:recell_bazar/core/widgets/my_button.dart';
import 'package:recell_bazar/core/widgets/mytextfeild.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
void initState() {
  super.initState();
} 

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authViewModelProvider.notifier).login(
          email: emailController.text.trim().toLowerCase(),
          password: passwordController.text.trim(),
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
      }   else if (next.status == AuthStatus.authenticated) {
    // ✅ Success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login successful"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // ⏳ Small delay so user sees the snackbar
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Dashboard(),
        ),
      );
    });
  }
});
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Column(
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

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        MyTextField(
                          controller: emailController,
                          isFocused: isEmailFocused,
                          label: "Email",
                          hint: "Enter your email",
                          prefixIcon: Icons.mail,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            final tv = v!.trim();
                            if (tv.isEmpty) return "Email is required";
                            if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(tv)) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                          onChanged: (_) =>
                              setState(() => isEmailFocused = true),
                        ),

                        const SizedBox(height: 15),

                        MyTextField(
                          controller: passwordController,
                          isFocused: isPasswordFocused,
                          label: "Password",
                          hint: "Enter your password",
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          validator: (v) {
                            final tv = v!.trim();
                            if (tv.isEmpty) return "Password is required";
                            if (tv.length < 6) {
                              return "Minimum 6 characters";
                            }
                            return null;
                          },
                          onChanged: (_) =>
                              setState(() => isPasswordFocused = true),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                MyButton(
                  text: authState.status == AuthStatus.loading
                      ? "Logging in..."
                      : "Login",
                onPressed: authState.status == AuthStatus.loading ? () {} : () => loginUser(),

                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
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
