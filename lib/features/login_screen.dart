import 'package:education_app/dashboard/dashboard_screen.dart';
import 'package:education_app/features/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/teacher/screens/teacher_dashboard_screen.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePass = true;
  final AuthService _authService = AuthService();

  static const _primary = Color(0xFFFFA726);

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await _authService.loginWithEmail(
        email: email,
        password: password,
      );

      if (!mounted) return;

      final role = result?['role'] ?? 'student';

      if (role == 'teacher' || role == 'academy') {
        Navigator.pushReplacementNamed(context, TeacherDashboardScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, DashboardScreen.id);
      }
    } on Exception catch (e) {
      if (!mounted) return;
      final msg = e.toString()
          .replaceAll('Exception: ', '')
          .replaceAll('[firebase_auth/', '')
          .replaceAll(']', '');
      _showError(_friendlyAuthError(msg));
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Login Failed'),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 15)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _loginAsTeacherDemo() async {
    setState(() => isLoading = true);
    const email = 'demo.teacher@eduaf.com';
    const password = 'TeacherDemo@123';
    const name = 'Demo Teacher';
    const role = 'teacher';
    try {
      // Try to sign in first; if user doesn't exist, create it
      Map<String, dynamic>? result;
      try {
        result = await _authService.loginWithEmail(email: email, password: password);
      } catch (_) {
        // Account doesn't exist yet — create it
        await _authService.register(name, email, password, role);
        result = await _authService.loginWithEmail(email: email, password: password);
      }
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, TeacherDashboardScreen.id);
    } catch (e) {
      if (!mounted) return;
      _showError('Demo login failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String _friendlyAuthError(String code) {
    if (code.contains('user-not-found') || code.contains('invalid-credential') || code.contains('wrong-password')) {
      return 'Email or password is incorrect. Please check your credentials and try again.';
    } else if (code.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (code.contains('too-many-requests')) {
      return 'Too many failed attempts. Please wait a moment before trying again.';
    } else if (code.contains('network-request-failed')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (code.contains('operation-not-allowed')) {
      return 'Email/password login is not enabled. Please contact support.';
    } else {
      return 'Login failed. $code';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login', style: theme.textTheme.titleLarge)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Back', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Login to continue your learning journey.', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 40),

                Text('Email', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: theme.textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 24),
                Text('Password', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePass,
                  style: theme.textTheme.bodyLarge,
                  onSubmitted: (_) => login(),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(obscurePass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => obscurePass = !obscurePass),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, ForgotPasswordScreen.id),
                    child: const Text('Forgot Password?'),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    child: isLoading
                        ? const SizedBox(
                            height: 24, width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 30),
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR', style: theme.textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        final user = await _authService.signInWithGoogle();
                        if (user != null && mounted) {
                          final role = await _authService.getUserRole(user.uid);
                          if (role == 'teacher' || role == 'academy') {
                            Navigator.pushReplacementNamed(context, TeacherDashboardScreen.id);
                          } else {
                            Navigator.pushReplacementNamed(context, DashboardScreen.id);
                          }
                        }
                      } catch (e) {
                        if (mounted) _showError('Google sign-in failed: $e');
                      }
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: const Text('Continue with Google'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Quick demo access
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text('🚀 Quick Access for Testing',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : _loginAsTeacherDemo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.school, color: Colors.white, size: 18),
                          label: const Text('Login as Teacher (Demo)',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: theme.textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, RegisterScreen.id),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
