import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/login_screen.dart';
import 'package:education_app/teacher/screens/teacher_dashboard_screen.dart';
import 'package:education_app/academy/services/academy_service.dart';
import 'package:education_app/academy/screens/academy_teachers_screen.dart';
import 'package:education_app/academy/screens/academy_courses_screen.dart';
import 'package:education_app/academy/screens/academy_analytics_screen.dart';

class AcademyDashboardScreen extends StatefulWidget {
  static const String id = 'academy_dashboard_screen';
  const AcademyDashboardScreen({super.key});

  @override
  State<AcademyDashboardScreen> createState() => _AcademyDashboardScreenState();
}

class _AcademyDashboardScreenState extends State<AcademyDashboardScreen> {
  static const _primary = Color(0xFFFFA726);
  static const _bg = Color(0xFFFFF3E0);

  final _auth = AuthService();
  final _academyService = AcademyService();
  final User? _user = FirebaseAuth.instance.currentUser;

  AcademyStats? _stats;
  bool _loadingStats = true;

  String get _name {
    final raw = _user?.displayName ?? '';
    if (raw.contains('|')) return raw.split('|').first;
    return raw.isNotEmpty ? raw : 'Academy';
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _loadingStats = true);
    final stats = await _academyService.getAcademyStats();
    setState(() {
      _stats = stats;
      _loadingStats = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: _primary, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.business, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text('Academy Hub',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await _auth.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFF8F00)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $_name 🏢',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Manage your academy, teachers, and courses from here.',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  _statCard(
                    'Teachers',
                    _loadingStats ? '—' : '${_stats?.totalTeachers ?? 0}',
                    Icons.people_outline,
                    Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    'Courses',
                    _loadingStats ? '—' : '${_stats?.totalCourses ?? 0}',
                    Icons.menu_book_outlined,
                    Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    'Students',
                    _loadingStats ? '—' : '${_stats?.totalStudents ?? 0}',
                    Icons.school_outlined,
                    Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Text(
                'Academy Tools',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.2,
                children: [
                  _actionCard(
                    icon: Icons.add_circle_outline,
                    label: 'Create Course',
                    color: _primary,
                    onTap: () => Navigator.pushNamed(
                        context, TeacherDashboardScreen.id),
                  ),
                  _actionCard(
                    icon: Icons.people_alt_outlined,
                    label: 'Manage Teachers',
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AcademyTeachersScreen()),
                    ),
                  ),
                  _actionCard(
                    icon: Icons.bar_chart_rounded,
                    label: 'Analytics',
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AcademyAnalyticsScreen()),
                    ),
                  ),
                  _actionCard(
                    icon: Icons.library_books_outlined,
                    label: 'All Courses',
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AcademyCoursesScreen()),
                    ),
                  ),
                  _actionCard(
                    icon: Icons.payment_outlined,
                    label: 'Revenue',
                    color: Colors.teal,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AcademyAnalyticsScreen()),
                    ),
                  ),
                  _actionCard(
                    icon: Icons.notifications_outlined,
                    label: 'Announcements',
                    color: Colors.orange,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Announcements — coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    ),
                  ),
                ],
              ),

              if (!_loadingStats && (_stats?.totalRevenue ?? 0) > 0) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Revenue',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        '\$${(_stats!.totalRevenue).toStringAsFixed(2)}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06), blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
