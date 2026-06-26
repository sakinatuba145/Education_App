import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/screens/course_creation_screen_premium.dart';
import 'package:education_app/teacher/screens/course_editor_screen.dart';
import 'package:education_app/teacher/screens/lesson_management_screen_premium.dart';
import 'package:education_app/teacher/screens/student_submissions_screen.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';

class TeacherDashboardScreenPremium extends StatefulWidget {
  const TeacherDashboardScreenPremium({super.key});

  @override
  State<TeacherDashboardScreenPremium> createState() =>
      _TeacherDashboardScreenPremiumState();
}

class _TeacherDashboardScreenPremiumState
    extends State<TeacherDashboardScreenPremium> with TickerProviderStateMixin {
  late TabController _tabController;
  final TeacherCourseService _courseService = TeacherCourseService();

  List<CourseModel> _allCourses = [];
  bool _loading = true;

  int _activeCourses = 0;
  int _totalStudents = 0;
  double _avgRating = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCourses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() => _loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final courses = await _courseService.getMyCourses(teacherId: uid);
      int students = 0;
      double totalRating = 0;
      int ratedCount = 0;
      int active = 0;
      for (final c in courses) {
        students += c.totalEnrolled;
        if (c.averageRating > 0) {
          totalRating += c.averageRating;
          ratedCount++;
        }
        if (c.status == 'published') active++;
      }
      setState(() {
        _allCourses = courses;
        _activeCourses = active;
        _totalStudents = students;
        _avgRating = ratedCount > 0 ? totalRating / ratedCount : 0;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  List<CourseModel> _byStatus(String status) =>
      _allCourses.where((c) => c.status == status).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: RefreshIndicator(
        onRefresh: _loadCourses,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.lightSurface,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('My Courses'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _loadCourses,
                ),
              ],
            ),

            // Stats row
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spacing_16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Stats',
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: AppDimensions.spacing_16),
                    _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ))
                        : Row(
                            children: [
                              Expanded(
                                child: _statCard(
                                  context,
                                  'Active Courses',
                                  '$_activeCourses',
                                  Icons.school,
                                  AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _statCard(
                                  context,
                                  'Total Students',
                                  '$_totalStudents',
                                  Icons.people,
                                  AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _statCard(
                                  context,
                                  'Avg Rating',
                                  _avgRating > 0
                                      ? _avgRating.toStringAsFixed(1)
                                      : '—',
                                  Icons.star,
                                  AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),

            // Tab bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing_16,
                  vertical: AppDimensions.spacing_8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radius_large),
                    color: AppColors.gray100,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius_large),
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.gray600,
                    tabs: [
                      Tab(
                          text:
                              'Active (${_byStatus('published').length})'),
                      Tab(
                          text:
                              'Draft (${_byStatus('draft').length})'),
                      Tab(
                          text:
                              'Archived (${_byStatus('archived').length})'),
                    ],
                  ),
                ),
              ),
            ),

            // Tab content
            SliverFillRemaining(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCourseList(_byStatus('published')),
                        _buildCourseList(_byStatus('draft')),
                        _buildCourseList(_byStatus('archived')),
                      ],
                    ),
            ),
          ],
        ),
      ),

      // FAB — create new course
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CourseCreationScreenPremium(),
            ),
          ).then((_) => _loadCourses()),
          child: const Icon(Icons.add, color: Colors.white),
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
            Text(
              'No courses here',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create a new course',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.spacing_16),
      itemCount: courses.length,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsets.only(bottom: AppDimensions.spacing_12),
        child: _buildCourseCard(courses[i]),
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course) {
    final isPublished = course.status == 'published';
    final isDraft = course.status == 'draft';
    final statusColor = isPublished
        ? AppColors.success
        : isDraft
            ? AppColors.warning
            : AppColors.gray500;

    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing_12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius_large),
        border: Border.all(color: AppColors.gray200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail / placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: course.thumbnailUrl != null &&
                        course.thumbnailUrl!.isNotEmpty
                    ? Image.network(
                        course.thumbnailUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _thumbPlaceholder(),
                      )
                    : _thumbPlaceholder(),
              ),
              SizedBox(width: AppDimensions.spacing_12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${course.totalEnrolled} students • ${course.totalLessons} lessons',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing_8,
                  vertical: AppDimensions.spacing_4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  course.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          // Progress bar for published courses
          if (isPublished && course.totalEnrolled > 0) ...[
            SizedBox(height: AppDimensions.spacing_12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Avg completion',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${course.totalLessons > 0 ? ((course.totalCompleted / (course.totalEnrolled * course.totalLessons.clamp(1, 9999))) * 100).clamp(0, 100).toStringAsFixed(0) : 0}%',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacing_8),
            LinearProgressAnimated(
              value: course.totalLessons > 0
                  ? (course.totalCompleted /
                          (course.totalEnrolled * course.totalLessons)
                              .clamp(1, 9999))
                      .clamp(0.0, 1.0)
                  : 0.0,
              height: 6,
              showLabel: false,
            ),
            SizedBox(height: AppDimensions.spacing_8),
          ],

          SizedBox(height: AppDimensions.spacing_12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CourseEditorScreen(courseId: course.id),
                    ),
                  ).then((_) => _loadCourses()),
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonManagementScreenPremium(
                          courseId: course.id),
                    ),
                  ),
                  icon: const Icon(Icons.video_library, size: 14),
                  label: const Text('Lessons'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudentSubmissionsScreen(
                        courseId: course.id,
                        courseTitle: course.title,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.people, size: 14),
                  label: const Text('Students'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thumbPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primaryLight.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: const Icon(Icons.video_library, color: AppColors.primary),
    );
  }

  Widget _statCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacing_12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radius_large),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(height: AppDimensions.spacing_8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.gray600),
          ),
        ],
      ),
    );
  }
}
