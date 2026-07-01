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
  String _selectedRole = 'student';
  final AuthService _authService = AuthService();

  static const _primary = Color(0xFFFFA726);
  static const _bg = Color(0xFFFFF3E0);

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

      final storedRole = result?['role'] as String? ?? 'unknown';
      final roleIsExplicit = result?['roleIsExplicit'] as bool? ?? false;

      // ── Strict role enforcement ─────────────────────────────────────────
      if (roleIsExplicit && storedRole != _selectedRole) {
        // Role mismatch — block login
        final storedLabel = _roleLabel(storedRole);
        final selectedLabel = _roleLabel(_selectedRole);
        _showRoleMismatchError(
          selected: selectedLabel,
          actual: storedLabel,
        );
        return;
      }

      // No role ever stored (old account created before role-saving was added)
      // → trust the user's selection and save it permanently
      if (!roleIsExplicit) {
        await _authService.saveRoleFirstTime(_selectedRole);
      }

      if (!mounted) return;

      // Route to correct module
      _navigateByRole(roleIsExplicit ? storedRole : _selectedRole);
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

  void _navigateByRole(String role) {
    switch (role) {
      case 'teacher':
        Navigator.pushReplacementNamed(context, TeacherDashboardScreen.id);
        break;
      default:
        Navigator.pushReplacementNamed(context, DashboardScreen.id);
    }
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'teacher': return 'Teacher';
      case 'student': return 'Student';
      default: return role;
    }
  }

  void _showRoleMismatchError({required String selected, required String actual}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.block, color: Colors.red),
            SizedBox(width: 8),
            Text('Wrong Role Selected'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This account is registered as a $actual.',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You selected "$selected" — please select "$actual" and try again.',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Auto-select the correct role for convenience
              setState(() => _selectedRole = actual.toLowerCase());
            },
            child: Text('Switch to $actual'),
          ),
        ],
      ),
    );
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
                Text('Login to continue your journey.', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 32),

                // ── Role selector ──────────────────────────────────────────
                Text('Login as...', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Must match your account type', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _primary.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      _roleTab('student', Icons.school_outlined, 'Student'),
                      _roleTab('teacher', Icons.cast_for_education_outlined, 'Teacher'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Email ──────────────────────────────────────────────────
                Text('Email', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 20),
                Text('Password', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePass,
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

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, ForgotPasswordScreen.id),
                    child: const Text('Forgot Password?'),
                  ),
                ),

                const SizedBox(height: 20),
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
                        : Text('Login as ${_roleLabel(_selectedRole)}'),
                  ),
                ),

                const SizedBox(height: 28),
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

  Widget _roleTab(String role, IconData icon, String label) {
    final selected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? _primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.grey, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  )),
            ],
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
