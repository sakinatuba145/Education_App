import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:education_app/core/widgets/app_snackbar.dart';
import 'package:education_app/core/constants/app_strings.dart';
import 'package:education_app/features/auth_services.dart';

import '../core/constants/theme.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  String role = "student";
  bool isLoading = false;
  bool obscurePass = true;
  bool obscureConfirm = true;

  void register() async {
    if (nameController.text.isEmpty &&
    emailController.text.isEmpty &&
    passwordController.text.isEmpty ||
    confirmController.text.isEmpty) {
      AppSnackBar.show(context, AppStrings.fillFields);
      return;
    }

    if (passwordController.text != confirmController.text) {
      AppSnackBar.show(context, "Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      final auth = AuthService();

      final user = await auth.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        role,
      );

      if (!mounted) return;

      if (user != null) {
        AppSnackBar.show(context, "Account created successfully");
        Navigator.pop(context);
      } else {
        AppSnackBar.show(context, "Registration failed");
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
      AppSnackBar.show(context, e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFA726),
        title: Text(
          "Register",
          style: theme.textTheme.titleLarge,
        ),
      ),

      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeColors.gradient1,
                ThemeColors.gradient2,
                ThemeColors.gradient3,
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Create Account",
                  style: theme.textTheme.headlineMedium,
                ),

                const SizedBox(height: 10),

                Text(
                  "Join your learning journey",
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Full name",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: obscurePass,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePass
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePass = !obscurePass;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                TextField(
                  controller: confirmController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: role,
                  items: const [
                    DropdownMenuItem(
                      value: "student",
                      child: Text("Student"),
                    ),
                    DropdownMenuItem(
                      value: "teacher",
                      child: Text("Teacher"),
                    ),
                    DropdownMenuItem(
                      value: "academy",
                      child: Text("Academy"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => role = value);
                    }
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD180),
                      foregroundColor: Colors.white
                    ),
                    onPressed: isLoading ? null : register,
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Create Account"),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final auth = AuthService();
                      final user = await auth.signInWithGoogle();

                      if (user != null && mounted) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text("Continue with Google"),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Already have an account? Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}