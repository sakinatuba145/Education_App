import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/screens/course_creation_screen_premium.dart';
import 'package:education_app/teacher/screens/course_studio_screen.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/login_screen.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/profile/profile_screen.dart';
import 'package:education_app/profile/settings_screen.dart';

const _primary = Color(0xFFFFA726);
const _bg = Color(0xFFFFF8F0);

class TeacherDashboardScreen extends StatefulWidget {
  static String id = 'teacher_dashboard_screen';
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final TeacherCourseService _courseService = TeacherCourseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CourseModel> _allCourses = [];
  bool _isLoading = true;
  String _filter = 'all'; // all | published | draft
  int _selectedTab = 0; // 0=Courses, 1=Profile, 2=Settings

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final teacherId = _auth.currentUser?.uid;
      if (teacherId == null) return;
      final courses = await _courseService.getMyCourses(teacherId: teacherId);
      // Self-heal: fix any published courses stuck with private visibility
      for (final c in courses) {
        if (c.status == 'published' && c.visibility == 'private') {
          _courseService.updateCourse(
              courseId: c.id, data: {'visibility': 'public'});
        }
      }
      if (mounted) setState(() { _allCourses = courses; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String get _teacherName {
    final raw = _auth.currentUser?.displayName ?? 'Instructor';
    return raw.contains('|') ? raw.split('|').first : raw;
  }

  List<CourseModel> get _filtered {
    switch (_filter) {
      case 'published': return _allCourses.where((c) => c.isPublished).toList();
      case 'draft': return _allCourses.where((c) => c.isDraft).toList();
      default: return _allCourses;
    }
  }

  int get _totalStudents => _allCourses.fold(0, (s, c) => s + c.totalEnrolled);
  int get _published => _allCourses.where((c) => c.isPublished).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        selectedItemColor: _primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton.extended(
              onPressed: _openCreateCourse,
              backgroundColor: _primary,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('New Course',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case 1:
        return const ProfileScreen();
      case 2:
        return const SettingsScreen();
      default:
        return Column(
          children: [
            _buildHeader(),
            _buildStatsRow(),
            _buildFilterRow(),
            Expanded(child: _buildCourseList()),
          ],
        );
    }
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                Text(_teacherName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: _primary),
            onPressed: _loadCourses,
          ),
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundColor: _primary,
              radius: 20,
              child: Text(
                _teacherName.isNotEmpty ? _teacherName[0].toUpperCase() : 'T',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Row(children: [
                  Icon(Icons.logout_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('Logout'),
                ]),
                onTap: _logout,
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          _statChip(Icons.menu_book_rounded, '${_allCourses.length}', 'Courses', Colors.blue),
          const SizedBox(width: 10),
          _statChip(Icons.people_rounded, '$_totalStudents', 'Students', Colors.green),
          const SizedBox(width: 10),
          _statChip(Icons.public_rounded, '$_published', 'Published', _primary),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          _filterChip('All', 'all', _allCourses.length),
          const SizedBox(width: 8),
          _filterChip('Published', 'published', _published),
          const SizedBox(width: 8),
          _filterChip('Draft', 'draft',
              _allCourses.where((c) => c.isDraft).length),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value, int count) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _primary));
    }
    if (_allCourses.isEmpty) {
      return _buildEmptyState();
    }
    if (_filtered.isEmpty) {
      return Center(
        child: Text('No ${_filter} courses',
            style: TextStyle(color: Colors.grey[400], fontSize: 16)),
      );
    }
    return RefreshIndicator(
      color: _primary,
      onRefresh: _loadCourses,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _filtered.length,
        itemBuilder: (_, i) => _courseCard(_filtered[i]),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school_outlined, size: 64, color: _primary),
          ),
          const SizedBox(height: 24),
          const Text('No courses yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Tap + New Course to create your first course',
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: _openCreateCourse,
            style: FilledButton.styleFrom(
              backgroundColor: _primary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Your First Course',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _courseCard(CourseModel course) {
    final isPublished = course.isPublished;
    return GestureDetector(
      onTap: () => _openCourseStudio(course),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty
                  ? Image.network(course.thumbnailUrl!, height: 130,
                      width: double.infinity, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _thumb())
                  : _thumb(),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPublished
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isPublished ? 'Published' : 'Draft',
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600,
                            color: isPublished ? Colors.green[700] : Colors.orange[700],
                          ),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            child: const Row(children: [
                              Icon(Icons.edit_rounded, size: 18),
                              SizedBox(width: 8), Text('Open Studio'),
                            ]),
                            onTap: () => _openCourseStudio(course),
                          ),
                          if (course.isDraft)
                            PopupMenuItem(
                              child: const Row(children: [
                                Icon(Icons.public_rounded, size: 18, color: Colors.green),
                                SizedBox(width: 8), Text('Publish'),
                              ]),
                              onTap: () => _publishCourse(course),
                            ),
                          if (course.isPublished)
                            PopupMenuItem(
                              child: const Row(children: [
                                Icon(Icons.public_off_rounded, size: 18, color: Colors.orange),
                                SizedBox(width: 8), Text('Unpublish'),
                              ]),
                              onTap: () => _unpublishCourse(course),
                            ),
                          PopupMenuItem(
                            child: const Row(children: [
                              Icon(Icons.archive_outlined, size: 18, color: Colors.red),
                              SizedBox(width: 8), Text('Archive', style: TextStyle(color: Colors.red)),
                            ]),
                            onTap: () => _archiveCourse(course),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(course.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (course.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(course.subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _courseChip(Icons.people_outline_rounded,
                          '${course.totalEnrolled}', Colors.blue),
                      const SizedBox(width: 10),
                      _courseChip(Icons.video_library_outlined,
                          '${course.totalLessons} lessons', Colors.purple),
                      const Spacer(),
                      Text(
                        course.isFree ? 'Free' : '\$${course.price?.toStringAsFixed(0) ?? '0'}',
                        style: const TextStyle(fontSize: 14,
                            fontWeight: FontWeight.bold, color: _primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Open Studio button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openCourseStudio(course),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.edit_rounded, size: 16, color: _primary),
                      label: const Text('Open Course Studio',
                          style: TextStyle(color: _primary,
                              fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumb() => Container(
    height: 130, width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [_primary.withValues(alpha: 0.4), _primary.withValues(alpha: 0.7)],
      ),
    ),
    child: const Icon(Icons.play_circle_outline_rounded, size: 44, color: Colors.white),
  );

  Widget _courseChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  void _openCreateCourse() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const CourseCreationScreenPremium()))
        .then((_) => _loadCourses());
  }

  void _openCourseStudio(CourseModel course) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => CourseStudioScreen(courseId: course.id)))
        .then((_) => _loadCourses());
  }

  Future<void> _publishCourse(CourseModel course) async {
    try {
      await _courseService.updateCourse(
          courseId: course.id,
          data: {'status': 'published', 'visibility': 'public'});
      _loadCourses();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course published!'),
              backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
  }

  Future<void> _unpublishCourse(CourseModel course) async {
    try {
      await _courseService.updateCourse(
          courseId: course.id, data: {'status': 'draft'});
      _loadCourses();
    } catch (_) {}
  }

  Future<void> _archiveCourse(CourseModel course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Archive Course'),
        content: const Text('This will hide the course from students.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _courseService.archiveCourse(course.id);
      _loadCourses();
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (mounted) Navigator.pushReplacementNamed(context, LoginScreen.id);
  }
}
