import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/academy/academy_service.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/login_screen.dart';

const _navy = Color(0xFF0D1B2A);
const _orange = Color(0xFFFFA726);
const _orangeLight = Color(0xFFFFF3E0);
const _cardBg = Color(0xFF1A2D42);

class AcademyDashboardScreen extends StatefulWidget {
  static String id = 'academy_dashboard_screen';
  const AcademyDashboardScreen({super.key});

  @override
  State<AcademyDashboardScreen> createState() => _AcademyDashboardScreenState();
}

class _AcademyDashboardScreenState extends State<AcademyDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AcademyService _service = AcademyService();

  Map<String, dynamic> _stats = {};
  bool _statsLoading = true;

  String get _adminName {
    final raw = FirebaseAuth.instance.currentUser?.displayName ?? 'Academy Admin';
    return raw.contains('|') ? raw.split('|').first : raw;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    setState(() => _statsLoading = true);
    try {
      final stats = await _service.getPlatformStats();
      if (mounted) setState(() { _stats = stats; _statsLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _statsLoading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (mounted) Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(stats: _stats, loading: _statsLoading, onRefresh: _loadStats),
                  _TeachersTab(service: _service),
                  _CoursesTab(service: _service),
                  _AnalyticsTab(stats: _stats, loading: _statsLoading, service: _service),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _navy,
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EduAf Academy',
                    style: TextStyle(color: Colors.white, fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('Welcome, $_adminName',
                    style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: _orange),
            onPressed: _loadStats,
          ),
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundColor: _orange,
              radius: 18,
              child: Text(
                _adminName.isNotEmpty ? _adminName[0].toUpperCase() : 'A',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            color: _cardBg,
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Row(children: [
                  Icon(Icons.logout_rounded, size: 18, color: Colors.white70),
                  SizedBox(width: 8),
                  Text('Logout', style: TextStyle(color: Colors.white70)),
                ]),
                onTap: _logout,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: _cardBg,
      child: TabBar(
        controller: _tabController,
        indicatorColor: _orange,
        indicatorWeight: 3,
        labelColor: _orange,
        unselectedLabelColor: Colors.white38,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(icon: Icon(Icons.dashboard_rounded, size: 18), text: 'Overview'),
          Tab(icon: Icon(Icons.people_rounded, size: 18), text: 'Teachers'),
          Tab(icon: Icon(Icons.menu_book_rounded, size: 18), text: 'Courses'),
          Tab(icon: Icon(Icons.bar_chart_rounded, size: 18), text: 'Analytics'),
        ],
      ),
    );
  }
}

// ─── Overview Tab ─────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool loading;
  final VoidCallback onRefresh;

  const _OverviewTab({
    required this.stats,
    required this.loading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F9),
      child: loading
          ? const Center(child: CircularProgressIndicator(color: _orange))
          : RefreshIndicator(
              color: _orange,
              onRefresh: () async => onRefresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Platform Overview',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.6,
                      children: [
                        _StatCard(
                          label: 'Teachers',
                          value: '${stats['teacherCount'] ?? 0}',
                          icon: Icons.cast_for_education_rounded,
                          color: Colors.blue,
                        ),
                        _StatCard(
                          label: 'Students',
                          value: '${stats['studentCount'] ?? 0}',
                          icon: Icons.school_rounded,
                          color: Colors.green,
                        ),
                        _StatCard(
                          label: 'Total Courses',
                          value: '${stats['totalCourses'] ?? 0}',
                          icon: Icons.menu_book_rounded,
                          color: Colors.purple,
                        ),
                        _StatCard(
                          label: 'Enrollments',
                          value: '${stats['totalEnrollments'] ?? 0}',
                          icon: Icons.how_to_reg_rounded,
                          color: _orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _CourseStatusCard(stats: stats),
                    const SizedBox(height: 16),
                    _QuickLinksCard(),
                  ],
                ),
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.12),
              blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _CourseStatusCard extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _CourseStatusCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final total = stats['totalCourses'] as int? ?? 0;
    final published = stats['publishedCourses'] as int? ?? 0;
    final draft = total - published;
    final pct = total > 0 ? (published / total) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Course Status', style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statusRow('Published', published, Colors.green),
                    const SizedBox(height: 8),
                    _statusRow('Draft', draft, Colors.orange),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: pct,
                      strokeWidth: 8,
                      backgroundColor: Colors.orange.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                    ),
                  ),
                  Text('${(pct * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 14,
                          fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String label, int count, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const Spacer(),
        Text('$count', style: TextStyle(fontSize: 13,
            fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _QuickLinksCard extends StatelessWidget {
  const _QuickLinksCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _cardBg],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 14),
          Row(
            children: [
              _quickAction(Icons.people_rounded, 'View Teachers'),
              const SizedBox(width: 10),
              _quickAction(Icons.menu_book_rounded, 'All Courses'),
              const SizedBox(width: 10),
              _quickAction(Icons.bar_chart_rounded, 'Analytics'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: _orange, size: 22),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 10,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─── Teachers Tab ──────────────────────────────────────────────────────────────

class _TeachersTab extends StatelessWidget {
  final AcademyService service;
  const _TeachersTab({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F9),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: service.streamTeachers(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: _orange));
          }
          final teachers = snap.data ?? [];
          if (teachers.isEmpty) {
            return _emptyState(
                Icons.cast_for_education_outlined, 'No teachers yet',
                'Teachers will appear here once they register.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teachers.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('${teachers.length} Teacher${teachers.length == 1 ? '' : 's'}',
                      style: const TextStyle(fontSize: 16,
                          fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                );
              }
              final t = teachers[i - 1];
              return _TeacherCard(teacher: t);
            },
          );
        },
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  final Map<String, dynamic> teacher;
  const _TeacherCard({required this.teacher});

  @override
  Widget build(BuildContext context) {
    final name = teacher['name'] as String? ?? 'Unknown';
    final email = teacher['email'] as String? ?? '';
    final courses = teacher['courseCount'] as int? ?? 0;
    final students = teacher['totalStudents'] as int? ?? 0;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'T';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: _orange.withValues(alpha: 0.15),
            child: Text(initial,
                style: const TextStyle(color: _orange, fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15,
                    fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                if (email.isNotEmpty)
                  Text(email, style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _miniChip(Icons.menu_book_rounded, '$courses courses', Colors.blue),
              const SizedBox(height: 4),
              _miniChip(Icons.people_rounded, '$students students', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color,
              fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Courses Tab ───────────────────────────────────────────────────────────────

class _CoursesTab extends StatefulWidget {
  final AcademyService service;
  const _CoursesTab({required this.service});

  @override
  State<_CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<_CoursesTab> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F9),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                _filterChip('All', 'all'),
                const SizedBox(width: 8),
                _filterChip('Published', 'published'),
                const SizedBox(width: 8),
                _filterChip('Draft', 'draft'),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: widget.service.streamAllCourses(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: _orange));
                }
                final all = snap.data ?? [];
                final courses = _filter == 'all'
                    ? all
                    : all.where((c) => c['status'] == _filter).toList();

                if (courses.isEmpty) {
                  return _emptyState(Icons.menu_book_outlined,
                      'No ${_filter == 'all' ? '' : _filter} courses',
                      'Courses created by teachers will appear here.');
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: courses.length + 1,
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text('${courses.length} course${courses.length == 1 ? '' : 's'}',
                            style: const TextStyle(fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E))),
                      );
                    }
                    return _CourseCard(course: courses[i - 1]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _orange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? _orange : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey[600],
            )),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final title = course['title'] as String? ?? 'Untitled';
    final subtitle = course['subtitle'] as String? ?? '';
    final status = course['status'] as String? ?? 'draft';
    final enrolled = course['totalEnrolled'] as int? ?? 0;
    final lessons = course['totalLessons'] as int? ?? 0;
    final thumb = course['thumbnailUrl'] as String?;
    final isPublished = status == 'published';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: SizedBox(
              width: 90,
              height: 90,
              child: thumb != null && thumb.isNotEmpty
                  ? Image.network(thumb, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _thumbPlaceholder())
                  : _thumbPlaceholder(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isPublished
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isPublished ? 'Published' : 'Draft',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isPublished
                                ? Colors.green[700]
                                : Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(title,
                      style: const TextStyle(fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.people_outline_rounded,
                          size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 3),
                      Text('$enrolled', style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                      const SizedBox(width: 10),
                      Icon(Icons.play_circle_outline_rounded,
                          size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 3),
                      Text('$lessons lessons',
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbPlaceholder() => Container(
        color: _orange.withValues(alpha: 0.15),
        child: const Center(
          child: Icon(Icons.play_circle_outline_rounded, color: _orange, size: 32),
        ),
      );
}

// ─── Analytics Tab ─────────────────────────────────────────────────────────────

class _AnalyticsTab extends StatefulWidget {
  final Map<String, dynamic> stats;
  final bool loading;
  final AcademyService service;

  const _AnalyticsTab({
    required this.stats,
    required this.loading,
    required this.service,
  });

  @override
  State<_AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<_AnalyticsTab> {
  List<Map<String, dynamic>> _topCourses = [];
  bool _coursesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopCourses();
  }

  Future<void> _loadTopCourses() async {
    try {
      final courses = await widget.service.getTopCourses(limit: 8);
      if (mounted) setState(() { _topCourses = courses; _coursesLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _coursesLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const Center(child: CircularProgressIndicator(color: _orange));
    }

    final teachers = widget.stats['teacherCount'] as int? ?? 0;
    final students = widget.stats['studentCount'] as int? ?? 0;
    final enrolled = widget.stats['totalEnrollments'] as int? ?? 0;
    final courses = widget.stats['totalCourses'] as int? ?? 0;
    final enrollRate = (teachers + students) > 0
        ? (enrolled / (students > 0 ? students : 1) * 100).clamp(0.0, 100.0)
        : 0.0;

    return Container(
      color: const Color(0xFFF4F6F9),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Platform Analytics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 16),
            // Key metrics
            _MetricRow(
              label: 'Student Enrollment Rate',
              value: '${enrollRate.toStringAsFixed(1)}%',
              subtitle: '$enrolled enrollments across $students students',
              color: Colors.blue,
              icon: Icons.trending_up_rounded,
            ),
            const SizedBox(height: 10),
            _MetricRow(
              label: 'Avg Students per Teacher',
              value: teachers > 0
                  ? (students / teachers).toStringAsFixed(1)
                  : '0',
              subtitle: '$students students / $teachers teachers',
              color: Colors.green,
              icon: Icons.people_rounded,
            ),
            const SizedBox(height: 10),
            _MetricRow(
              label: 'Avg Courses per Teacher',
              value: teachers > 0
                  ? (courses / teachers).toStringAsFixed(1)
                  : '0',
              subtitle: '$courses total courses',
              color: Colors.purple,
              icon: Icons.menu_book_rounded,
            ),
            const SizedBox(height: 24),
            const Text('Top Courses by Enrollment',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            if (_coursesLoading)
              const Center(child: CircularProgressIndicator(color: _orange))
            else if (_topCourses.isEmpty)
              _emptyState(Icons.bar_chart_rounded, 'No data yet',
                  'Publish courses to see analytics here.')
            else
              ..._topCourses.asMap().entries.map((e) {
                final idx = e.key;
                final c = e.value;
                final title = c['title'] as String? ?? 'Untitled';
                final count = c['totalEnrolled'] as int? ?? 0;
                final maxCount = _topCourses.isNotEmpty
                    ? (_topCourses.first['totalEnrolled'] as int? ?? 1)
                    : 1;
                final pct = maxCount > 0 ? count / maxCount : 0.0;
                return _EnrollmentBar(
                    rank: idx + 1, title: title, count: count, pct: pct);
              }),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
              color: color)),
        ],
      ),
    );
  }
}

class _EnrollmentBar extends StatelessWidget {
  final int rank;
  final String title;
  final int count;
  final double pct;

  const _EnrollmentBar({
    required this.rank,
    required this.title,
    required this.count,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rank <= 3 ? _orange : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$rank',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: rank <= 3 ? Colors.white : Colors.grey[600],
                  )),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 6,
                    backgroundColor: _orange.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation(_orange),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text('$count',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
                  color: _orange)),
        ],
      ),
    );
  }
}

// ─── Shared Helpers ────────────────────────────────────────────────────────────

Widget _emptyState(IconData icon, String title, String subtitle) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 18,
            fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[400])),
      ],
    ),
  );
}
