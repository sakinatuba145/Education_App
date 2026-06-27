import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/core/constants/app_colors.dart';
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
  bool _descExpanded = false;
  bool _isFavorite = false;
  String? _error;

  static const Map<String, List<Color>> _catColors = {
    'Programming':        [Color(0xFF6C63FF), Color(0xFF3F3D8F)],
    'Web Development':    [Color(0xFF00B4D8), Color(0xFF0077B6)],
    'Mobile Development': [Color(0xFF06D6A0), Color(0xFF028090)],
    'Data Science':       [Color(0xFFEF476F), Color(0xFFB5179E)],
    'Design':             [Color(0xFFFFB703), Color(0xFFFB8500)],
    'Business':           [Color(0xFF4CC9F0), Color(0xFF4361EE)],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        _courseService.getCourseById(widget.courseId),
        _lessonService.getCourseLessons(widget.courseId),
        _enrollmentService.isEnrolled(widget.courseId),
        _enrollmentService.isFavorite(widget.courseId),
      ]);
      if (mounted) {
        setState(() {
          _course     = results[0] as CourseModel;
          _lessons    = results[1] as List<LessonModel>;
          _isEnrolled = results[2] as bool;
          _isFavorite = results[3] as bool;
          _loading    = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _error = e.toString(); _loading = false; });
      }
    }
  }

  Future<void> _enroll() async {
    if (_course == null) return;
    setState(() => _enrolling = true);
    try {
      await _enrollmentService.enrollInCourse(course: _course!);
      if (mounted) {
        setState(() { _isEnrolled = true; _enrolling = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Enrolled successfully!'),
            ]),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
        _goToPlayer();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _enrolling = false);
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
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => CoursePlayerScreen(courseId: widget.courseId)));
  }

  Future<void> _toggleFavorite() async {
    await _enrollmentService.toggleFavorite(widget.courseId);
    if (mounted) setState(() => _isFavorite = !_isFavorite);
  }

  List<Color> _heroColors(CourseModel c) =>
      _catColors[c.category] ?? [AppColors.primary, AppColors.primaryDark];

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text('Loading course…',
                  style: TextStyle(color: AppColors.gray500)),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          title: const Text('Course Details'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 60, color: AppColors.error),
                const SizedBox(height: 16),
                const Text('Failed to load course',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.gray500, fontSize: 13)),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final course = _course!;
    final colors = _heroColors(course);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          // ── Scrollable content ───────────────────────────────────────────
          CustomScrollView(
            slivers: [
              // ── Hero ────────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                elevation: 0,
                backgroundColor: colors.first,
                foregroundColor: Colors.white,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 16, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: _isFavorite ? Colors.red[300] : Colors.white,
                      ),
                    ),
                    onPressed: _toggleFavorite,
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background: thumbnail or gradient
                      if (course.thumbnailUrl != null &&
                          course.thumbnailUrl!.isNotEmpty)
                        Image.network(course.thumbnailUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _gradientBg(colors))
                      else
                        _gradientBg(colors),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                      // Bottom info in hero
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (course.category.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colors.first.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(course.category,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700)),
                              ),
                            Text(course.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    height: 1.25)),
                            if (course.subtitle.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(course.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.75),
                                      fontSize: 13,
                                      height: 1.4)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Rating row ────────────────────────────────────────────────
              if (course.averageRating > 0)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Row(children: [
                      ...List.generate(5, (i) => Icon(
                        i < course.averageRating.floor()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppColors.warning, size: 18)),
                      const SizedBox(width: 8),
                      Text(
                        '${course.averageRating.toStringAsFixed(1)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: AppColors.dark),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${course.totalReviews} reviews)',
                        style: const TextStyle(
                            color: AppColors.gray500, fontSize: 13),
                      ),
                    ]),
                  ),
                ),

              // ── Stats strip ───────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildStats(course)),

              // ── Instructor ────────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildInstructor(course)),

              // ── Description ───────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildDescription(course)),

              // ── What you'll learn ─────────────────────────────────────────
              if (course.prerequisites.isNotEmpty)
                SliverToBoxAdapter(child: _buildLearningOutcomes(course)),

              // ── Curriculum ────────────────────────────────────────────────
              if (_lessons.isNotEmpty)
                SliverToBoxAdapter(child: _buildCurriculum()),

              // ── Bottom padding for CTA ────────────────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // ── Sticky bottom CTA ────────────────────────────────────────────
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _buildCTA(course),
          ),
        ],
      ),
    );
  }

  // ── Hero gradient ──────────────────────────────────────────────────────────
  Widget _gradientBg(List<Color> colors) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
    ),
  );

  // ── Stats strip ────────────────────────────────────────────────────────────
  Widget _buildStats(CourseModel c) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(Icons.play_lesson_rounded, '${c.totalLessons}', 'Lessons',
              AppColors.info),
          _vDivider(),
          _statItem(Icons.access_time_rounded,
              '${c.totalDurationHours.toStringAsFixed(0)}h', 'Duration',
              AppColors.success),
          _vDivider(),
          _statItem(Icons.people_alt_rounded, '${c.totalEnrolled}', 'Students',
              AppColors.warning),
          _vDivider(),
          _statItem(Icons.bar_chart_rounded, _shortLevel(c.level), 'Level',
              AppColors.primary),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) =>
      Column(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 15, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                color: AppColors.gray500, fontSize: 11)),
      ]);

  Widget _vDivider() => Container(
    height: 40, width: 1, color: AppColors.gray200);

  // ── Instructor ─────────────────────────────────────────────────────────────
  Widget _buildInstructor(CourseModel c) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: _heroColors(c),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Instructor',
                    style: TextStyle(
                        color: AppColors.gray500, fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(c.teacherId)
                      .get(),
                  builder: (context, snap) {
                    String name = 'Instructor';
                    if (snap.hasData && snap.data!.exists) {
                      final data =
                          snap.data!.data() as Map<String, dynamic>;
                      name = data['name'] ??
                          data['displayName'] ??
                          'Instructor';
                    }
                    return Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.dark));
                  },
                ),
                if (c.language.isNotEmpty)
                  Text(c.language,
                      style: const TextStyle(
                          color: AppColors.gray500, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('View Profile',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Description ────────────────────────────────────────────────────────────
  Widget _buildDescription(CourseModel c) {
    final desc = c.description.isNotEmpty
        ? c.description
        : 'No description provided.';
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About this Course',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark)),
          const SizedBox(height: 10),
          Text(desc,
              style: const TextStyle(
                  color: AppColors.gray700, fontSize: 14, height: 1.6),
              maxLines: _descExpanded ? null : 4,
              overflow: _descExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis),
          if (!_descExpanded && desc.length > 160) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _descExpanded = true),
              child: const Text('Read more →',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          ],
        ],
      ),
    );
  }

  // ── Learning outcomes ──────────────────────────────────────────────────────
  Widget _buildLearningOutcomes(CourseModel c) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primarySubtle,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.emoji_objects_rounded,
                color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text("What You'll Learn",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark)),
          ]),
          const SizedBox(height: 12),
          ...c.prerequisites.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item,
                      style: const TextStyle(
                          color: AppColors.gray800,
                          fontSize: 13,
                          height: 1.4)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Curriculum ─────────────────────────────────────────────────────────────
  Widget _buildCurriculum() {
    final shown = _isEnrolled ? _lessons : _lessons.take(3).toList();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.list_alt_rounded,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text('Curriculum (${_lessons.length} lessons)',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark)),
          ]),
          const SizedBox(height: 14),
          ...shown.map((lesson) => _lessonRow(lesson)),
          if (!_isEnrolled && _lessons.length > 3) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 15, color: AppColors.gray500),
                  const SizedBox(width: 6),
                  Text(
                    '+${_lessons.length - 3} more lessons — enroll to unlock',
                    style: const TextStyle(
                        color: AppColors.gray500, fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _lessonRow(LessonModel lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _isEnrolled
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.gray200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text('${lesson.sequenceNumber}',
                style: TextStyle(
                    color: _isEnrolled ? AppColors.primary : AppColors.gray500,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lesson.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.dark)),
              if (lesson.totalDuration.inSeconds > 0)
                Text(_fmtDur(lesson.totalDuration),
                    style: const TextStyle(
                        color: AppColors.gray500, fontSize: 11)),
            ],
          ),
        ),
        Icon(
          _isEnrolled
              ? Icons.play_circle_rounded
              : Icons.lock_rounded,
          color: _isEnrolled ? AppColors.primary : AppColors.gray300,
          size: 22,
        ),
      ]),
    );
  }

  // ── Bottom CTA ─────────────────────────────────────────────────────────────
  Widget _buildCTA(CourseModel course) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: _isEnrolled
          ? Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _goToPlayer,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Continue Learning',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 14),
                SizedBox(width: 6),
                Text('You are enrolled in this course',
                    style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                        fontSize: 13)),
              ]),
            ])
          : Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      course.isFree
                          ? 'Free'
                          : '\$${course.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: course.isFree
                              ? AppColors.success
                              : AppColors.dark),
                    ),
                    Text(
                      course.isFree
                          ? 'No credit card needed'
                          : '30-day money-back guarantee',
                      style: const TextStyle(
                          color: AppColors.gray500, fontSize: 11),
                    ),
                  ]),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: _enrolling ? null : _enroll,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _enrolling
                          ? const SizedBox(
                              width: 22, height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : Text(
                              course.isFree ? 'Enroll Free' : 'Enroll Now',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ]),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String _shortLevel(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':     return 'Beginner';
      case 'intermediate': return 'Mid';
      case 'advanced':     return 'Advanced';
      default:             return level.isNotEmpty ? level : 'All';
    }
  }

  String _fmtDur(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    return '${d.inMinutes}m';
  }
}
