import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:education_app/core/widgets/portal_shell.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/register_screen.dart';
import 'package:education_app/features/forgot_password.dart';
import 'package:education_app/student/student_portal_screen.dart';
import 'package:education_app/teacher/screens/teacher_dashboard_screen.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../core/I18n/messages.dart';
/// 3.10 LOGIN SCREEN
/// This screen lets users login using email + password
/// After login, user is redirected based on their role

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// 3.11 INPUT CONTROLLERS
  /// These store email & password typed by the user
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  /// 3.12 FORM VALIDATION KEY
  /// Ensures email/password are not empty before login
  final _formKey = GlobalKey<FormState>();
  /// 3.13 UI STATE
  /// Controls loading spinner & password visibility
  bool isLoading = false;
  bool obscurePassword = true;
  String _selectedRole = 'student';

  final AuthService authService = AuthService();

  /// 3.14 LOGIN FUNCTION (CORE LOGIC)
  /// 1. Validate form
  /// 2. Send login request to Firebase
  /// 3. Get user role from Firestore
  /// 4. Redirect user based on role

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Check both 'role' and 'position' fields — Firestore accounts may use either
      final role = (user["role"] ?? user["position"] ?? "student").toString();
      final isTeacher = role == "teacher" || role == "admin";

      if (!mounted) return;

      // Enforce role toggle — reject mismatched credentials with a clear message
      if (_selectedRole == 'student' && isTeacher) {
        await authService.logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppMessages.teacherAccount.tr,
            ),
            duration: Duration(seconds: 4),
          ),
        );
        setState(() => isLoading = false);
        return;
      }
      if (_selectedRole == 'teacher' && !isTeacher) {
        await authService.logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(
              AppMessages.studentAccount.tr,
            ),
            duration: Duration(seconds: 4),
          ),
        );
        setState(() => isLoading = false);
        return;
      }

      if (isTeacher) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PortalShell(child: TeacherDashboardScreen()),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const StudentPortalScreen(),
          ),
        );
      }

    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    setState(() => isLoading = false);
  }

  Widget _roleTab(String role, IconData icon, String label) {
    final selected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? ThemeColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected ? Colors.white : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        FadeInDown(
                          child: Text(
                            AppMessages.comeBack.tr,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          _selectedRole == 'teacher'
                              ? AppMessages.signInToManage.tr
                              : AppMessages.continueJourney.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 28),

                        // Role toggle
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              _roleTab('student', Icons.school_rounded, AppMessages.student.tr),
                              _roleTab('teacher', Icons.person_rounded, AppMessages.teacher.tr),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),


                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: AppMessages.email.tr,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: AppMessages.password.tr,
                            prefixIcon: const Icon(Icons.lock_outline),
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

                        const SizedBox(height: 8),


                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, ForgotPasswordScreen.id);
                            },
                            child:  Text(AppMessages.forgot.tr),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColors.button,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(AppMessages.login.tr),
                          ),
                        ),

                        const SizedBox(height: 12),


                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegisterScreen.id);
                          },
                          child:  Text(
                            AppMessages.noAccount.tr,
                          ),
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