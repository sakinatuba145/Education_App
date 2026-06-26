import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/teacher/screens/course_creation_screen.dart';
import 'package:education_app/teacher/screens/course_editor_screen.dart';
import 'package:education_app/teacher/screens/course_creation_screen_premium.dart';
import 'package:education_app/teacher/screens/lesson_management_screen_premium.dart';
import 'package:education_app/teacher/screens/content_upload_screen_premium.dart';
import 'package:education_app/teacher/screens/student_submissions_screen.dart';
import 'package:education_app/teacher/screens/quiz_results_screen.dart';
import 'package:education_app/teacher/screens/quiz_builder_screen.dart';
import 'package:education_app/features/auth_services.dart';
import 'package:education_app/features/login_screen.dart';
import 'package:education_app/core/constants/app_colors.dart';

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
  late TabController _courseTabController;
  final TeacherCourseService _courseService = TeacherCourseService();
  final TeacherLessonService _lessonService = TeacherLessonService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _portalIndex = 0;

  List<CourseModel> _allCourses = [];
  bool _isLoading = true;
  CourseModel? _quizSelectedCourse;

  @override
  void initState() {
    super.initState();
    _courseTabController = TabController(length: 3, vsync: this);
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

  String get _teacherName {
    final raw = _auth.currentUser?.displayName ?? 'Instructor';
    return raw.contains('|') ? raw.split('|').first : raw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      // ── Show home AppBar only on Tab 0; premium screens carry their own ─
      appBar: _portalIndex == 0 ? _buildHomeAppBar() : null,

      // ── Portal body via IndexedStack ────────────────────────────────────
      body: IndexedStack(
        index: _portalIndex,
        children: [
          // Tab 0 — My Courses
          _buildCoursesTab(),
          // Tab 1 — Create Course (premium multi-step)
          const CourseCreationScreenPremium(),
          // Tab 2 — Lesson Management: pick a course first
          _buildLessonManagementTab(),
          // Tab 3 — Content Upload (premium drag-drop)
          const ContentUploadScreenPremium(),
          // Tab 4 — Quiz Builder (course → lesson → QuizBuilderScreen)
          _buildQuizBuilderTab(),
        ],
      ),

      // ── Bottom Navigation ───────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _portalIndex,
        onTap: (i) => setState(() => _portalIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        backgroundColor: Colors.white,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'My Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_play_rounded), label: 'Lessons'),
          BottomNavigationBarItem(icon: Icon(Icons.upload_rounded), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz_outlined), label: 'Quiz'),
        ],
      ),

      // ── FAB only on courses tab ─────────────────────────────────────────
      floatingActionButton: _portalIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _createCourse,
              backgroundColor: _primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('New Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  // ── Home AppBar ─────────────────────────────────────────────────────────
  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back,', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(_teacherName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.refresh, color: _primary), onPressed: _loadCourses),
        PopupMenuButton(
          icon: CircleAvatar(
            backgroundColor: _primary,
            radius: 18,
            child: Text(
              _teacherName.isNotEmpty ? _teacherName[0].toUpperCase() : 'T',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: const Row(children: [Icon(Icons.logout, size: 18), SizedBox(width: 8), Text('Logout')]),
              onTap: _logout,
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (mounted) Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  // ── Courses Tab ─────────────────────────────────────────────────────────
  Widget _buildCoursesTab() {
    return RefreshIndicator(
      color: _primary,
      onRefresh: _loadCourses,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildStatsRow()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: const Text('My Courses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          SliverToBoxAdapter(
            child: TabBar(
              controller: _courseTabController,
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
                    controller: _courseTabController,
                    children: [
                      _buildCourseList(_allCourses),
                      _buildCourseList(_published),
                      _buildCourseList(_drafts),
                    ],
                  ),
          ),
        ],
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
                          PopupMenuItem(
                            child: const Row(children: [Icon(Icons.video_library, size: 18), SizedBox(width: 8), Text('Manage Lessons')]),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LessonManagementScreenPremium(courseId: course.id),
                              ),
                            ).then((_) => _loadCourses()),
                          ),
                          PopupMenuItem(
                            child: const Row(children: [Icon(Icons.people, size: 18, color: Colors.blue), SizedBox(width: 8), Text('Students')]),
                            onTap: () => Future.delayed(Duration.zero, () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentSubmissionsScreen(
                                  courseId: course.id,
                                  courseTitle: course.title,
                                ),
                              ),
                            )),
                          ),
                          PopupMenuItem(
                            child: const Row(children: [Icon(Icons.quiz, size: 18, color: Colors.purple), SizedBox(width: 8), Text('Quiz Results')]),
                            onTap: () => Future.delayed(Duration.zero, () => _showCourseQuizResults(course)),
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

  // ── Tab 2: Lesson Management — pick a course first ──────────────────────
  Widget _buildLessonManagementTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _primary));
    }
    if (_allCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No courses yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text('Create a course first, then manage its lessons here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Select a course to manage lessons',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _allCourses.length,
            itemBuilder: (_, i) {
              final course = _allCourses[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.video_library, color: _primary),
                  ),
                  title: Text(course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    '${course.totalLessons} lessons • ${course.status}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Manage', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonManagementScreenPremium(courseId: course.id),
                    ),
                  ).then((_) => _loadCourses()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Tab 4: Quiz Builder — two-step: pick course → pick lesson ───────────
  Widget _buildQuizBuilderTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _primary));
    }
    if (_allCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No courses yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text('Create a course first, then build quizzes for its lessons.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          ],
        ),
      );
    }

    if (_quizSelectedCourse == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Select a course to build quizzes',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _allCourses.length,
              itemBuilder: (_, i) {
                final course = _allCourses[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.quiz_outlined, color: _primary),
                    ),
                    title: Text(course.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      '${course.totalLessons} lessons • ${course.status}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Select',
                          style: TextStyle(color: _primary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    onTap: () => setState(() => _quizSelectedCourse = course),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // Step 2: pick a lesson within the selected course
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _quizSelectedCourse = null),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quiz Builder',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(_quizSelectedCourse!.title,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text('Pick a lesson to edit its quiz',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
        ),
        Expanded(
          child: FutureBuilder<List<LessonModel>>(
            future: _lessonService.getCourseLessons(_quizSelectedCourse!.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: _primary));
              }
              final lessons = snapshot.data ?? [];
              if (lessons.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library_outlined, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text('No lessons yet', style: TextStyle(color: Colors.grey[500])),
                      const SizedBox(height: 8),
                      Text('Add lessons to this course first.',
                          style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: lessons.length,
                itemBuilder: (_, i) {
                  final lesson = lessons[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: CircleAvatar(
                        backgroundColor: _primary.withValues(alpha: 0.1),
                        child: Text(
                          '${lesson.sequenceNumber}',
                          style: const TextStyle(
                              color: _primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(lesson.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      subtitle: lesson.description.isNotEmpty
                          ? Text(lesson.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]))
                          : null,
                      trailing: const Icon(Icons.quiz_outlined, color: _primary),
                      onTap: () => _showLessonQuizSheet(
                        _quizSelectedCourse!.id,
                        lesson.id,
                        lesson.title,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Quiz Results: load quizzes for course, pick one ─────────────────────
  void _showCourseQuizResults(CourseModel course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CourseQuizPickerSheet(course: course),
    );
  }

  // ── Show quizzes for a lesson; create new or open existing ───────────────
  void _showLessonQuizSheet(String courseId, String lessonId, String lessonTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _LessonQuizPickerSheet(
        courseId: courseId,
        lessonId: lessonId,
        lessonTitle: lessonTitle,
      ),
    );
  }

  @override
  void dispose() {
    _courseTabController.dispose();
    super.dispose();
  }
}

// ── Quiz picker: lists all quizzes for a course ───────────────────────────
class _CourseQuizPickerSheet extends StatefulWidget {
  final CourseModel course;
  const _CourseQuizPickerSheet({required this.course});

  @override
  State<_CourseQuizPickerSheet> createState() => _CourseQuizPickerSheetState();
}

class _CourseQuizPickerSheetState extends State<_CourseQuizPickerSheet> {
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _quizzes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final snap = await _firestore
          .collectionGroup('quizzes')
          .where('courseId', isEqualTo: widget.course.id)
          .get();
      setState(() {
        _quizzes = snap.docs
            .map((d) => {'id': d.id, ...d.data()})
            .toList();
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.quiz, color: _primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Quizzes — ${widget.course.title}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : _quizzes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.quiz_outlined, size: 48, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text('No quizzes found for this course',
                                style: TextStyle(color: Colors.grey[500])),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _quizzes.length,
                        itemBuilder: (_, i) {
                          final quiz = _quizzes[i];
                          final title = quiz['title'] as String? ?? 'Quiz ${i + 1}';
                          final qCount = (quiz['questions'] as List?)?.length ?? 0;
                          return ListTile(
                            leading: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.quiz, color: Colors.purple, size: 20),
                            ),
                            title: Text(title,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('$qCount question${qCount == 1 ? '' : 's'}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuizResultsScreen(
                                    quizId: quiz['id'] as String,
                                    quizTitle: title,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// ── Lesson Quiz Picker: list/create quizzes for a lesson ─────────────────
class _LessonQuizPickerSheet extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String lessonTitle;
  const _LessonQuizPickerSheet({
    required this.courseId,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  State<_LessonQuizPickerSheet> createState() => _LessonQuizPickerSheetState();
}

class _LessonQuizPickerSheetState extends State<_LessonQuizPickerSheet> {
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _quizzes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final snap = await _firestore
          .collection('courses')
          .doc(widget.courseId)
          .collection('lessons')
          .doc(widget.lessonId)
          .collection('quizzes')
          .get();
      setState(() {
        _quizzes = snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _createNewQuiz() async {
    final titleCtrl = TextEditingController(text: '${widget.lessonTitle} Quiz');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Quiz'),
        content: TextField(
          controller: titleCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Quiz Title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: _primary, foregroundColor: Colors.white),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (confirmed == true && titleCtrl.text.trim().isNotEmpty && mounted) {
      final newRef = _firestore
          .collection('courses')
          .doc(widget.courseId)
          .collection('lessons')
          .doc(widget.lessonId)
          .collection('quizzes')
          .doc();
      final quizId = newRef.id;
      final title = titleCtrl.text.trim();
      await newRef.set({
        'id': quizId,
        'title': title,
        'courseId': widget.courseId,
        'lessonId': widget.lessonId,
        'questions': [],
        'passingScore': 70,
        'shuffleQuestions': false,
        'showAnswersOption': 'immediately',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizBuilderScreen(
              courseId: widget.courseId,
              lessonId: widget.lessonId,
              quizId: quizId,
              quizTitle: title,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.quiz_outlined, color: _primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quizzes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(widget.lessonTitle,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _createNewQuiz,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('New Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _primary))
                : _quizzes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.quiz_outlined, size: 48, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text('No quizzes yet',
                                style: TextStyle(color: Colors.grey[500])),
                            const SizedBox(height: 8),
                            Text('Tap "New Quiz" to create one.',
                                style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _quizzes.length,
                        itemBuilder: (_, i) {
                          final quiz = _quizzes[i];
                          final title = quiz['title'] as String? ?? 'Quiz ${i + 1}';
                          final qCount = (quiz['questions'] as List?)?.length ?? 0;
                          return ListTile(
                            leading: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: _primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.quiz_outlined, color: _primary, size: 20),
                            ),
                            title: Text(title,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('$qCount question${qCount == 1 ? '' : 's'}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            trailing: const Icon(Icons.edit_outlined, color: _primary),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuizBuilderScreen(
                                    courseId: widget.courseId,
                                    lessonId: widget.lessonId,
                                    quizId: quiz['id'] as String,
                                    quizTitle: title,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
