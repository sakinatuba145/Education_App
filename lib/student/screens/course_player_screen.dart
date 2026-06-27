import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/student/screens/student_project_screen.dart';
import 'package:education_app/quiz/quiz_player_screen_premium.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// ─── brand tokens ────────────────────────────────────────────────────────────
const _orange = AppColors.primary;
const _orangeLight = Color(0xFFFFF4EE);
const _surface = Color(0xFFFAFAFA);
const _sidebarBg = Colors.white;
const _dark = Color(0xFF1A1A2E);

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
  Map<String, dynamic>? _currentQuizData;  // quiz for current lesson
  bool _quizLoading = false;
  EnrolledCourse? _enrollment;
  Map<String, dynamic> _courseData = {};
  bool _loading = true;
  bool _markingComplete = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          .map((d) => LessonModel.fromJson({'id': d.id, ...d.data() as Map<String, dynamic>}))
          .toList();

      LessonModel? initial;
      if (widget.initialLessonId != null) {
        initial = lessons.firstWhere(
          (l) => l.id == widget.initialLessonId,
          orElse: () => lessons.isNotEmpty ? lessons.first : _dummy(),
        );
      } else if (enrollment != null && enrollment.completedLessons.isNotEmpty) {
        final lastCompleted = enrollment.completedLessons.last;
        final lastIdx = lessons.indexWhere((l) => l.id == lastCompleted);
        final nextIdx = (lastIdx + 1).clamp(0, lessons.length - 1);
        initial = lessons.isNotEmpty ? lessons[nextIdx] : null;
      } else {
        initial = lessons.isNotEmpty ? lessons.first : null;
      }

      Map<String, dynamic>? content;
      Map<String, dynamic>? quiz;
      if (initial != null) {
        content = await _loadContent(initial);
        quiz = await _loadQuiz(initial);
      }

      setState(() {
        _courseData = courseDoc.data() as Map<String, dynamic>? ?? {};
        _lessons = lessons;
        _currentLesson = initial;
        _currentContent = content;
        _currentQuizData = quiz;
        _enrollment = enrollment;
        _loading = false;
      });

      if (initial != null) _enrollmentService.updateLastAccessed(widget.courseId);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  LessonModel _dummy() => LessonModel(
        id: '', courseId: widget.courseId, title: '', description: '',
        sequenceNumber: 0, contentIds: [], totalViews: 0,
        totalCompleted: 0, averageRating: 0,
        totalDuration: Duration.zero,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      );

  // ── Content loader — no contentIds guard, tries multiple field names ───────
  Future<Map<String, dynamic>?> _loadContent(LessonModel lesson) async {
    try {
      // 1. Try content sub-collection
      final snap = await _firestore
          .collection('courses').doc(widget.courseId)
          .collection('lessons').doc(lesson.id)
          .collection('content')
          .orderBy('order').limit(1).get();
      if (snap.docs.isNotEmpty) return snap.docs.first.data();

      // 2. Fallback: check lesson doc itself for video URL fields
      final lessonDoc = await _firestore
          .collection('courses').doc(widget.courseId)
          .collection('lessons').doc(lesson.id).get();
      final data = lessonDoc.data() ?? {};
      final url = data['videoUrl'] ?? data['youtubeUrl'] ?? data['url'] ?? data['video'];
      if (url != null && url.toString().isNotEmpty) {
        return {'url': url.toString(), 'type': 'video'};
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Quiz loader — reads from lessons/{id}/quizzes sub-collection ──────────
  Future<Map<String, dynamic>?> _loadQuiz(LessonModel lesson) async {
    try {
      // Try lesson sub-collection quizzes first
      final snap = await _firestore
          .collection('courses').doc(widget.courseId)
          .collection('lessons').doc(lesson.id)
          .collection('quizzes')
          .limit(1).get();
      if (snap.docs.isNotEmpty) {
        return {'id': snap.docs.first.id, ...snap.docs.first.data()};
      }

      // Fallback: top-level quizzes collection using attachedQuizId
      if (lesson.hasQuiz) {
        final doc = await _firestore.collection('quizzes').doc(lesson.attachedQuizId).get();
        if (doc.exists) {
          return {'id': doc.id, ...doc.data()!};
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _selectLesson(LessonModel lesson) async {
    setState(() {
      _currentLesson = lesson;
      _currentContent = null;
      _currentQuizData = null;
      _quizLoading = true;
    });

    final results = await Future.wait([
      _loadContent(lesson),
      _loadQuiz(lesson),
    ]);

    if (mounted) {
      setState(() {
        _currentContent = results[0] as Map<String, dynamic>?;
        _currentQuizData = results[1] as Map<String, dynamic>?;
        _quizLoading = false;
      });
    }
    _enrollmentService.updateLastAccessed(widget.courseId);
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
      if (mounted) setState(() { _enrollment = updated; _markingComplete = false; });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Lesson marked as complete! 🎉', style: TextStyle(fontWeight: FontWeight.w600)),
          ]),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ));
      }

      final currentIdx = _lessons.indexWhere((l) => l.id == _currentLesson!.id);
      if (currentIdx < _lessons.length - 1) {
        await _selectLesson(_lessons[currentIdx + 1]);
      }
    } catch (_) {
      if (mounted) setState(() => _markingComplete = false);
    }
  }

  bool _isCompleted(String lessonId) =>
      _enrollment?.completedLessons.contains(lessonId) ?? false;

  // Lesson is locked if it's not the first AND the previous lesson isn't done
  bool _isLocked(int index) {
    if (index == 0) return false;
    return !_isCompleted(_lessons[index - 1].id);
  }

  int get _currentIdx =>
      _lessons.indexWhere((l) => l.id == _currentLesson?.id);

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: _surface,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CircularProgressIndicator(color: _orange),
            const SizedBox(height: 16),
            Text('Loading course…', style: TextStyle(color: Colors.grey[500])),
          ]),
        ),
      );
    }

    if (_lessons.isEmpty) {
      return Scaffold(
        backgroundColor: _surface,
        appBar: _buildAppBar(false),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _orangeLight, shape: BoxShape.circle,
              ),
              child: const Icon(Icons.library_books_outlined, size: 56, color: _orange),
            ),
            const SizedBox(height: 20),
            const Text('No lessons yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('The instructor is still adding content.',
                style: TextStyle(color: Colors.grey[500])),
          ]),
        ),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= 860;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _surface,
      appBar: _buildAppBar(isWide),
      drawer: isWide ? null : _buildDrawer(),
      body: isWide
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildSidebar(),
              Expanded(child: _buildMainContent()),
            ])
          : _buildMainContent(),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(bool isWide) {
    final completed = _enrollment?.completedLessons.length ?? 0;
    final total = _lessons.length;
    final progress = _enrollment?.progress ?? 0.0;
    final idx = _currentIdx;

    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: SafeArea(
          bottom: false,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 12, 0),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  onPressed: () => Navigator.pop(context),
                  color: _dark,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _courseData['title'] ?? 'Course',
                        style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: _dark),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        idx >= 0
                            ? 'Lesson ${idx + 1} / $total'
                            : '$completed / $total lessons done',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _orangeLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.local_fire_department_rounded, size: 13, color: _orange),
                    const SizedBox(width: 4),
                    Text(
                      '${_enrollment?.progressPercent ?? 0}%',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold, color: _orange),
                    ),
                  ]),
                ),
                if (!isWide) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.menu_book_rounded, size: 20, color: _orange),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    tooltip: 'Course Content',
                  ),
                ],
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Colors.grey[100],
                  valueColor: const AlwaysStoppedAnimation<Color>(_orange),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  // ── Drawer (mobile) ──────────────────────────────────────────────────────

  Widget _buildDrawer() => Drawer(
    backgroundColor: Colors.white,
    child: _buildSidebarContent(),
  );

  // ── Sidebar (wide) ───────────────────────────────────────────────────────

  Widget _buildSidebar() => Container(
    width: 280,
    color: _sidebarBg,
    decoration: const BoxDecoration(
      border: Border(right: BorderSide(color: Color(0xFFEEEEEE))),
    ),
    child: _buildSidebarContent(),
  );

  Widget _buildSidebarContent() {
    final completed = _enrollment?.completedLessons.length ?? 0;
    final total = _lessons.length;
    final pct = total > 0 ? (completed / total * 100).round() : 0;

    return Column(children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _orangeLight, borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu_book_rounded, color: _orange, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('CURRICULUM',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: _orange, letterSpacing: 1.2)),
          ]),
          const SizedBox(height: 10),
          Text(
            _courseData['title'] ?? 'Course',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _dark),
            maxLines: 2, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: _enrollment?.progress ?? 0,
                  minHeight: 5,
                  backgroundColor: Colors.grey[100],
                  valueColor: const AlwaysStoppedAnimation<Color>(_orange),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('$pct%',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: _orange)),
          ]),
          const SizedBox(height: 4),
          Text('$completed / $total LESSONS DONE',
              style: TextStyle(fontSize: 10, color: Colors.grey[400], letterSpacing: 0.5)),
        ]),
      ),
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _lessons.length + 1,
          itemBuilder: (_, i) {
            if (i == _lessons.length) return _finalProjectTile();
            final lesson = _lessons[i];
            final isCurrent = _currentLesson?.id == lesson.id;
            final isDone = _isCompleted(lesson.id);
            final locked = _isLocked(i);
            return _lessonTile(lesson, i, isCurrent, isDone, locked);
          },
        ),
      ),
    ]);
  }

  Widget _lessonTile(LessonModel lesson, int i, bool isCurrent, bool isDone, bool locked) {
    return InkWell(
      onTap: locked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(children: [
                  const Icon(Icons.lock_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text('Complete "${_lessons[i - 1].title}" first',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ]),
                backgroundColor: Colors.grey[800],
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ));
            }
          : () {
              _selectLesson(lesson);
              _scaffoldKey.currentState?.closeDrawer();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isCurrent ? _orangeLight : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isCurrent ? _orange : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 28, height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: locked
                  ? Colors.grey[200]
                  : isDone
                      ? const Color(0xFF2E7D32)
                      : isCurrent
                          ? _orange
                          : Colors.grey[100],
              border: isCurrent && !isDone && !locked
                  ? Border.all(color: _orange.withValues(alpha: 0.4), width: 2)
                  : null,
            ),
            child: Center(
              child: locked
                  ? Icon(Icons.lock_rounded, size: 13, color: Colors.grey[500])
                  : isDone
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                      : isCurrent
                          ? const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14)
                          : Text('${i + 1}',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold,
                                  color: Colors.grey[500])),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                lesson.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: locked
                      ? Colors.grey[400]
                      : isDone
                          ? Colors.grey[400]
                          : isCurrent
                              ? _dark
                              : Colors.grey[700],
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.grey[400],
                ),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
              if (lesson.totalDuration.inSeconds > 0)
                Text(
                  _formatDur(lesson.totalDuration),
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
            ]),
          ),
          if (locked)
            Icon(Icons.lock_rounded, size: 13, color: Colors.grey[400])
          else if (isDone)
            const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF2E7D32)),
        ]),
      ),
    );
  }

  Widget _finalProjectTile() {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => StudentProjectScreen(
          courseId: widget.courseId,
          courseTitle: _courseData['title'] ?? 'Course',
        ),
      )),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_orange.withValues(alpha: 0.08), _orange.withValues(alpha: 0.18)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _orange.withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: _orange, borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Final Project',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _dark)),
              Text('Submit & get certified',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: _orange),
        ]),
      ),
    );
  }

  // ── Main Content Area ────────────────────────────────────────────────────

  Widget _buildMainContent() {
    if (_currentLesson == null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.touch_app_rounded, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text('Select a lesson to start', style: TextStyle(color: Colors.grey[400])),
        ]),
      );
    }

    // Resolve video URL — check multiple field names
    final rawUrl = _currentContent?['url']
        ?? _currentContent?['videoUrl']
        ?? _currentContent?['youtubeUrl']
        ?? _currentContent?['video'];
    final videoUrl = rawUrl as String?;
    final contentType = (_currentContent?['type'] ?? _currentContent?['contentType'] ?? 'text') as String;
    final isCompleted = _isCompleted(_currentLesson!.id);
    final idx = _currentIdx;
    final hasPrev = idx > 0;
    final hasNext = idx < _lessons.length - 1;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Video / media zone ───────────────────────────────────────────
        if (videoUrl != null && videoUrl.isNotEmpty)
          _buildVideoZone(videoUrl, contentType)
        else
          _buildMediaPlaceholder(contentType),

        // ── Lesson info ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _orangeLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Lesson ${idx >= 0 ? idx + 1 : "—"} of ${_lessons.length}',
                  style: const TextStyle(fontSize: 11, color: _orange, fontWeight: FontWeight.w700),
                ),
              ),
              if (_currentLesson!.totalDuration.inSeconds > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100], borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(_formatDur(_currentLesson!.totalDuration),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ]),
                ),
              ],
              if (isCompleted) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF2E7D32)),
                    SizedBox(width: 4),
                    Text('Completed',
                        style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
              ],
            ]),
            const SizedBox(height: 12),
            Text(
              _currentLesson!.title,
              style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: _dark, height: 1.2),
            ),
            if (_currentLesson!.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _currentLesson!.description,
                style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.7),
              ),
            ],
            const SizedBox(height: 24),
          ]),
        ),

        // ── Open video button (when video detected) ──────────────────────
        if (videoUrl != null && videoUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: OutlinedButton.icon(
              onPressed: () => launchUrl(Uri.parse(videoUrl)),
              icon: const Icon(Icons.open_in_new_rounded, size: 15),
              label: const Text('Open video in browser'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _orange,
                side: BorderSide(color: _orange.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

        // ── Quiz / Assignment section ─────────────────────────────────────
        _buildQuizSection(),

        // ── Mark Complete button ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: SizedBox(
            width: double.infinity,
            child: _markingComplete
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _orange, borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(width: 18, height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                      SizedBox(width: 10),
                      Text('Marking complete…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ]),
                  )
                : isCompleted
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Completed ✓',
                              style: TextStyle(color: Colors.white, fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ]),
                      )
                    : GestureDetector(
                        onTap: _markAsComplete,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: _orange.withValues(alpha: 0.35),
                                blurRadius: 12, offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text('Mark as Complete',
                                style: TextStyle(color: Colors.white, fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ]),
                        ),
                      ),
          ),
        ),

        // ── Prev / Next nav ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: Row(children: [
            if (hasPrev)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectLesson(_lessons[idx - 1]),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                  label: Text(
                    _lessons[idx - 1].title,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[200]!),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            if (hasPrev && hasNext) const SizedBox(width: 12),
            if (hasNext)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLocked(idx + 1)
                      ? null
                      : () => _selectLesson(_lessons[idx + 1]),
                  icon: Text(
                    _lessons[idx + 1].title,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  label: _isLocked(idx + 1)
                      ? const Icon(Icons.lock_rounded, size: 14)
                      : const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLocked(idx + 1) ? Colors.grey[300] : _orange,
                    foregroundColor: _isLocked(idx + 1) ? Colors.grey[600] : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
          ]),
        ),
      ]),
    );
  }

  // ── Quiz / Assignment Section ────────────────────────────────────────────

  Widget _buildQuizSection() {
    if (_quizLoading) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Row(children: [
            SizedBox(width: 18, height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: _orange)),
            SizedBox(width: 12),
            Text('Loading quiz…', style: TextStyle(color: Colors.grey)),
          ]),
        ),
      );
    }

    if (_currentQuizData == null) return const SizedBox.shrink();

    final quizTitle = _currentQuizData!['title'] as String? ?? 'Lesson Quiz';
    final questions = _currentQuizData!['questions'] as List? ?? [];
    final questionCount = questions.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _orange.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: _orange.withValues(alpha: 0.08),
              blurRadius: 16, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _orangeLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: _orange, borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.quiz_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('LESSON QUIZ',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                          color: _orange, letterSpacing: 1.2)),
                  Text(quizTitle,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                          color: _dark)),
                ]),
              ),
              if (questionCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _orange.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '$questionCount Q',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                        color: _orange),
                  ),
                ),
            ]),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (questionCount > 0) ...[
                Text(
                  'Test your understanding of this lesson with $questionCount question${questionCount > 1 ? 's' : ''}.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.check_circle_outline_rounded, size: 13, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text('Need 70% to pass',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                ]),
              ] else
                Text('This lesson has an attached quiz.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizPlayerScreenPremium(
                        courseId: widget.courseId,
                        lessonId: _currentLesson!.id,
                        quizId: _currentQuizData!['id'] as String?,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text('Start Quiz',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Video Zone ───────────────────────────────────────────────────────────

  Widget _buildVideoZone(String url, String type) {
    final ytId = _extractYouTubeId(url);
    if (ytId != null) return _buildYouTubeEmbed(ytId, url);

    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 320),
        color: _dark,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(alignment: Alignment.center, children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
                ),
              ),
            ),
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: _orange.withValues(alpha: 0.4), blurRadius: 40)],
              ),
            ),
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: _orange, shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                  color: _orange.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 4)],
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 42),
            ),
            Positioned(
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Click to play video',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildYouTubeEmbed(String videoId, String originalUrl) {
    return _YoutubeInlinePlayer(videoId: videoId);
  }

  Widget _buildMediaPlaceholder(String type) {
    IconData icon;
    String label;
    Color color;
    switch (type) {
      case 'pdf':
        icon = Icons.picture_as_pdf_rounded; label = 'PDF Document'; color = Colors.red;
        break;
      case 'audio':
        icon = Icons.headphones_rounded; label = 'Audio Lesson'; color = Colors.purple;
        break;
      default:
        icon = Icons.article_rounded; label = 'Text Lesson'; color = _orange;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.08), color.withValues(alpha: 0.15)],
        ),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 20)],
          ),
          child: Icon(icon, size: 44, color: color),
        ),
        const SizedBox(height: 14),
        Text(label, style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String? _extractYouTubeId(String url) {
    final patterns = [
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(url);
      if (m != null) return m.group(1);
    }
    return null;
  }

  String _formatDur(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m';
    return '${d.inSeconds}s';
  }
}

