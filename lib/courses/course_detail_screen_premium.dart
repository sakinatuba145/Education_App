import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/student/screens/course_player_screen.dart';

class CourseDetailScreenPremium extends StatefulWidget {
  final String courseId;
  const CourseDetailScreenPremium({super.key, required this.courseId});

  @override
  State<CourseDetailScreenPremium> createState() =>
      _CourseDetailScreenPremiumState();
}

class _CourseDetailScreenPremiumState
    extends State<CourseDetailScreenPremium> {
  final TeacherCourseService _courseService = TeacherCourseService();
  final TeacherLessonService _lessonService = TeacherLessonService();
  final EnrollmentService _enrollmentService = EnrollmentService();

  CourseModel? _course;
  List<LessonModel> _lessons = [];
  bool _loading = true;
  bool _isEnrolled = false;
  bool _enrolling = false;
  bool _isExpanded = false;
  bool _isFavorite = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      final course = await _courseService.getCourseById(widget.courseId);
      final lessons = await _lessonService.getCourseLessons(widget.courseId);
      final isEnrolled = await _enrollmentService.isEnrolled(widget.courseId);
      final isFavorite = await _enrollmentService.isFavorite(widget.courseId);
      setState(() {
        _course = course;
        _lessons = lessons;
        _isEnrolled = isEnrolled;
        _isFavorite = isFavorite;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _enroll() async {
    if (_course == null) return;
    setState(() => _enrolling = true);
    try {
      await _enrollmentService.enrollInCourse(course: _course!);
      setState(() {
        _isEnrolled = true;
        _enrolling = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Enrolled successfully!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
        _goToPlayer();
      }
    } catch (e) {
      setState(() => _enrolling = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _goToPlayer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CoursePlayerScreen(courseId: widget.courseId),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    await _enrollmentService.toggleFavorite(widget.courseId);
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Detail')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 60, color: AppColors.error),
              const SizedBox(height: 12),
              const Text('Failed to load course'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final course = _course!;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                course.title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  course.thumbnailUrl != null &&
                          course.thumbnailUrl!.isNotEmpty
                      ? Image.network(
                          course.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _gradientBg(),
                        )
                      : _gradientBg(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall,
                            ),
                            SizedBox(height: AppDimensions.spacing_4),
                            if (course.subtitle.isNotEmpty)
                              Text(
                                course.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            SizedBox(height: AppDimensions.spacing_8),
                            if (course.averageRating > 0)
                              Row(
                                children: [
                                  ...List.generate(
                                    5,
                                    (i) => Icon(
                                      i < course.averageRating.floor()
                                          ? Icons.star
                                          : Icons.star_outline,
                                      color: AppColors.warning,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(
                                      width: AppDimensions.spacing_8),
                                  Text(
                                    '${course.averageRating.toStringAsFixed(1)} (${course.totalReviews} reviews)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing_16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                          context,
                          '${course.totalLessons}',
                          'Lessons'),
                      _buildStatColumn(
                          context,
                          '${course.totalDurationHours.toStringAsFixed(0)}h',
                          'Duration'),
                      _buildStatColumn(
                          context,
                          '${course.totalEnrolled}',
                          'Students'),
                      _buildStatColumn(
                          context,
                          _levelLabel(course.level),
                          'Level'),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing_24),

                  Container(
                    padding: EdgeInsets.all(AppDimensions.spacing_12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radius_large),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight
                              ],
                            ),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.white),
                        ),
                        SizedBox(width: AppDimensions.spacing_12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instructor',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey[500]),
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(course.teacherId)
                                    .get(),
                                builder: (context, snap) {
                                  final name = snap.hasData &&
                                          snap.data!.exists
                                      ? (snap.data!.data()
                                              as Map<String,
                                                  dynamic>)['name'] ??
                                          'Instructor'
                                      : 'Instructor';
                                  return Text(
                                    name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  );
                                },
                              ),
                              if (course.language.isNotEmpty)
                                Text(
                                  course.language,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing_16,
                vertical: AppDimensions.spacing_12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About this course',
                      style:
                          Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: AppDimensions.spacing_12),
                  Text(
                    course.description.isNotEmpty
                        ? course.description
                        : 'No description provided.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  if (!_isExpanded && course.description.length > 120)
                    Padding(
                      padding:
                          EdgeInsets.only(top: AppDimensions.spacing_8),
                      child: AnimatedTextButton(
                        label: 'Read more',
                        onPressed: () =>
                            setState(() => _isExpanded = true),
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (course.prerequisites.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing_16,
                  vertical: AppDimensions.spacing_12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("What you'll learn",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall),
                    SizedBox(height: AppDimensions.spacing_12),
                    ...course.prerequisites.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(
                            bottom: AppDimensions.spacing_8),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.success, size: 20),
                            SizedBox(width: AppDimensions.spacing_12),
                            Expanded(
                              child: Text(item,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_lessons.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing_16,
                  vertical: AppDimensions.spacing_16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Curriculum (${_lessons.length} lessons)',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: AppDimensions.spacing_12),
                    ..._lessons.take(_isEnrolled ? _lessons.length : 3).map(
                      (lesson) => Container(
                        margin: EdgeInsets.only(
                            bottom: AppDimensions.spacing_8),
                        padding:
                            EdgeInsets.all(AppDimensions.spacing_12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radius_medium),
                          border: Border.all(
                              color: AppColors.gray300, width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${lesson.sequenceNumber}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppDimensions.spacing_12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lesson.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall,
                                  ),
                                  if (lesson.totalDuration.inSeconds > 0)
                                    Text(
                                      _fmtDur(lesson.totalDuration),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              _isEnrolled
                                  ? Icons.play_circle_outline
                                  : Icons.lock_outline,
                              color: _isEnrolled
                                  ? AppColors.primary
                                  : AppColors.gray400,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!_isEnrolled && _lessons.length > 3)
                      Padding(
                        padding: EdgeInsets.only(
                            top: AppDimensions.spacing_8),
                        child: Center(
                          child: Text(
                            '+${_lessons.length - 3} more lessons after enrollment',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing_16),
              child: Column(
                children: [
                  if (_isEnrolled) ...[
                    AnimatedElevatedButton(
                      label: 'Continue Learning',
                      onPressed: _goToPlayer,
                      isFullWidth: true,
                      backgroundColor: AppColors.success,
                    ),
                    SizedBox(height: AppDimensions.spacing_8),
                    Text(
                      '✓ You are enrolled in this course',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.success),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    AnimatedElevatedButton(
                      label: _enrolling
                          ? 'Enrolling...'
                          : course.isFree
                              ? 'Enroll for Free'
                              : 'Enroll Now — \$${course.price?.toStringAsFixed(0) ?? '0'}',
                      onPressed: _enrolling ? () {} : _enroll,
                      isFullWidth: true,
                      backgroundColor: AppColors.primary,
                    ),
                    SizedBox(height: AppDimensions.spacing_12),
                    if (course.isFree)
                      Text(
                        'Free forever — no credit card needed',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      )
                    else
                      Text(
                        '30-day money-back guarantee',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _gradientBg() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
      );

  Widget _buildStatColumn(
      BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: AppDimensions.spacing_4),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600])),
      ],
    );
  }

  String _levelLabel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return '🟢 Beginner';
      case 'intermediate':
        return '🟡 Mid';
      case 'advanced':
        return '🔴 Adv';
      default:
        return level.isNotEmpty ? level : 'All';
    }
  }

  String _fmtDur(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return '${d.inMinutes}m';
  }
}
