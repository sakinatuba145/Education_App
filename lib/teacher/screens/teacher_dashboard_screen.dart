import 'package:flutter/material.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/widgets/course_card_widget.dart';
import 'package:education_app/teacher/constants/teacher_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherDashboardScreen extends StatefulWidget {
  static String id='teacher_dashboard_screen';

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TeacherCourseService _courseService = TeacherCourseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CourseModel> _activeCourses = [];
  List<CourseModel> _draftCourses = [];
  List<CourseModel> _archivedCourses = [];

  bool _isLoading = false;

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
      if (teacherId == null) throw Exception('User not authenticated');

      final active = await _courseService.getMyCourses(
        teacherId: teacherId,
        status: 'published',
      );

      final drafts = await _courseService.getMyCourses(
        teacherId: teacherId,
        status: 'draft',
      );

      final archived = await _courseService.getMyCourses(
        teacherId: teacherId,
        status: 'archived',
      );

      if (mounted) {
        setState(() {
          _activeCourses = active;
          _draftCourses = drafts;
          _archivedCourses = archived;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading courses: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Profile/Settings
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          TabBar(
            controller: _tabController,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: '${TeacherStrings.activeCourses} (${_activeCourses.length})'),
              Tab(text: '${TeacherStrings.draftCourses} (${_draftCourses.length})'),
              Tab(text: '${TeacherStrings.archivedCourses} (${_archivedCourses.length})'),
            ],
          ),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCoursesList(_activeCourses),
                      _buildCoursesList(_draftCourses),
                      _buildCoursesList(_archivedCourses),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewCourse,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCoursesList(List<CourseModel> courses) {
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              TeacherStrings.noCoursesYet,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return CourseCardWidget(
          course: course,
          onTap: () {
            // Navigate to course editor
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Open course: ${course.title}')),
            );
          },
          onEdit: () {
            // Edit course
          },
          onDelete: () {
            _showDeleteConfirmation(course);
          },
          onPublish: course.isDraft ? () {
            _publishCourse(course);
          } : null,
        );
      },
    );
  }

  void _createNewCourse() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to course creation screen')),
    );
  }

  void _publishCourse(CourseModel course) async {
    try {
      await _courseService.publishCourse(course.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course published successfully!')),
        );
        _loadCourses();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _showDeleteConfirmation(CourseModel course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: const Text(
          'Are you sure you want to delete this course? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCourse(course);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteCourse(CourseModel course) async {
    try {
      await _courseService.archiveCourse(course.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course archived successfully!')),
        );
        _loadCourses();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