// ── YouTube inline player ────────────────────────────────────────────────────
// Tap thumbnail → full-screen overlay injected directly onto document.body.
// This avoids triple-iframe nesting (Replit preview → Flutter platform view →
// YouTube) by putting the YouTube iframe only ONE level inside our document.

class _YoutubeInlinePlayer extends StatelessWidget {
  final String videoId;
  const _YoutubeInlinePlayer({required this.videoId});

  void _openOverlay() {
    // Open video in a new browser tab — triggered by user gesture so popup
    // blockers don't fire. The original tab stays open (user keeps their place).
    // YouTube iframe embedding is blocked inside Replit's sandboxed preview;
    // on a deployed app it would be possible to embed, but new-tab is reliable
    // everywhere and keeps the app open in the background tab.
    html.window.open(
      'https://www.youtube.com/watch?v=$videoId',
      '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    final thumbUrl =
        'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: _openOverlay,
          child: Stack(alignment: Alignment.center, children: [
            // Thumbnail
            Image.network(
              thumbUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1A1A2E),
                child: const Icon(Icons.video_library_rounded,
                    size: 56, color: Colors.white24),
              ),
            ),
            // Dim overlay
            Container(color: Colors.black.withValues(alpha: 0.28)),
            // Red play button
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 24, spreadRadius: 2,
                )],
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 46),
            ),
            // "Tap to play" label
            Positioned(
              bottom: 12, left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.60),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Tap to play',
                    style: TextStyle(color: Colors.white, fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            // YouTube pill
            Positioned(
              bottom: 12, right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.smart_display_rounded,
                      size: 14, color: Color(0xFFFF0000)),
                  SizedBox(width: 4),
                  Text('YouTube',
                      style: TextStyle(color: Colors.white70, fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
