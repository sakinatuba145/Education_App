import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/teacher/models/lesson_quiz_model.dart';
import 'package:education_app/teacher/services/teacher_quiz_service.dart';
import 'package:education_app/teacher/screens/lesson_editor_screen.dart';
import 'package:education_app/teacher/screens/quiz_builder_screen.dart';

const _orange = Color(0xFFFFA726);

class TeacherCourseHubScreen extends StatefulWidget {
  final String courseId;
  const TeacherCourseHubScreen({super.key, required this.courseId});

  @override
  State<TeacherCourseHubScreen> createState() => _TeacherCourseHubScreenState();
}

class _TeacherCourseHubScreenState extends State<TeacherCourseHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TeacherCourseService _courseService = TeacherCourseService();
  final TeacherLessonService _lessonService = TeacherLessonService();
  final TeacherQuizService _quizService = TeacherQuizService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CourseModel? _course;
  List<LessonModel> _lessons = [];
  List<Map<String, dynamic>> _students = [];
  bool _loading = true;
  bool _lessonSaving = false;

  // Edit course form controllers
  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _thumbCtrl = TextEditingController();
  String _selectedCategory = 'Programming';
  String _selectedLevel = 'beginner';
  bool _isFree = true;
  bool _detailsSaving = false;

  static const _categories = [
    'Programming', 'Web Development', 'Mobile Development',
    'Data Science', 'Design', 'Business', 'Language', 'Other'
  ];
  static const _levels = ['beginner', 'intermediate', 'advanced'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _thumbCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _courseService.getCourseById(widget.courseId),
        _lessonService.getCourseLessons(widget.courseId),
        _loadStudents(),
      ]);
      final course = results[0] as CourseModel;
      if (mounted) {
        setState(() {
          _course = course;
          _lessons = results[1] as List<LessonModel>;
          _loading = false;
          _titleCtrl.text = course.title;
          _subtitleCtrl.text = course.subtitle;
          _descCtrl.text = course.description;
          _priceCtrl.text = course.price?.toString() ?? '';
          _thumbCtrl.text = course.thumbnailUrl ?? '';
          _selectedCategory = _categories.contains(course.category) ? course.category : 'Programming';
          _selectedLevel = _levels.contains(course.level) ? course.level : 'beginner';
          _isFree = course.isFree;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<List<Map<String, dynamic>>> _loadStudents() async {
    try {
      final snap = await _db
          .collection('courses')
          .doc(widget.courseId)
          .collection('enrollments')
          .get();
      final students = <Map<String, dynamic>>[];
      for (final doc in snap.docs) {
        final data = doc.data();
        final uid = doc.id;
        final userDoc = await _db.collection('users').doc(uid).get();
        final userData = userDoc.data() ?? {};
        final rawName = userData['displayName'] ?? userData['name'] ?? '';
        final name = rawName.contains('|')
            ? rawName.split('|').first
            : (rawName.isNotEmpty ? rawName : userData['email'] ?? uid);

        // Load quiz results
        final quizSnap = await _db
            .collection('users')
            .doc(uid)
            .collection('quiz_results')
            .where('courseId', isEqualTo: widget.courseId)
            .get();
        double avgScore = 0;
        if (quizSnap.docs.isNotEmpty) {
          double total = 0;
          for (final r in quizSnap.docs) {
            final d = r.data();
            total += (d['score'] ?? 0) / (d['totalQuestions'] ?? 1) * 100;
          }
          avgScore = total / quizSnap.docs.length;
        }

        students.add({
          'uid': uid,
          'name': name,
          'email': userData['email'] ?? '',
          'progress': (data['progress'] ?? 0.0).toDouble(),
          'status': data['status'] ?? 'active',
          'enrolledAt': (data['enrolledAt'] as Timestamp?)?.toDate(),
          'quizzesTaken': quizSnap.docs.length,
          'avgScore': avgScore,
        });
      }
      _students = students;
      return students;
    } catch (_) {
      return [];
    }
  }

  Future<void> _addLesson() async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add New Lesson', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Lesson Title *',
                prefixIcon: const Icon(Icons.play_lesson),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) return;
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _orange, foregroundColor: Colors.white),
            child: const Text('Add Lesson'),
          ),
        ],
      ),
    );

    if (result != true || titleCtrl.text.trim().isEmpty) return;

    setState(() => _lessonSaving = true);
    try {
      final newLesson = LessonModel(
        id: '',
        courseId: widget.courseId,
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim(),
        sequenceNumber: _lessons.length + 1,
        contentIds: [],
        totalViews: 0,
        totalCompleted: 0,
        averageRating: 0,
        totalDuration: Duration.zero,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final newId = await _lessonService.createLesson(
          courseId: widget.courseId, lesson: newLesson);

      // Update course lesson count
      await _courseService.updateCourse(
        courseId: widget.courseId,
        data: {'totalLessons': _lessons.length + 1},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lesson added! Tap it to add video, notes & quiz.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        final freshLessons = await _lessonService.getCourseLessons(widget.courseId);
        setState(() {
          _lessons = freshLessons;
          _lessonSaving = false;
        });
        // Open editor for the new lesson
        final created = freshLessons.firstWhere(
          (l) => l.id == newId,
          orElse: () => freshLessons.last,
        );
        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonEditorScreen(
                  courseId: widget.courseId, lessonId: created.id),
            ),
          );
          _reloadLessons();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _lessonSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _reloadLessons() async {
    final lessons = await _lessonService.getCourseLessons(widget.courseId);
    if (mounted) setState(() => _lessons = lessons);
  }

  /// Fetch existing quiz for the lesson (or create one), then open QuizBuilderScreen.
  Future<void> _navigateToQuizBuilder(LessonModel lesson) async {
    try {
      final snap = await _db
          .collection('courses')
          .doc(widget.courseId)
          .collection('lessons')
          .doc(lesson.id)
          .collection('quizzes')
          .limit(1)
          .get();

      String quizId;
      String quizTitle;

      if (snap.docs.isNotEmpty) {
        quizId = snap.docs.first.id;
        quizTitle = (snap.docs.first.data()['title'] as String?)?.isNotEmpty == true
            ? snap.docs.first.data()['title'] as String
            : '${lesson.title} Quiz';
      } else {
        quizTitle = '${lesson.title} Quiz';
        final newQuiz = LessonQuizModel(
          id: '',
          courseId: widget.courseId,
          lessonId: lesson.id,
          title: quizTitle,
          description: '',
          instruction: 'Answer all questions',
          passingScore: 70,
          shuffleQuestions: false,
          showAnswersOption: 'after_completion',
          questions: [],
          totalAttempts: 0,
          averageScore: 0,
          passRate: 0,
          averageTimeSeconds: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        quizId = await _quizService.createQuiz(
          courseId: widget.courseId,
          lessonId: lesson.id,
          quiz: newQuiz,
        );
      }

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizBuilderScreen(
              courseId: widget.courseId,
              lessonId: lesson.id,
              quizId: quizId,
              quizTitle: quizTitle,
            ),
          ),
        );
        _reloadLessons();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening quiz: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteLesson(LessonModel lesson, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Lesson'),
        content: Text('Delete "${lesson.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _lessons.removeAt(index));
    try {
      await _lessonService.deleteLesson(courseId: widget.courseId, lessonId: lesson.id);
    } catch (_) {
      setState(() => _lessons.insert(index, lesson));
    }
  }

  Future<void> _saveDetails() async {
    if (_course == null) return;
    setState(() => _detailsSaving = true);
    try {
      await _courseService.updateCourse(
        courseId: widget.courseId,
        data: {
          'title': _titleCtrl.text.trim(),
          'subtitle': _subtitleCtrl.text.trim(),
          'description': _descCtrl.text.trim(),
          'category': _selectedCategory,
          'level': _selectedLevel,
          'isFree': _isFree,
          'price': _isFree ? null : double.tryParse(_priceCtrl.text.trim()),
          'thumbnailUrl': _thumbCtrl.text.trim().isEmpty ? null : _thumbCtrl.text.trim(),
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course updated!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating),
        );
        final updated = await _courseService.getCourseById(widget.courseId);
        setState(() { _course = updated; _detailsSaving = false; });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _detailsSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _togglePublish() async {
    if (_course == null) return;
    final isPublished = _course!.isPublished;
    try {
      if (isPublished) {
        await _courseService.updateCourse(courseId: widget.courseId, data: {'status': 'draft', 'visibility': 'private'});
      } else {
        await _courseService.publishCourse(widget.courseId);
      }
      final updated = await _courseService.getCourseById(widget.courseId);
      if (mounted) {
        setState(() => _course = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isPublished ? 'Course moved to draft.' : 'Course published! Students can now enroll.'),
            backgroundColor: isPublished ? Colors.orange : AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: const Center(child: CircularProgressIndicator(color: _orange)),
      );
    }
    if (_course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course')),
        body: const Center(child: Text('Course not found')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCourseHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLessonsTab(),
                _buildStudentsTab(),
                _buildQuizzesTab(),
                _buildDetailsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final isPublished = _course!.isPublished;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black87,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_course!.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(_course!.category, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isPublished ? Colors.green.withValues(alpha: 0.12) : Colors.orange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isPublished ? 'Published' : 'Draft',
            style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: isPublished ? Colors.green[700] : Colors.orange[700],
            ),
          ),
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              onTap: _togglePublish,
              child: Row(children: [
                Icon(_course!.isPublished ? Icons.unpublished_outlined : Icons.publish_outlined,
                    size: 18, color: _course!.isPublished ? Colors.orange : Colors.green),
                const SizedBox(width: 8),
                Text(_course!.isPublished ? 'Unpublish' : 'Publish'),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseHeader() {
    final c = _course!;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: c.thumbnailUrl != null && c.thumbnailUrl!.isNotEmpty
                ? Image.network(c.thumbnailUrl!, width: 64, height: 64, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _thumbPlaceholder())
                : _thumbPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _headerStat(Icons.people_outline, '${c.totalEnrolled}', 'Students'),
                    const SizedBox(width: 16),
                    _headerStat(Icons.play_lesson_outlined, '${_lessons.length}', 'Lessons'),
                    const SizedBox(width: 16),
                    _headerStat(Icons.attach_money, c.isFree ? 'Free' : '\$${c.price?.toStringAsFixed(0)}', 'Price'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(children: [
          Icon(icon, size: 14, color: _orange),
          const SizedBox(width: 3),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  Widget _thumbPlaceholder() {
    return Container(
      width: 64, height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_orange.withValues(alpha: 0.4), _orange.withValues(alpha: 0.7)]),
      ),
      child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: _orange,
        unselectedLabelColor: Colors.grey,
        indicatorColor: _orange,
        indicatorWeight: 3,
        tabs: const [
          Tab(icon: Icon(Icons.playlist_play, size: 20), text: 'Lessons'),
          Tab(icon: Icon(Icons.people, size: 20), text: 'Students'),
          Tab(icon: Icon(Icons.quiz, size: 20), text: 'Quizzes'),
          Tab(icon: Icon(Icons.settings, size: 20), text: 'Details'),
        ],
      ),
    );
  }

  // ── TAB 0: LESSONS ──────────────────────────────────────────────────────

  Widget _buildLessonsTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: _lessons.isEmpty
          ? _buildLessonsEmpty()
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              onReorder: _reorderLessons,
              itemCount: _lessons.length,
              itemBuilder: (_, i) => _lessonCard(_lessons[i], i),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _lessonSaving ? null : _addLesson,
        icon: _lessonSaving
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.add),
        label: const Text('Add Lesson'),
        backgroundColor: _orange,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildLessonsEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.video_library_outlined, size: 64, color: _orange),
          ),
          const SizedBox(height: 20),
          const Text('No lessons yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Add your first lesson to get started', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addLesson,
            icon: const Icon(Icons.add),
            label: const Text('Add First Lesson'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _orange, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lessonCard(LessonModel lesson, int index) {
    return Container(
      key: ValueKey(lesson.id),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonEditorScreen(courseId: widget.courseId, lessonId: lesson.id),
            ),
          );
          _reloadLessons();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.drag_handle, color: _orange, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: _orange, borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text('${lesson.sequenceNumber}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.schedule, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 3),
                      Text('${lesson.totalDuration.inMinutes}m', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      const SizedBox(width: 10),
                      Icon(Icons.library_books, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 3),
                      Text('${lesson.contentIds.length} items', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      if (lesson.hasQuiz) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('Quiz', style: TextStyle(fontSize: 10, color: Colors.purple, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ]),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit Lesson')])),
                  const PopupMenuItem(value: 'quiz', child: Row(children: [Icon(Icons.quiz, size: 18, color: Colors.purple), SizedBox(width: 8), Text('Build Quiz')])),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
                ],
                onSelected: (val) async {
                  if (val == 'edit') {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => LessonEditorScreen(courseId: widget.courseId, lessonId: lesson.id)));
                    _reloadLessons();
                  } else if (val == 'quiz') {
                    await _navigateToQuizBuilder(lesson);
                  } else if (val == 'delete') {
                    _deleteLesson(lesson, index);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _reorderLessons(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    setState(() {
      final item = _lessons.removeAt(oldIndex);
      _lessons.insert(newIndex, item);
    });
    try {
      await _lessonService.reorderLessons(
        courseId: widget.courseId,
        lessonIds: _lessons.map((l) => l.id).toList(),
      );
    } catch (_) {}
  }

  // ── TAB 1: STUDENTS ─────────────────────────────────────────────────────

  Widget _buildStudentsTab() {
    if (_students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No students enrolled yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Students will appear here once they enroll', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _students.length,
      itemBuilder: (_, i) => _studentCard(_students[i]),
    );
  }

  Widget _studentCard(Map<String, dynamic> s) {
    final progress = (s['progress'] as double? ?? 0.0);
    final avgScore = (s['avgScore'] as double? ?? 0.0);
    final name = s['name'] as String? ?? '';
    final quizzesTaken = s['quizzesTaken'] as int? ?? 0;
    final enrolledAt = s['enrolledAt'] as DateTime?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _orange.withValues(alpha: 0.15),
                  radius: 22,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(color: _orange, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(s['email'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: progress >= 1.0 ? Colors.green.withValues(alpha: 0.1) : _orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    progress >= 1.0 ? 'Completed' : 'Active',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: progress >= 1.0 ? Colors.green[700] : Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Text('Progress', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                const Spacer(),
                Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: progress >= 1.0 ? Colors.green : _orange,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _studentStat(Icons.quiz_outlined, '$quizzesTaken', 'Quizzes Taken'),
                const SizedBox(width: 20),
                _studentStat(Icons.grade_outlined, '${avgScore.round()}%', 'Avg Score'),
                if (enrolledAt != null) ...[
                  const SizedBox(width: 20),
                  _studentStat(Icons.calendar_today_outlined,
                    '${enrolledAt.day}/${enrolledAt.month}/${enrolledAt.year}', 'Enrolled'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentStat(IconData icon, String value, String label) {
    return Row(children: [
      Icon(icon, size: 14, color: Colors.grey[500]),
      const SizedBox(width: 4),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ]),
    ]);
  }

  // ── TAB 2: QUIZZES ──────────────────────────────────────────────────────

  Widget _buildQuizzesTab() {
    if (_lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No lessons yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Add lessons first, then build quizzes for them', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(0),
              icon: const Icon(Icons.add),
              label: const Text('Add Lessons'),
              style: ElevatedButton.styleFrom(backgroundColor: _orange, foregroundColor: Colors.white),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lessons.length,
      itemBuilder: (_, i) => _quizLessonCard(_lessons[i]),
    );
  }

  Widget _quizLessonCard(LessonModel lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: lesson.hasQuiz ? Colors.purple.withValues(alpha: 0.1) : Colors.grey[100],
          child: Icon(
            lesson.hasQuiz ? Icons.quiz : Icons.quiz_outlined,
            color: lesson.hasQuiz ? Colors.purple : Colors.grey,
            size: 22,
          ),
        ),
        title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          lesson.hasQuiz ? 'Quiz ready — tap to edit' : 'No quiz yet — tap to add',
          style: TextStyle(fontSize: 12, color: lesson.hasQuiz ? Colors.purple : Colors.grey[500]),
        ),
        trailing: ElevatedButton(
          onPressed: () => _navigateToQuizBuilder(lesson),
          style: ElevatedButton.styleFrom(
            backgroundColor: lesson.hasQuiz ? Colors.purple : _orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(lesson.hasQuiz ? 'Edit Quiz' : 'Add Quiz', style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  // ── TAB 3: DETAILS ──────────────────────────────────────────────────────

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionCard('Course Information', [
            _textField(_titleCtrl, 'Course Title *', Icons.title),
            const SizedBox(height: 12),
            _textField(_subtitleCtrl, 'Subtitle', Icons.subtitles_outlined),
            const SizedBox(height: 12),
            _textField(_descCtrl, 'Description', Icons.description_outlined, maxLines: 4),
            const SizedBox(height: 12),
            _dropdownField<String>(
              'Category', _selectedCategory, _categories,
              (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 12),
            _dropdownField<String>(
              'Level', _selectedLevel, _levels,
              (v) => setState(() => _selectedLevel = v!),
            ),
          ]),
          const SizedBox(height: 16),
          _sectionCard('Thumbnail', [
            _textField(_thumbCtrl, 'Thumbnail Image URL', Icons.image_outlined),
            if (_thumbCtrl.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(_thumbCtrl.text, height: 120, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox()),
              ),
            ],
          ]),
          const SizedBox(height: 16),
          _sectionCard('Pricing', [
            SwitchListTile(
              value: _isFree,
              onChanged: (v) => setState(() => _isFree = v),
              activeColor: _orange,
              title: const Text('Free Course', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Students can enroll for free'),
            ),
            if (!_isFree) ...[
              const SizedBox(height: 8),
              _textField(_priceCtrl, 'Price (USD)', Icons.attach_money, keyboardType: TextInputType.number),
            ],
          ]),
          const SizedBox(height: 16),
          _sectionCard('Publish Status', [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _course!.isPublished ? Icons.public : Icons.lock_outline,
                color: _course!.isPublished ? Colors.green : Colors.orange,
              ),
              title: Text(_course!.isPublished ? 'Published' : 'Draft',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_course!.isPublished
                  ? 'Visible to students'
                  : 'Not visible to students'),
              trailing: OutlinedButton(
                onPressed: _togglePublish,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _course!.isPublished ? Colors.orange : Colors.green,
                  side: BorderSide(color: _course!.isPublished ? Colors.orange : Colors.green),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(_course!.isPublished ? 'Unpublish' : 'Publish'),
              ),
            ),
          ]),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _detailsSaving ? null : _saveDetails,
              icon: _detailsSaving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_outlined),
              label: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController ctrl, String label, IconData icon,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _dropdownField<T>(String label, T value, List<T> items, ValueChanged<T?> onChanged) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _orange, width: 2)),
        filled: true, fillColor: Colors.grey[50],
      ),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
    );
  }
}
