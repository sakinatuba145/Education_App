import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/teacher/services/teacher_quiz_service.dart';
import 'package:education_app/teacher/services/final_project_service.dart';
import 'package:education_app/teacher/screens/quiz_builder_screen.dart';
import 'package:education_app/teacher/screens/teacher_project_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _orange = Color(0xFFFFA726);
const _bg = Color(0xFFFFF8F0);

class TeacherCourseHubScreen extends StatefulWidget {
  final String courseId;
  const TeacherCourseHubScreen({super.key, required this.courseId});

  @override
  State<TeacherCourseHubScreen> createState() => _TeacherCourseHubScreenState();
}

class _TeacherCourseHubScreenState extends State<TeacherCourseHubScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TeacherCourseService _courseService = TeacherCourseService();
  final TeacherLessonService _lessonService = TeacherLessonService();
  final TeacherQuizService _quizService = TeacherQuizService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CourseModel? _course;
  List<LessonModel> _lessons = [];
  List<Map<String, dynamic>> _students = [];
  Map<String, int> _quizCounts = {};
  bool _loading = true;

  // Overview form
  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _thumbCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _selectedCategory = 'Programming';
  String _selectedLevel = 'beginner';
  bool _isFree = true;
  bool _overviewSaving = false;

  // Thumbnail upload state
  Uint8List? _thumbBytes;
  bool _uploadingThumb = false;
  double _thumbProgress = 0;

  static const _categories = [
    'Programming', 'Web Development', 'Mobile Development',
    'Data Science', 'Design', 'Business', 'Mathematics',
    'Science', 'Language', 'History', 'Art', 'Other'
  ];
  static const _levels = ['beginner', 'intermediate', 'advanced'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _descCtrl.dispose();
    _thumbCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final course = await _courseService.getCourseById(widget.courseId);
      final lessons = await _lessonService.getCourseLessons(widget.courseId);
      await _loadStudents();
      await _loadQuizCounts(lessons);
      if (mounted) {
        setState(() {
          _course = course;
          _lessons = lessons;
          _loading = false;
          _titleCtrl.text = course.title;
          _subtitleCtrl.text = course.subtitle;
          _descCtrl.text = course.description;
          _thumbCtrl.text = course.thumbnailUrl ?? '';
          _priceCtrl.text = course.price?.toStringAsFixed(0) ?? '';
          _selectedCategory = _categories.contains(course.category) ? course.category : 'Programming';
          _selectedLevel = _levels.contains(course.level) ? course.level : 'beginner';
          _isFree = course.isFree;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }


  Future<void> _loadStudents() async {
    try {
      final snap = await _db
          .collection('courses').doc(widget.courseId).collection('enrollments').get();
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
        final quizSnap = await _db
            .collection('users').doc(uid).collection('quiz_results')
            .where('courseId', isEqualTo: widget.courseId).get();
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
          'lessonsCompleted': data['lessonsCompleted'] ?? 0,
        });
      }
      _students = students;
    } catch (_) {}
  }

  Future<void> _loadQuizCounts(List<LessonModel> lessons) async {
    final counts = <String, int>{};
    for (final lesson in lessons) {
      try {
        final snap = await _db
            .collection('courses').doc(widget.courseId)
            .collection('lessons').doc(lesson.id)
            .collection('quizzes').get();
        counts[lesson.id] = snap.docs.length;
      } catch (_) {
        counts[lesson.id] = 0;
      }
    }
    if (mounted) setState(() => _quizCounts = counts);
  }

  Future<void> _refreshLessons() async {
    final lessons = await _lessonService.getCourseLessons(widget.courseId);
    await _loadQuizCounts(lessons);
    if (mounted) setState(() => _lessons = lessons);
  }

  @override
  Widget build(BuildContext context) {
    final title = _course?.title ?? 'Course Studio';
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Course Studio',
                style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        actions: [
          if (_course != null)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _course!.isPublished
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _course!.isPublished ? 'Published' : 'Draft',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _course!.isPublished ? Colors.green[700] : Colors.orange[700],
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: _orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: _orange,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          tabs: const [
            Tab(icon: Icon(Icons.tune_rounded, size: 18), text: 'Overview'),
            Tab(icon: Icon(Icons.play_lesson_rounded, size: 18), text: 'Content'),
            Tab(icon: Icon(Icons.quiz_rounded, size: 18), text: 'Quiz'),
            Tab(icon: Icon(Icons.people_alt_rounded, size: 18), text: 'Students'),
            Tab(icon: Icon(Icons.bar_chart_rounded, size: 18), text: 'Analytics'),
            Tab(icon: Icon(Icons.assignment_rounded, size: 18), text: 'Project'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _orange))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildContentTab(),
                _buildQuizTab(),
                _buildStudentsTab(),
                _buildAnalyticsTab(),
                _buildProjectTab(),
              ],
            ),
    );
  }

  // ── TAB 0: OVERVIEW ──────────────────────────────────────────────────────

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail upload area ─────────────────────────────────────────
          GestureDetector(
            onTap: _uploadingThumb ? null : _pickAndUploadThumb,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _thumbBytes != null
                      ? _orange
                      : Colors.grey.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(fit: StackFit.expand, children: [
                  // Preview: newly-picked bytes > existing URL > placeholder
                  if (_thumbBytes != null)
                    Image.memory(_thumbBytes!, fit: BoxFit.cover)
                  else if (_thumbCtrl.text.isNotEmpty)
                    Image.network(_thumbCtrl.text, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _thumbPlaceholder())
                  else
                    _thumbPlaceholder(),

                  // Upload progress overlay
                  if (_uploadingThumb)
                    Container(
                      color: Colors.black.withValues(alpha: 0.55),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 48, height: 48,
                            child: CircularProgressIndicator(
                              value: _thumbProgress > 0 ? _thumbProgress : null,
                              color: Colors.white, strokeWidth: 3),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _thumbProgress > 0
                                ? 'Uploading… ${(_thumbProgress * 100).toInt()}%'
                                : 'Preparing…',
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),

                  // Edit badge
                  if (!_uploadingThumb)
                    Positioned(
                      bottom: 10, right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.60),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.edit_rounded, size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Change cover',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                ]),
              ),
            ),
          ),

          const SizedBox(height: 20),
          _sectionLabel('Course Info'),
          const SizedBox(height: 12),

          _field(_titleCtrl, 'Course Title *', Icons.title_rounded),
          const SizedBox(height: 12),
          _field(_subtitleCtrl, 'Subtitle / Tagline', Icons.subtitles_outlined),
          const SizedBox(height: 12),
          _field(_descCtrl, 'Description', Icons.description_outlined, maxLines: 4),
          const SizedBox(height: 16),

          _sectionLabel('Details'),
          const SizedBox(height: 12),

          Row(children: [
            Expanded(child: _dropdown('Category', _categories, _selectedCategory,
                (v) => setState(() => _selectedCategory = v!))),
            const SizedBox(width: 12),
            Expanded(child: _dropdown('Level', _levels, _selectedLevel,
                (v) => setState(() => _selectedLevel = v!))),
          ]),
          const SizedBox(height: 16),

          _sectionLabel('Pricing'),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isFree = true),
                child: _pricingCard('Free', Icons.volunteer_activism_rounded,
                    Colors.green, _isFree),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isFree = false),
                child: _pricingCard('Paid', Icons.attach_money_rounded,
                    Colors.blue, !_isFree),
              ),
            ),
          ]),
          if (!_isFree) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: InputDecoration(
                labelText: 'Price (USD)',
                prefixText: '\$ ',
                prefixIcon: const Icon(Icons.attach_money_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true, fillColor: Colors.white,
              ),
            ),
          ],
          const SizedBox(height: 24),

          _sectionLabel('Status'),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _toggleStatus('draft'),
                child: _statusCard('Draft', Icons.edit_note_rounded,
                    Colors.orange, _course?.status == 'draft'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _toggleStatus('published'),
                child: _statusCard('Published', Icons.public_rounded,
                    Colors.green, _course?.status == 'published'),
              ),
            ),
          ]),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _overviewSaving ? null : _saveOverview,
              style: FilledButton.styleFrom(
                backgroundColor: _orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _overviewSaving
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_rounded),
              label: Text(_overviewSaving ? 'Saving…' : 'Save Changes',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadThumb() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    setState(() {
      _thumbBytes = bytes;
      _uploadingThumb = true;
      _thumbProgress = 0;
    });

    try {
      final ext = file.name.split('.').last.toLowerCase();
      final contentType = ext == 'png' ? 'image/png' : 'image/jpeg';
      final ts = DateTime.now().millisecondsSinceEpoch;
      final path =
          'uploads/teacher_courses/${user.uid}/thumbnails/${widget.courseId}_${ts}_thumb.$ext';

      final task = FirebaseStorage.instance
          .ref(path)
          .putData(bytes, SettableMetadata(contentType: contentType));

      task.snapshotEvents.listen((snap) {
        if (mounted) {
          setState(() =>
              _thumbProgress = snap.bytesTransferred / snap.totalBytes);
        }
      });

      await task;
      final url =
          await FirebaseStorage.instance.ref(path).getDownloadURL();

      if (mounted) {
        setState(() {
          _thumbCtrl.text = url;
          _uploadingThumb = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Cover image uploaded — tap Save Changes to apply'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() { _uploadingThumb = false; _thumbBytes = null; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Upload failed: $e'),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  Future<void> _saveOverview() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course title is required'), backgroundColor: Colors.red));
      return;
    }
    setState(() => _overviewSaving = true);
    try {
      final data = {
        'title': _titleCtrl.text.trim(),
        'subtitle': _subtitleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'thumbnailUrl': _thumbCtrl.text.trim().isEmpty ? null : _thumbCtrl.text.trim(),
        'category': _selectedCategory,
        'level': _selectedLevel,
        'isFree': _isFree,
        'price': _isFree ? null : double.tryParse(_priceCtrl.text.trim()),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      await _courseService.updateCourse(courseId: widget.courseId, data: data);
      final updated = await _courseService.getCourseById(widget.courseId);
      if (mounted) {
        setState(() { _course = updated; _overviewSaving = false; });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Course updated!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _overviewSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
      }
    }
  }

  Future<void> _toggleStatus(String status) async {
    try {
      await _courseService.updateCourse(courseId: widget.courseId, data: {'status': status});
      final updated = await _courseService.getCourseById(widget.courseId);
      if (mounted) setState(() => _course = updated);
    } catch (_) {}
  }

  // ── TAB 1: CONTENT ───────────────────────────────────────────────────────

  Widget _buildContentTab() {
    return Column(
      children: [
        _contentHeader(),
        Expanded(
          child: _lessons.isEmpty
              ? _emptyContent()
              : ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: _lessons.length,
                  onReorder: _reorderLessons,
                  itemBuilder: (_, i) => _LessonCard(
                    key: ValueKey(_lessons[i].id),
                    lesson: _lessons[i],
                    index: i,
                    courseId: widget.courseId,
                    quizCount: _quizCounts[_lessons[i].id] ?? 0,
                    onSaved: _refreshLessons,
                    onDelete: () => _deleteLesson(_lessons[i]),
                    onQuiz: () => _openQuizBuilder(_lessons[i]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _contentHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_lessons.length} lesson${_lessons.length == 1 ? '' : 's'}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Drag to reorder · Tap to edit',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: _addLesson,
            style: FilledButton.styleFrom(
              backgroundColor: _orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Lesson'),
          ),
        ],
      ),
    );
  }

  Widget _emptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.video_library_outlined, size: 56, color: _orange),
          ),
          const SizedBox(height: 20),
          const Text('No lessons yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Add your first lesson to get started',
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _addLesson,
            style: FilledButton.styleFrom(
              backgroundColor: _orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add First Lesson', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _addLesson() async {
    final titleCtrl = TextEditingController();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_lesson_rounded, color: _orange, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('New Lesson',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Lesson Title *',
                hintText: 'e.g. Introduction to Flutter',
                prefixIcon: const Icon(Icons.title_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true, fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (titleCtrl.text.trim().isNotEmpty) Navigator.pop(ctx, true);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Create Lesson', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || titleCtrl.text.trim().isEmpty) return;

    try {
      final newLesson = LessonModel(
        id: '',
        courseId: widget.courseId,
        title: titleCtrl.text.trim(),
        description: '',
        sequenceNumber: _lessons.length + 1,
        contentIds: [],
        totalViews: 0,
        totalCompleted: 0,
        averageRating: 0,
        totalDuration: Duration.zero,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final newId = await _lessonService.createLesson(courseId: widget.courseId, lesson: newLesson);
      await _courseService.updateCourse(
          courseId: widget.courseId, data: {'totalLessons': _lessons.length + 1});
      await _refreshLessons();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lesson "${titleCtrl.text.trim()}" created! Tap to edit.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
      }
    }
  }

  Future<void> _deleteLesson(LessonModel lesson) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Lesson'),
        content: Text('Delete "${lesson.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _lessonService.deleteLesson(courseId: widget.courseId, lessonId: lesson.id);
      await _courseService.updateCourse(
          courseId: widget.courseId, data: {'totalLessons': (_lessons.length - 1).clamp(0, 9999)});
      await _refreshLessons();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
  }

  Future<void> _reorderLessons(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final lessons = List<LessonModel>.from(_lessons);
    final item = lessons.removeAt(oldIndex);
    lessons.insert(newIndex, item);
    setState(() => _lessons = lessons);
    for (int i = 0; i < lessons.length; i++) {
      _db.collection('courses').doc(widget.courseId)
          .collection('lessons').doc(lessons[i].id)
          .update({'sequenceNumber': i + 1}).catchError((_) {});
    }
  }

  // ── TAB 2: QUIZ ──────────────────────────────────────────────────────────

  Widget _buildQuizTab() {
    if (_lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('Add lessons first', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            const SizedBox(height: 8),
            Text('Create lessons in the Content tab, then add quizzes here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 13)),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _tabController.animateTo(1),
              style: FilledButton.styleFrom(backgroundColor: _orange),
              child: const Text('Go to Content'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lessons.length,
      itemBuilder: (_, i) {
        final lesson = _lessons[i];
        final qCount = _quizCounts[lesson.id] ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: qCount > 0
                    ? Colors.green.withValues(alpha: 0.1)
                    : _orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                qCount > 0 ? Icons.quiz_rounded : Icons.add_circle_outline_rounded,
                color: qCount > 0 ? Colors.green : _orange, size: 22,
              ),
            ),
            title: Text(lesson.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(
              qCount > 0 ? '$qCount question${qCount == 1 ? '' : 's'}' : 'No quiz yet',
              style: TextStyle(
                fontSize: 12,
                color: qCount > 0 ? Colors.green[700] : Colors.grey[500],
                fontWeight: qCount > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: FilledButton.icon(
              onPressed: () => _openQuizBuilder(lesson),
              style: FilledButton.styleFrom(
                backgroundColor: qCount > 0 ? Colors.blue : _orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: Icon(qCount > 0 ? Icons.edit_rounded : Icons.add, size: 16),
              label: Text(qCount > 0 ? 'Edit' : 'Add Quiz',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openQuizBuilder(LessonModel lesson) async {
    try {
      final snap = await _db
          .collection('courses').doc(widget.courseId)
          .collection('lessons').doc(lesson.id)
          .collection('quizzes').limit(1).get();
      String quizId;
      String quizTitle;
      if (snap.docs.isNotEmpty) {
        quizId = snap.docs.first.id;
        quizTitle = snap.docs.first.data()['title'] ?? '${lesson.title} Quiz';
      } else {
        final ref = await _db
            .collection('courses').doc(widget.courseId)
            .collection('lessons').doc(lesson.id)
            .collection('quizzes').add({
          'title': '${lesson.title} Quiz',
          'courseId': widget.courseId,
          'lessonId': lesson.id,
          'questions': [],
          'passingScore': 70,
          'createdAt': FieldValue.serverTimestamp(),
        });
        quizId = ref.id;
        quizTitle = '${lesson.title} Quiz';
      }
      if (mounted) {
        await Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizBuilderScreen(
            courseId: widget.courseId,
            lessonId: lesson.id,
            quizId: quizId,
            quizTitle: quizTitle,
          ),
        ));
        await _loadQuizCounts(_lessons);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    }
  }

  // ── TAB 3: STUDENTS ──────────────────────────────────────────────────────

  Widget _buildStudentsTab() {
    if (_students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.people_outline_rounded, size: 56, color: Colors.blue[300]),
            ),
            const SizedBox(height: 20),
            const Text('No students yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Students will appear here once they enroll',
                style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          ],
        ),
      );
    }
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Text('${_students.length} enrolled',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              _miniStat('Avg Progress',
                  '${(_students.fold(0.0, (s, st) => s + (st['progress'] as double)) / _students.length * 100).toStringAsFixed(0)}%',
                  Colors.blue),
              const SizedBox(width: 12),
              _miniStat('Avg Score',
                  '${(_students.where((s) => s['quizzesTaken'] > 0).isEmpty ? 0 : _students.where((s) => s['quizzesTaken'] > 0).fold(0.0, (s, st) => s + (st['avgScore'] as double)) / _students.where((s) => s['quizzesTaken'] > 0).length).toStringAsFixed(0)}%',
                  Colors.green),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadStudents();
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _students.length,
              itemBuilder: (_, i) => _studentCard(_students[i], i),
            ),
          ),
        ),
      ],
    );
  }

  Widget _studentCard(Map<String, dynamic> student, int index) {
    final progress = (student['progress'] as double).clamp(0.0, 1.0);
    final name = student['name'] as String;
    final email = student['email'] as String;
    final avgScore = student['avgScore'] as double;
    final quizzesTaken = student['quizzesTaken'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _orange.withValues(alpha: 0.12),
                child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(color: _orange, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(email, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: progress >= 1.0
                          ? Colors.green.withValues(alpha: 0.1)
                          : _orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      progress >= 1.0 ? 'Completed' : 'In Progress',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: progress >= 1.0 ? Colors.green[700] : Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('Progress', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              Text('${(progress * 100).toInt()}%',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[100],
              valueColor: AlwaysStoppedAnimation(
                  progress >= 1.0 ? Colors.green : _orange),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _studentStatChip(Icons.quiz_rounded, '$quizzesTaken quiz${quizzesTaken == 1 ? '' : 'zes'}', Colors.purple),
              const SizedBox(width: 8),
              if (quizzesTaken > 0)
                _studentStatChip(Icons.star_rounded,
                    '${avgScore.toStringAsFixed(0)}% avg', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _studentStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  // ── TAB 4: ANALYTICS ─────────────────────────────────────────────────────

  Widget _buildAnalyticsTab() {
    final enrolled = _course?.totalEnrolled ?? _students.length;
    final totalLessons = _lessons.length;
    final avgProgress = _students.isEmpty
        ? 0.0
        : _students.fold(0.0, (s, st) => s + (st['progress'] as double)) / _students.length * 100;
    final studentsWithQuiz = _students.where((s) => (s['quizzesTaken'] as int) > 0).toList();
    final avgQuiz = studentsWithQuiz.isEmpty
        ? 0.0
        : studentsWithQuiz.fold(0.0, (s, st) => s + (st['avgScore'] as double)) / studentsWithQuiz.length;
    final completed = _students.where((s) => (s['progress'] as double) >= 1.0).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Overview'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _analyticsCard('Enrolled', '$enrolled', Icons.people_rounded, Colors.blue),
              _analyticsCard('Completed', '$completed', Icons.check_circle_rounded, Colors.green),
              _analyticsCard('Avg Progress', '${avgProgress.toStringAsFixed(0)}%', Icons.trending_up_rounded, _orange),
              _analyticsCard('Avg Quiz Score', '${avgQuiz.toStringAsFixed(0)}%', Icons.quiz_rounded, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),

          if (totalLessons > 0) ...[
            _sectionLabel('Per-Lesson Completion'),
            const SizedBox(height: 12),
            ..._lessons.map((lesson) {
              final views = lesson.totalViews;
              final done = lesson.totalCompleted;
              final rate = views > 0 ? (done / views).clamp(0.0, 1.0) : 0.0;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: _orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('${lesson.sequenceNumber}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _orange)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(lesson.title,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        Text('${(rate * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold,
                              color: rate >= 0.7 ? Colors.green : _orange,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: rate,
                        minHeight: 6,
                        backgroundColor: Colors.grey[100],
                        valueColor: AlwaysStoppedAnimation(rate >= 0.7 ? Colors.green : _orange),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('$done of $views students completed',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
              );
            }),
          ],

          if (_students.isNotEmpty) ...[
            const SizedBox(height: 8),
            _sectionLabel('Student Performance'),
            const SizedBox(height: 12),
            ..._students.take(5).map((s) {
              final p = ((s['progress'] as double) * 100).toInt();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: _orange.withValues(alpha: 0.12),
                      child: Text(
                        (s['name'] as String).isNotEmpty ? (s['name'] as String)[0].toUpperCase() : '?',
                        style: const TextStyle(color: _orange, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(s['name'] as String,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                              Text('$p%', style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold,
                                  color: p >= 70 ? Colors.green : _orange)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: (s['progress'] as double).clamp(0.0, 1.0),
                              minHeight: 5,
                              backgroundColor: Colors.grey[100],
                              valueColor: AlwaysStoppedAnimation(p >= 100 ? Colors.green : _orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────────────

  Widget _analyticsCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _thumbPlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [_orange.withValues(alpha: 0.3), _orange.withValues(alpha: 0.6)],
        ),
      ),
      child: const Icon(Icons.play_circle_outline_rounded, size: 48, color: Colors.white),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true, fillColor: Colors.white,
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, String value, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _pricingCard(String label, IconData icon, Color color, bool selected) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selected ? color.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? color : Colors.grey[200]!,
          width: selected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: selected ? color : Colors.grey, size: 24),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? color : Colors.grey[600],
              fontSize: 13)),
        ],
      ),
    );
  }

  Widget _statusCard(String label, IconData icon, Color color, bool selected) =>
      _pricingCard(label, icon, color, selected);

  Widget _sectionLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
        color: Colors.grey, letterSpacing: 0.5));
  }

  Widget _miniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // ── TAB 5: PROJECT ────────────────────────────────────────────────────────
  Widget _buildProjectTab() => TeacherProjectTab(courseId: widget.courseId);
}

// ── LESSON CARD with inline editor ──────────────────────────────────────────

class _LessonCard extends StatefulWidget {
  final LessonModel lesson;
  final int index;
  final String courseId;
  final int quizCount;
  final VoidCallback onSaved;
  final VoidCallback onDelete;
  final VoidCallback onQuiz;

  const _LessonCard({
    super.key,
    required this.lesson,
    required this.index,
    required this.courseId,
    required this.quizCount,
    required this.onSaved,
    required this.onDelete,
    required this.onQuiz,
  });

  @override
  State<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<_LessonCard> {
  bool _expanded = false;
  bool _saving = false;

  final _titleCtrl = TextEditingController();
  final _youtubeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _assignTitleCtrl = TextEditingController();
  final _assignInstrCtrl = TextEditingController();
  bool _hasAssignment = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = FirebaseFirestore.instance;
    try {
      final doc = await db
          .collection('courses').doc(widget.courseId)
          .collection('lessons').doc(widget.lesson.id).get();
      final data = doc.data() ?? {};
      if (mounted) {
        setState(() {
          _titleCtrl.text = data['title'] ?? widget.lesson.title;
          _youtubeCtrl.text = data['youtubeUrl'] ?? '';
          _notesCtrl.text = data['notes'] ?? '';
          _assignTitleCtrl.text = data['assignmentTitle'] ?? '';
          _assignInstrCtrl.text = data['assignmentInstructions'] ?? '';
          _hasAssignment = (data['assignmentTitle'] ?? '').toString().isNotEmpty;
        });
      }
    } catch (_) {
      _titleCtrl.text = widget.lesson.title;
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance
          .collection('courses').doc(widget.courseId)
          .collection('lessons').doc(widget.lesson.id)
          .update({
        'title': _titleCtrl.text.trim(),
        'youtubeUrl': _youtubeCtrl.text.trim(),
        'notes': _notesCtrl.text.trim(),
        'assignmentTitle': _hasAssignment ? _assignTitleCtrl.text.trim() : '',
        'assignmentInstructions': _hasAssignment ? _assignInstrCtrl.text.trim() : '',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      if (mounted) {
        setState(() { _saving = false; _expanded = false; });
        widget.onSaved();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Lesson saved!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _youtubeCtrl.dispose();
    _notesCtrl.dispose();
    _assignTitleCtrl.dispose();
    _assignInstrCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasYoutube = _youtubeCtrl.text.isNotEmpty;
    final hasNotes = _notesCtrl.text.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: _expanded ? Border.all(color: _orange, width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // ── Collapsed header ──
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ReorderableDragStartListener(
                    index: widget.index,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.lesson.sequenceNumber}'.padLeft(2, '0'),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _orange),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_titleCtrl.text.isEmpty ? widget.lesson.title : _titleCtrl.text,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(children: [
                          _pill(Icons.play_circle_outline_rounded,
                              hasYoutube ? 'Video' : 'No video',
                              hasYoutube ? Colors.red : Colors.grey),
                          const SizedBox(width: 6),
                          _pill(Icons.notes_rounded,
                              hasNotes ? 'Notes' : 'No notes',
                              hasNotes ? Colors.blue : Colors.grey),
                          const SizedBox(width: 6),
                          _pill(Icons.quiz_rounded,
                              widget.quizCount > 0 ? '${widget.quizCount}Q' : 'No quiz',
                              widget.quizCount > 0 ? Colors.green : Colors.grey),
                        ]),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: const Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')]),
                        onTap: () => setState(() => _expanded = true),
                      ),
                      PopupMenuItem(
                        child: const Row(children: [
                          Icon(Icons.quiz_rounded, size: 18, color: Colors.purple),
                          SizedBox(width: 8), Text('Quiz'),
                        ]),
                        onTap: widget.onQuiz,
                      ),
                      PopupMenuItem(
                        child: const Row(children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red)),
                        ]),
                        onTap: widget.onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded editor ──
          if (_expanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  _editorField(_titleCtrl, 'Lesson Title *', Icons.title_rounded),
                  const SizedBox(height: 12),

                  // YouTube URL
                  _editorField(_youtubeCtrl, 'YouTube URL', Icons.play_circle_outline_rounded,
                      hint: 'https://youtube.com/watch?v=...'),
                  if (_youtubeCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text('Video will be embedded for students',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                  ],
                  const SizedBox(height: 12),

                  // Notes
                  _editorField(_notesCtrl, 'Lesson Notes / Description', Icons.notes_rounded,
                      maxLines: 5, hint: 'Enter lesson content, key points, summary...'),
                  const SizedBox(height: 16),

                  // Assignment toggle
                  Row(
                    children: [
                      const Text('Assignment', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const Spacer(),
                      Switch.adaptive(
                        value: _hasAssignment,
                        activeColor: _orange,
                        onChanged: (v) => setState(() => _hasAssignment = v),
                      ),
                    ],
                  ),
                  if (_hasAssignment) ...[
                    const SizedBox(height: 8),
                    _editorField(_assignTitleCtrl, 'Assignment Title', Icons.assignment_outlined),
                    const SizedBox(height: 10),
                    _editorField(_assignInstrCtrl, 'Instructions', Icons.list_alt_rounded,
                        maxLines: 3, hint: 'Describe what students need to do...'),
                  ],
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _expanded = false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: _saving ? null : _save,
                          style: FilledButton.styleFrom(
                            backgroundColor: _orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: _saving
                              ? const SizedBox(width: 16, height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.save_rounded, size: 18),
                          label: Text(_saving ? 'Saving…' : 'Save Lesson',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _editorField(TextEditingController ctrl, String label, IconData icon,
      {int maxLines = 1, String? hint}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: maxLines == 1 ? Icon(icon, size: 20) : null,
        prefixIconConstraints: maxLines > 1
            ? null
            : const BoxConstraints(minWidth: 48, minHeight: 48),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true, fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
            horizontal: maxLines > 1 ? 14 : 0, vertical: 14),
      ),
    );
  }

  Widget _pill(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
