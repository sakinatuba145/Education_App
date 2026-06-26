import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/student/screens/student_project_screen.dart';

class CoursePlayerScreen extends StatefulWidget {
  final String courseId;
  final String? initialLessonId;

  const CoursePlayerScreen({
    super.key,
    required this.courseId,
    this.initialLessonId,
  });

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<LessonModel> _lessons = [];
  LessonModel? _currentLesson;
  Map<String, dynamic>? _currentContent;
  EnrolledCourse? _enrollment;
  Map<String, dynamic> _courseData = {};
  bool _loading = true;
  bool _markingComplete = false;
  bool _sidebarOpen = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _firestore.collection('courses').doc(widget.courseId).get(),
        _firestore
            .collection('courses')
            .doc(widget.courseId)
            .collection('lessons')
            .orderBy('sequenceNumber')
            .get(),
        _enrollmentService.getEnrollment(widget.courseId),
      ]);

      final courseDoc = results[0] as DocumentSnapshot;
      final lessonsSnap = results[1] as QuerySnapshot;
      final enrollment = results[2] as EnrolledCourse?;

      final lessons = lessonsSnap.docs
          .map((d) => LessonModel.fromJson({
                'id': d.id,
                ...d.data() as Map<String, dynamic>
              }))
          .toList();

      LessonModel? initial;
      if (widget.initialLessonId != null) {
        initial = lessons.firstWhere(
          (l) => l.id == widget.initialLessonId,
          orElse: () => lessons.isNotEmpty ? lessons.first : _dummyLesson(),
        );
      } else if (enrollment != null && enrollment.completedLessons.isNotEmpty) {
        final lastCompleted = enrollment.completedLessons.last;
        final lastIndex =
            lessons.indexWhere((l) => l.id == lastCompleted);
        final nextIndex =
            (lastIndex + 1).clamp(0, lessons.length - 1);
        initial = lessons.isNotEmpty ? lessons[nextIndex] : null;
      } else {
        initial = lessons.isNotEmpty ? lessons.first : null;
      }

      Map<String, dynamic>? content;
      if (initial != null) {
        content = await _loadLessonContent(initial);
      }

      setState(() {
        _courseData = courseDoc.data() as Map<String, dynamic>? ?? {};
        _lessons = lessons;
        _currentLesson = initial;
        _currentContent = content;
        _enrollment = enrollment;
        _loading = false;
      });

      if (initial != null) {
        await _enrollmentService.updateLastAccessed(widget.courseId);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  LessonModel _dummyLesson() => LessonModel(
        id: '',
        courseId: widget.courseId,
        title: '',
        description: '',
        sequenceNumber: 0,
        contentIds: [],
        totalViews: 0,
        totalCompleted: 0,
        averageRating: 0,
        totalDuration: Duration.zero,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  Future<Map<String, dynamic>?> _loadLessonContent(LessonModel lesson) async {
    if (lesson.contentIds.isEmpty) return null;
    try {
      final contentDoc = await _firestore
          .collection('courses')
          .doc(widget.courseId)
          .collection('lessons')
          .doc(lesson.id)
          .collection('content')
          .orderBy('order')
          .limit(1)
          .get();
      if (contentDoc.docs.isNotEmpty) {
        return contentDoc.docs.first.data();
      }
    } catch (_) {}
    return null;
  }

  Future<void> _selectLesson(LessonModel lesson) async {
    setState(() {
      _currentLesson = lesson;
      _currentContent = null;
    });
    final content = await _loadLessonContent(lesson);
    setState(() => _currentContent = content);
    await _enrollmentService.updateLastAccessed(widget.courseId);
  }

  Future<void> _markAsComplete() async {
    if (_currentLesson == null || _markingComplete) return;
    setState(() => _markingComplete = true);
    try {
      await _enrollmentService.markLessonComplete(
        courseId: widget.courseId,
        lessonId: _currentLesson!.id,
        totalLessons: _lessons.length,
      );
      final updated = await _enrollmentService.getEnrollment(widget.courseId);
      setState(() {
        _enrollment = updated;
        _markingComplete = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Lesson marked as complete!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }

      final currentIndex =
          _lessons.indexWhere((l) => l.id == _currentLesson!.id);
      if (currentIndex < _lessons.length - 1) {
        await _selectLesson(_lessons[currentIndex + 1]);
      }
    } catch (e) {
      setState(() => _markingComplete = false);
    }
  }

  bool _isLessonCompleted(String lessonId) {
    return _enrollment?.completedLessons.contains(lessonId) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_lessons.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_courseData['title'] ?? 'Course'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.library_books_outlined,
                  size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('No lessons available yet',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      )),
              const SizedBox(height: 8),
              Text('The instructor is still adding content.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[400])),
            ],
          ),
        ),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _courseData['title'] ?? 'Course',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (_enrollment != null)
              Text(
                '${_enrollment!.progressPercent}% complete',
                style: const TextStyle(fontSize: 12, color: Colors.white60),
              ),
          ],
        ),
        actions: [
          if (!isWide)
            IconButton(
              icon: Icon(
                  _sidebarOpen ? Icons.close : Icons.list),
              onPressed: () =>
                  setState(() => _sidebarOpen = !_sidebarOpen),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: _enrollment?.progress ?? 0,
            backgroundColor: Colors.white12,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 3,
          ),
        ),
      ),
      body: isWide
          ? Row(
              children: [
                SizedBox(
                  width: 300,
                  child: _buildLessonSidebar(),
                ),
                Expanded(child: _buildContentPanel()),
              ],
            )
          : _sidebarOpen
              ? _buildLessonSidebar()
              : _buildContentPanel(),
    );
  }

  Widget _buildLessonSidebar() {
    final completedCount = _enrollment?.completedLessons.length ?? 0;
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2A2A2A),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Course Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completedCount / ${_lessons.length} lessons completed',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                final isCurrentLesson =
                    _currentLesson?.id == lesson.id;
                final isCompleted = _isLessonCompleted(lesson.id);

                return InkWell(
                  onTap: () {
                    _selectLesson(lesson);
                    if (MediaQuery.of(context).size.width < 800) {
                      setState(() => _sidebarOpen = false);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: isCurrentLesson
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? AppColors.success
                                : isCurrentLesson
                                    ? AppColors.primary
                                    : Colors.white12,
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 16)
                                : isCurrentLesson
                                    ? const Icon(Icons.play_arrow,
                                        color: Colors.white, size: 16)
                                    : Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title,
                                style: TextStyle(
                                  color: isCurrentLesson
                                      ? Colors.white
                                      : Colors.white70,
                                  fontSize: 13,
                                  fontWeight: isCurrentLesson
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (lesson.totalDuration.inSeconds > 0)
                                Text(
                                  _formatDuration(lesson.totalDuration),
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 11),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Final Project entry
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentProjectScreen(
                  courseId: widget.courseId,
                  courseTitle: _courseData['title'] ?? 'Course',
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    child: const Icon(Icons.assignment_rounded, color: AppColors.primary, size: 16),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Final Project', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('Submit & get graded', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPanel() {
    if (_currentLesson == null) {
      return const Center(
        child: Text('Select a lesson', style: TextStyle(color: Colors.white54)),
      );
    }

    final videoUrl = _currentContent?['url'] as String?;
    final contentType = _currentContent?['type'] as String? ?? 'text';
    final isCompleted = _isLessonCompleted(_currentLesson!.id);

    return Container(
      color: const Color(0xFF0F0F0F),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (videoUrl != null &&
                (contentType == 'video' || contentType == 'image'))
              _buildVideoArea(videoUrl, contentType)
            else
              _buildContentPlaceholder(contentType),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentLesson!.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_currentLesson!.totalDuration.inSeconds > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.white38),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(_currentLesson!.totalDuration),
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (_currentLesson!.description.isNotEmpty)
                    Text(
                      _currentLesson!.description,
                      style: const TextStyle(
                          color: Colors.white70, height: 1.6, fontSize: 15),
                    ),
                  const SizedBox(height: 24),
                  if (videoUrl != null && contentType == 'video')
                    OutlinedButton.icon(
                      onPressed: () =>
                          launchUrl(Uri.parse(videoUrl)),
                      icon: const Icon(Icons.open_in_new,
                          size: 16, color: Colors.white54),
                      label: const Text('Open Video in Browser',
                          style: TextStyle(color: Colors.white54)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                      ),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isCompleted ? null : _markAsComplete,
                      icon: _markingComplete
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              size: 18,
                            ),
                      label: Text(
                        isCompleted
                            ? 'Completed ✓'
                            : 'Mark as Complete',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isCompleted ? AppColors.success : AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.success.withValues(alpha: 0.7),
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNavigationRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoArea(String url, String type) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        width: double.infinity,
        height: 240,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: const Color(0xFF1A1A1A),
              child: const Center(
                child: Icon(Icons.play_circle_outline,
                    color: Colors.white54, size: 72),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tap to open video',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPlaceholder(String type) {
    IconData icon;
    String label;
    switch (type) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        label = 'PDF Document';
        break;
      case 'audio':
        icon = Icons.audiotrack;
        label = 'Audio Lesson';
        break;
      default:
        icon = Icons.article_outlined;
        label = 'Text Lesson';
    }
    return Container(
      width: double.infinity,
      height: 180,
      color: const Color(0xFF1A1A1A),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: AppColors.primary.withValues(alpha: 0.7)),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNavigationRow() {
    if (_currentLesson == null) return const SizedBox.shrink();
    final idx = _lessons.indexWhere((l) => l.id == _currentLesson!.id);
    final hasPrev = idx > 0;
    final hasNext = idx < _lessons.length - 1;

    return Row(
      children: [
        if (hasPrev)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _selectLesson(_lessons[idx - 1]),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white54,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        if (hasPrev && hasNext) const SizedBox(width: 12),
        if (hasNext)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _selectLesson(_lessons[idx + 1]),
              icon: const Text('Next'),
              label: const Icon(Icons.arrow_forward, size: 16),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    }
    return '${d.inMinutes}m';
  }
}
