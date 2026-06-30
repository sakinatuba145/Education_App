import 'package:flutter/material.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/teacher/screens/teacher_dashboard_screen.dart';
import 'package:education_app/dashboard/dashboard_screen.dart';

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

  String role = 'student';
  bool isLoading = false;
  bool obscurePass = true;
  bool obscureConfirm = true;

  static const _primary = Color(0xFFFFA726);

  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (name.isEmpty) { _showError('Please enter your full name.'); return; }
    if (email.isEmpty) { _showError('Please enter your email address.'); return; }
    if (password.isEmpty) { _showError('Please enter a password.'); return; }
    if (password.length < 6) { _showError('Password must be at least 6 characters.'); return; }
    if (password != confirm) { _showError('Passwords do not match. Please try again.'); return; }

    setState(() => isLoading = true);

    try {
      final auth = AuthService();
      final user = await auth.register(name, email, password, role);

      if (!mounted) return;

      if (user != null) {
        // Navigate directly to the right dashboard — no need to log in again
        if (role == 'teacher') {
          Navigator.pushReplacementNamed(context, TeacherDashboardScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, DashboardScreen.id);
        }
      } else {
        _showError('Registration failed. Please try again.');
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
            Text('Registration Error'),
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

  String _friendlyAuthError(String code) {
    if (code.contains('email-already-in-use')) {
      return 'An account with this email already exists. Please log in instead.';
    } else if (code.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (code.contains('weak-password')) {
      return 'Password is too weak. Please choose a stronger password (min. 6 characters).';
    } else if (code.contains('network-request-failed')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (code.contains('operation-not-allowed')) {
      return 'Email/password sign-up is not enabled. Please contact support.';
    } else {
      return 'Registration failed: $code';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Create Account', style: theme.textTheme.titleLarge)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Account', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Join your learning journey', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 32),

              // Role selector (prominent, at the top)
              Text('I am a...', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  _roleChip('Student', 'student', Icons.school_outlined),
                  const SizedBox(width: 10),
                  _roleChip('Teacher', 'teacher', Icons.person_outline),
                ],
              ),

              const SizedBox(height: 24),

              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: obscurePass,
                decoration: InputDecoration(
                  hintText: 'Password (min. 6 characters)',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(obscurePass ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => obscurePass = !obscurePass),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: confirmController,
                obscureText: obscureConfirm,
                onSubmitted: (_) => register(),
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  child: isLoading
                      ? const SizedBox(
                          height: 24, width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text('Create ${_roleName()} Account'),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Already have an account? Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _roleName() {
    switch (role) {
      case 'teacher': return 'Teacher';
      default: return 'Student';
    }
  }

  Widget _roleChip(String label, String value, IconData icon) {
    final selected = role == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => role = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? _primary : Colors.grey[100],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? _primary : Colors.grey[300]!,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.grey[600], size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : Colors.grey[700],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}
