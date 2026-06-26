import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/screens/course_creation_screen.dart';
import 'package:education_app/teacher/screens/course_editor_screen.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/welcome_screen.dart';

const _primary = Color(0xFFFFA726);
const _bg = Color(0xFFFFF3E0);

class TeacherDashboardScreen extends StatefulWidget {
  static String id = 'teacher_dashboard_screen';
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TeacherCourseService _courseService = TeacherCourseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CourseModel> _allCourses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final teacherId = _auth.currentUser?.uid;
      if (teacherId == null) return;
      final courses = await _courseService.getMyCourses(teacherId: teacherId);
      if (mounted) setState(() { _allCourses = courses; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<CourseModel> get _published => _allCourses.where((c) => c.isPublished).toList();
  List<CourseModel> get _drafts => _allCourses.where((c) => c.isDraft).toList();

  int get _totalStudents => _allCourses.fold(0, (s, c) => s + c.totalEnrolled);

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final name = user?.displayName ?? 'Instructor';

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: _primary),
            onPressed: _loadCourses,
          ),
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundColor: _primary,
              radius: 18,
              child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'T',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Row(children: [Icon(Icons.logout, size: 18), SizedBox(width: 8), Text('Logout')]),
                onTap: () async {
                  await AuthService().logout();
                  if (mounted) Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: _primary,
        onRefresh: _loadCourses,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildStatsRow()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text('My Courses', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            SliverToBoxAdapter(
              child: TabBar(
                controller: _tabController,
                labelColor: _primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: _primary,
                tabs: [
                  Tab(text: 'All (${_allCourses.length})'),
                  Tab(text: 'Published (${_published.length})'),
                  Tab(text: 'Draft (${_drafts.length})'),
                ],
              ),
            ),
            SliverFillRemaining(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: _primary))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCourseList(_allCourses),
                        _buildCourseList(_published),
                        _buildCourseList(_drafts),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createCourse,
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _statCard('Courses', '${_allCourses.length}', Icons.menu_book),
          const SizedBox(width: 12),
          _statCard('Students', '$_totalStudents', Icons.people),
          const SizedBox(width: 12),
          _statCard('Published', '${_published.length}', Icons.public),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: _primary, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(List<CourseModel> courses) {
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No courses yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text('Tap + New Course to get started', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (_, i) => _courseCard(courses[i]),
    );
  }

  Widget _courseCard(CourseModel course) {
    final isPublished = course.isPublished;
    return GestureDetector(
      onTap: () => _openCourse(course),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(course.thumbnailUrl!, height: 140, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _thumbnailPlaceholder()),
              )
            else
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: _thumbnailPlaceholder(),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPublished ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(isPublished ? 'Published' : 'Draft',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                                color: isPublished ? Colors.green[700] : Colors.orange[700])),
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            child: const Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')]),
                            onTap: () => _openCourse(course),
                          ),
                          if (course.isDraft)
                            PopupMenuItem(
                              child: const Row(children: [Icon(Icons.public, size: 18, color: Colors.green), SizedBox(width: 8), Text('Publish')]),
                              onTap: () => _publishCourse(course),
                            ),
                          PopupMenuItem(
                            child: const Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text('Archive', style: TextStyle(color: Colors.red))]),
                            onTap: () => _archiveCourse(course),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(course.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(course.subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('${course.totalEnrolled} students', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(width: 16),
                      Icon(Icons.video_library_outlined, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('${course.totalLessons} lessons', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const Spacer(),
                      Text(course.isFree ? 'Free' : '\$${course.price?.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _primary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      height: 140, width: double.infinity,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [_primary.withValues(alpha: 0.3), _primary.withValues(alpha: 0.6)])),
      child: const Icon(Icons.play_circle_outline, size: 48, color: Colors.white),
    );
  }

  void _createCourse() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseCreationScreen()))
        .then((_) => _loadCourses());
  }

  void _openCourse(CourseModel course) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CourseEditorScreen(courseId: course.id)))
        .then((_) => _loadCourses());
  }

  void _publishCourse(CourseModel course) async {
    try {
      await _courseService.publishCourse(course.id);
      _loadCourses();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course published!')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _archiveCourse(CourseModel course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Archive Course'),
        content: const Text('Are you sure? The course will be hidden from students.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Archive', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await _courseService.archiveCourse(course.id);
      _loadCourses();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
