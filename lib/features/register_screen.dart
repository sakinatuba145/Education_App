import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/login_screen.dart';

/// 3.1 REGISTER SCREEN
/// This screen allows users to create a new account
/// They enter: name, email, password, and select a role

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// 3.2 FORM CONTROLLER SECTION
  /// These controllers store user input temporarily
  /// We use them to send data to Firebase when user taps "Create Account"

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  /// 3.3 FORM VALIDATION
  /// This key checks if inputs are valid before sending to backend
  final _formKey = GlobalKey<FormState>();
  /// 3.4 ROLE SYSTEM
  /// User chooses what type of account they are:
  String role = "student";

  bool isLoading = false;
  /// 3.5 PASSWORD VISIBILITY
 /// Controls show/hide password icon
  bool obscurePassword = true;
  /// 3.6 REGISTER FUNCTION (CORE LOGIC)
  /// 1. First checks if form is valid
  /// 2. Sends data to AuthService (Firebase)
   /// 3. Creates user in Authentication + Firestore
   /// 4. Then returns user back to login screen
  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final auth = AuthService();

      await auth.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        role,
      );

      if (!mounted) return;

      Navigator.pop(context);

    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    setState(() => isLoading = false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 40),

                              FadeInDown(
                                child: Text(
                                  "Create Account",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Start your learning journey today",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),

                              const SizedBox(height: 35),

                              TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: "Full Name",
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),

                              const SizedBox(height: 16),

                              TextFormField(
                                controller: passwordController,
                                obscureText: obscurePassword,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              DropdownButtonFormField<String>(
                                value: role,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.school),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: "student",
                                      child: Text("Student")),
                                  DropdownMenuItem(
                                      value: "teacher",
                                      child: Text("Teacher")),
                                  DropdownMenuItem(
                                      value: "academy",
                                      child: Text("Academy")),
                                ],
                                onChanged: (v) {
                                  setState(() => role = v!);
                                },
                              ),

                              const SizedBox(height: 25),

                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.button,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text("Create Account"),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: const [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    child: Text("OR"),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),

                              const SizedBox(height: 20),
                              /// 3.9 GOOGLE SIGN-IN OPTION
                              /// Allows fast registration using Google account
                              SizedBox(
                                height: 56,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final auth = AuthService();
                                    await auth.signInWithGoogle();

                                    if (!mounted) return;

                                    Navigator.pushReplacementNamed(
                                        context, '/dashboard');
                                  },
                                  icon: const Icon(Icons.g_mobiledata),
                                  label: const Text("Continue with Google"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.button,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.id);
                                },
                                child: const Text(
                                  "Already have an account? Login",
                                ),
                              ),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}