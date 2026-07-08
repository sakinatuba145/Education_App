import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../core/I18n/messages.dart';
/// 3.16 FORGOT PASSWORD SCREEN
/// This screen lets user reset password using email
/// Firebase sends a reset link to the email

class ForgotPasswordScreen extends StatefulWidget {
  static const String id = 'forgot_password_screen';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /// 3.17 EMAIL CONTROLLER
  /// Stores user email input for password reset request
  final emailController = TextEditingController();
  /// 3.18 FORM VALIDATION
  /// Ensures email is not empty before sending request
  final _formKey = GlobalKey<FormState>();
  /// 3.19 LOADING STATE
  /// Shows spinner while Firebase is sending reset email
  bool isLoading = false;


  /// 3.20 RESET PASSWORD FUNCTION (CORE LOGIC)
  /// 1. Validate email
  /// 2. Send reset request to Firebase Auth
  /// 3. Show success message
  /// 4. Go back to login screen

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppMessages.resetLinkSent.tr)),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppMessages.error.tr} $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        Text(
                          AppMessages.forgotPassword.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge,
                        ),
                        const SizedBox(height: 8),

                        Text(
                          AppMessages.forgotPasswordSubtitle.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),

                        Text(
                          AppMessages.resetPasswordInstruction.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 35),

                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            hintText: AppMessages.email.tr,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColors.button,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                :  Text(AppMessages.rLink.tr),
                          ),
                        ),

                        const SizedBox(height: 12),


                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child:  Text(AppMessages.toLogin.tr),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}