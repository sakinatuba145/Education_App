import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/teacher/services/final_project_service.dart';
import 'package:education_app/teacher/screens/quiz_builder_screen.dart';
import 'package:education_app/teacher/widgets/studio_submissions_hub.dart';
import 'package:education_app/teacher/widgets/studio_analytics_hub.dart';

const _amber = Color(0xFFFFA726);
const _dark = Color(0xFF1E1E2E);

// ─────────────────────────────────────────────────────────────────────────────
// COURSE STUDIO — unified course management workspace
// ─────────────────────────────────────────────────────────────────────────────

class CourseStudioScreen extends StatefulWidget {
  final String courseId;
  const CourseStudioScreen({super.key, required this.courseId});

  @override
  State<CourseStudioScreen> createState() => _CourseStudioScreenState();
}

class _CourseStudioScreenState extends State<CourseStudioScreen> {
  final TeacherCourseService _courseService = TeacherCourseService();

  int _navIndex = 1; // default to Lessons
  bool _sidebarExpanded = true;
  CourseModel? _course;
  bool _loading = true;

  static const _navItems = [
    _NavItem(Icons.tune_rounded, 'Overview'),
    _NavItem(Icons.video_library_rounded, 'Lessons'),
    _NavItem(Icons.quiz_rounded, 'Quizzes'),
    _NavItem(Icons.assignment_rounded, 'Assignments'),
    _NavItem(Icons.grading_rounded, 'Submissions'),
    _NavItem(Icons.people_alt_rounded, 'Students'),
    _NavItem(Icons.bar_chart_rounded, 'Analytics'),
  ];

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    try {
      final course = await _courseService.getCourseById(widget.courseId);
      if (mounted) setState(() { _course = course; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _togglePublish() async {
    if (_course == null) return;
    if (_course!.isPublished) {
      await _courseService.saveDraft(widget.courseId);
    } else {
      await _courseService.publishCourse(widget.courseId);
    }
    await _loadCourse();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 820;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      drawer: isWide ? null : _buildMobileDrawer(),
      appBar: _buildAppBar(isWide),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _amber))
          : isWide
              ? Row(
                  children: [
                    _buildSidebar(isWide),
                    Expanded(child: _buildPanel()),
                  ],
                )
              : _buildPanel(),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isWide) {
    final published = _course?.isPublished ?? false;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: isWide
          ? IconButton(
              icon: AnimatedRotation(
                turns: _sidebarExpanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.menu_rounded, color: Colors.black87),
              ),
              onPressed: () => setState(() => _sidebarExpanded = !_sidebarExpanded),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Course Studio', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(_course?.title ?? 'Loading…',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      actions: [
        if (!isWide)
          Builder(builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          )),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: FilledButton.icon(
            onPressed: _togglePublish,
            style: FilledButton.styleFrom(
              backgroundColor: published ? Colors.green : _amber,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: Icon(published ? Icons.public_rounded : Icons.public_off_rounded, size: 16),
            label: Text(published ? 'Published' : 'Publish', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: _dark,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(_course?.title ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          const Divider(color: Colors.white12),
          ...List.generate(_navItems.length, (i) => _sidebarTile(i, expanded: true, onTap: () {
            setState(() => _navIndex = i);
            Navigator.pop(context);
          })),
        ],
      ),
    );
  }

  Widget _buildSidebar(bool isWide) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: _sidebarExpanded ? 200 : 68,
      color: _dark,
      child: Column(
        children: [
          const SizedBox(height: 12),
          if (_sidebarExpanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.school_rounded, color: _amber, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(_course?.title ?? '',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (_course?.isPublished ?? false) ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (_course?.isPublished ?? false) ? 'Published' : 'Draft',
                      style: TextStyle(
                        fontSize: 10,
                        color: (_course?.isPublished ?? false) ? Colors.green[300] : Colors.orange[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 16),
          ] else
            const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: List.generate(_navItems.length, (i) => _sidebarTile(i, expanded: _sidebarExpanded)),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: _sidebarExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back_rounded, color: Colors.white38, size: 18),
                  if (_sidebarExpanded) ...[
                    const SizedBox(width: 12),
                    const Text('Back to courses', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sidebarTile(int index, {required bool expanded, VoidCallback? onTap}) {
    final item = _navItems[index];
    final selected = _navIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        onTap: onTap ?? () => setState(() => _navIndex = index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: expanded ? 12 : 0, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? _amber.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? _amber.withValues(alpha: 0.3) : Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 20, color: selected ? _amber : Colors.white54),
              if (expanded) ...[
                const SizedBox(width: 12),
                Text(item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      color: selected ? _amber : Colors.white60,
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    switch (_navIndex) {
      case 0: return _StudioOverviewPanel(courseId: widget.courseId, course: _course, onSaved: _loadCourse);
      case 1: return _StudioLessonsPanel(courseId: widget.courseId);
      case 2: return _StudioQuizzesPanel(courseId: widget.courseId);
      case 3: return _StudioAssignmentsPanel(courseId: widget.courseId);
      case 4: return StudioSubmissionsHub(courseId: widget.courseId);
      case 5: return _StudioStudentsPanel(courseId: widget.courseId);
      case 6: return StudioAnalyticsHub(courseId: widget.courseId);
      default: return _StudioLessonsPanel(courseId: widget.courseId);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV ITEM MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

// ─────────────────────────────────────────────────────────────────────────────
// PANEL 0: OVERVIEW
// ─────────────────────────────────────────────────────────────────────────────

class _StudioOverviewPanel extends StatefulWidget {
  final String courseId;
  final CourseModel? course;
  final VoidCallback onSaved;
  const _StudioOverviewPanel({required this.courseId, required this.course, required this.onSaved});

  @override
  State<_StudioOverviewPanel> createState() => _StudioOverviewPanelState();
}

class _StudioOverviewPanelState extends State<_StudioOverviewPanel> {
  final _courseService = TeacherCourseService();
  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _thumbCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool _isFree = true;
  String _category = 'Programming';
  String _level = 'beginner';
  bool _saving = false;

  static const _categories = ['Programming','Web Development','Mobile Development','Data Science','Design','Business','Mathematics','Science','Language','Art','Other'];
  static const _levels = ['beginner','intermediate','advanced'];

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    if (c != null) {
      _titleCtrl.text = c.title;
      _subtitleCtrl.text = c.subtitle;
      _descCtrl.text = c.description;
      _thumbCtrl.text = c.thumbnailUrl ?? '';
      _priceCtrl.text = c.price?.toStringAsFixed(0) ?? '';
      _isFree = c.isFree;
      _category = _categories.contains(c.category) ? c.category : 'Programming';
      _level = _levels.contains(c.level) ? c.level : 'beginner';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose(); _subtitleCtrl.dispose(); _descCtrl.dispose();
    _thumbCtrl.dispose(); _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Course Overview', 'Edit your course info and settings'),
          const SizedBox(height: 24),

          // Thumbnail preview
          if (_thumbCtrl.text.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(_thumbCtrl.text, height: 160, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox()),
            ),
            const SizedBox(height: 16),
          ],

          _card([
            _field(_thumbCtrl, 'Thumbnail URL', Icons.image_rounded),
            const SizedBox(height: 14),
            _field(_titleCtrl, 'Course Title *', Icons.title_rounded),
            const SizedBox(height: 14),
            _field(_subtitleCtrl, 'Subtitle', Icons.short_text_rounded),
            const SizedBox(height: 14),
            _field(_descCtrl, 'Description', Icons.description_rounded, maxLines: 4),
          ]),
          const SizedBox(height: 16),

          _card([
            Row(children: [
              Expanded(child: _dropdown('Category', _categories, _category, (v) => setState(() => _category = v!))),
              const SizedBox(width: 12),
              Expanded(child: _dropdown('Level', _levels, _level, (v) => setState(() => _level = v!))),
            ]),
          ]),
          const SizedBox(height: 16),

          _card([
            Row(children: [
              const Icon(Icons.attach_money_rounded, color: _amber),
              const SizedBox(width: 8),
              const Text('Pricing', style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _isFree,
              onChanged: (v) => setState(() => _isFree = v),
              title: Text(_isFree ? 'Free Course' : 'Paid Course',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(_isFree ? 'Anyone can enroll for free' : 'Students pay to enroll'),
              activeColor: _amber,
              contentPadding: EdgeInsets.zero,
            ),
            if (!_isFree) ...[
              const SizedBox(height: 8),
              _field(_priceCtrl, 'Price (USD)', Icons.monetization_on_outlined, isNumber: true),
            ],
          ]),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: _amber,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_rounded),
              label: Text(_saving ? 'Saving…' : 'Save Changes', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final current = widget.course;
      if (current == null) return;
      final updated = CourseModel(
        id: current.id, teacherId: current.teacherId,
        instructorName: current.instructorName,
        title: _titleCtrl.text.trim(), subtitle: _subtitleCtrl.text.trim(),
        description: _descCtrl.text.trim(), category: _category, level: _level,
        tags: current.tags, language: current.language,
        prerequisites: current.prerequisites,
        thumbnailUrl: _thumbCtrl.text.trim().isEmpty ? null : _thumbCtrl.text.trim(),
        price: _isFree ? null : double.tryParse(_priceCtrl.text),
        isFree: _isFree, totalLessons: current.totalLessons,
        totalEnrolled: current.totalEnrolled, totalCompleted: current.totalCompleted,
        totalDurationHours: current.totalDurationHours,
        averageRating: current.averageRating, totalReviews: current.totalReviews,
        totalRevenue: current.totalRevenue,
        status: current.status, visibility: current.visibility,
        slug: current.slug, keywords: current.keywords,
        createdAt: current.createdAt, updatedAt: DateTime.now(),
      );
      await _courseService.updateCourse(courseId: updated.id, data: {
        'title': updated.title, 'subtitle': updated.subtitle,
        'description': updated.description, 'category': updated.category,
        'level': updated.level, 'isFree': updated.isFree,
        'price': updated.price, 'thumbnailUrl': updated.thumbnailUrl,
      });
      widget.onSaved();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Course updated!'), backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {int maxLines = 1, bool isNumber = false}) {
    return TextField(
      controller: ctrl, maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: maxLines == 1 ? Icon(icon, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true, fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, String value, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value, onChanged: onChanged, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true, fillColor: Colors.grey[50], contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
      isExpanded: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PANEL 1: LESSONS
// ─────────────────────────────────────────────────────────────────────────────

class _StudioLessonsPanel extends StatefulWidget {
  final String courseId;
  const _StudioLessonsPanel({required this.courseId});

  @override
  State<_StudioLessonsPanel> createState() => _StudioLessonsPanelState();
}

class _StudioLessonsPanelState extends State<_StudioLessonsPanel> {
  final _lessonService = TeacherLessonService();
  final _db = FirebaseFirestore.instance;
  List<LessonModel> _lessons = [];
  bool _loading = true;
  Map<String, int> _quizCounts = {};

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final lessons = await _lessonService.getCourseLessons(widget.courseId);
      final counts = <String, int>{};
      for (final l in lessons) {
        final snap = await _db.collection('courses').doc(widget.courseId).collection('lessons').doc(l.id).collection('quizzes').get();
        counts[l.id] = snap.docs.length;
      }
      if (mounted) setState(() { _lessons = lessons; _quizCounts = counts; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addLesson() async {
    try {
      final newLesson = LessonModel(
        id: '',
        courseId: widget.courseId,
        title: 'New Lesson',
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
      await _lessonService.createLesson(courseId: widget.courseId, lesson: newLesson);
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _deleteLesson(LessonModel lesson) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete Lesson?'),
      content: Text('Delete "${lesson.title}"? This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red), child: const Text('Delete')),
      ],
    ));
    if (ok == true) {
      await _lessonService.deleteLesson(
          courseId: widget.courseId, lessonId: lesson.id);
      await _load();
    }
  }

  Future<void> _reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final lesson = _lessons.removeAt(oldIndex);
    _lessons.insert(newIndex, lesson);
    setState(() {});
    for (int i = 0; i < _lessons.length; i++) {
      await _db.collection('courses').doc(widget.courseId).collection('lessons').doc(_lessons[i].id).update({'sequenceNumber': i + 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionHeader('Lesson Studio', '${_lessons.length} lesson${_lessons.length == 1 ? '' : 's'} · Drag to reorder'),
                ]),
              ),
              FilledButton.icon(
                onPressed: _addLesson,
                style: FilledButton.styleFrom(backgroundColor: _amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Lesson', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        // Body
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _amber))
              : _lessons.isEmpty
                  ? _emptyLessons()
                  : ReorderableListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                      itemCount: _lessons.length,
                      onReorder: _reorder,
                      itemBuilder: (_, i) => _StudioLessonCard(
                        key: ValueKey(_lessons[i].id),
                        lesson: _lessons[i],
                        index: i,
                        courseId: widget.courseId,
                        quizCount: _quizCounts[_lessons[i].id] ?? 0,
                        onSaved: _load,
                        onDelete: () => _deleteLesson(_lessons[i]),
                        onQuiz: () => _openQuiz(_lessons[i]),
                      ),
                    ),
        ),
      ],
    );
  }

  Future<void> _openQuiz(LessonModel lesson) async {
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
        await _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening quiz: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Widget _emptyLessons() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: _amber.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: const Icon(Icons.video_library_outlined, size: 56, color: _amber)),
        const SizedBox(height: 20),
        const Text('No lessons yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Add your first lesson to build your course', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _addLesson,
          style: FilledButton.styleFrom(backgroundColor: _amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
          icon: const Icon(Icons.add),
          label: const Text('Add First Lesson', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}

// ── Lesson Card (expanded editor) ─────────────────────────────────────────────

class _StudioLessonCard extends StatefulWidget {
  final LessonModel lesson;
  final int index;
  final String courseId;
  final int quizCount;
  final VoidCallback onSaved;
  final VoidCallback onDelete;
  final VoidCallback onQuiz;

  const _StudioLessonCard({
    super.key, required this.lesson, required this.index,
    required this.courseId, required this.quizCount,
    required this.onSaved, required this.onDelete, required this.onQuiz,
  });

  @override
  State<_StudioLessonCard> createState() => _StudioLessonCardState();
}

class _StudioLessonCardState extends State<_StudioLessonCard> {
  final _db = FirebaseFirestore.instance;
  bool _expanded = false;
  bool _saving = false;
  late final _titleCtrl = TextEditingController(text: widget.lesson.title);
  late final _youtubeCtrl = TextEditingController();
  late final _notesCtrl = TextEditingController(text: widget.lesson.description);

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final snap = await _db.collection('courses').doc(widget.courseId)
          .collection('lessons').doc(widget.lesson.id)
          .collection('content').orderBy('order').limit(1).get();
      if (snap.docs.isNotEmpty && mounted) {
        final d = snap.docs.first.data();
        if (d['type'] == 'video') setState(() => _youtubeCtrl.text = d['url'] ?? '');
        else if (d['type'] == 'text') setState(() => _notesCtrl.text = d['content'] ?? widget.lesson.description);
      }
    } catch (_) {}
  }

  @override
  void dispose() { _titleCtrl.dispose(); _youtubeCtrl.dispose(); _notesCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final lessonRef = _db.collection('courses').doc(widget.courseId).collection('lessons').doc(widget.lesson.id);
      await lessonRef.update({'title': _titleCtrl.text.trim(), 'description': _notesCtrl.text.trim(), 'updatedAt': FieldValue.serverTimestamp()});
      final contentRef = lessonRef.collection('content');
      // Save video content if URL present
      if (_youtubeCtrl.text.trim().isNotEmpty) {
        final existing = await contentRef.orderBy('order').limit(1).get();
        final contentData = {'type': 'video', 'url': _youtubeCtrl.text.trim(), 'order': 0, 'updatedAt': FieldValue.serverTimestamp()};
        if (existing.docs.isNotEmpty) {
          await existing.docs.first.reference.update(contentData);
        } else {
          await contentRef.add(contentData);
          await lessonRef.update({'contentIds': FieldValue.arrayUnion(['video_content'])});
        }
      }
      widget.onSaved();
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Lesson saved!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
      }
    } catch (e) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _expanded ? _amber.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.12)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)],
      ),
      child: Column(
        children: [
          // Header row
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: _expanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Drag handle
                  const Icon(Icons.drag_indicator_rounded, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  // Lesson number badge
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(color: _amber.withValues(alpha: 0.12), shape: BoxShape.circle),
                    child: Center(child: Text('${widget.index + 1}',
                        style: const TextStyle(color: _amber, fontWeight: FontWeight.bold, fontSize: 12))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.lesson.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Row(children: [
                        if (widget.lesson.totalDuration.inSeconds > 0)
                          _pill(Icons.access_time_rounded, _formatDuration(widget.lesson.totalDuration), Colors.grey),
                        _pill(Icons.quiz_rounded, '${widget.quizCount} quiz${widget.quizCount == 1 ? '' : 'zes'}',
                            widget.quizCount > 0 ? Colors.purple : Colors.grey),
                      ]),
                    ]),
                  ),
                  // Actions
                  IconButton(
                    icon: const Icon(Icons.quiz_rounded, size: 18, color: Colors.purple),
                    tooltip: 'Add Quiz',
                    onPressed: widget.onQuiz,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: widget.onDelete,
                    visualDensity: VisualDensity.compact,
                  ),
                  Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),

          // Expanded editor
          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Lesson Title *',
                    prefixIcon: const Icon(Icons.title_rounded, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true, fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 12),
                // YouTube/video URL with visual indicator
                TextField(
                  controller: _youtubeCtrl,
                  decoration: InputDecoration(
                    labelText: 'Video URL (YouTube, Vimeo, etc.)',
                    hintText: 'https://youtube.com/watch?v=...',
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.play_circle_rounded, size: 18, color: Colors.red),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true, fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Lesson Notes / Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true, fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.onQuiz,
                      icon: const Icon(Icons.quiz_rounded, size: 16),
                      label: Text(widget.quizCount > 0 ? 'Edit Quiz (${widget.quizCount})' : 'Add Quiz'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.purple),
                        foregroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: _amber,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: _saving
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save_rounded, size: 16),
                      label: Text(_saving ? 'Saving…' : 'Save Lesson', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
              ]),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PANEL 2: QUIZZES
// ─────────────────────────────────────────────────────────────────────────────

class _StudioQuizzesPanel extends StatefulWidget {
  final String courseId;
  const _StudioQuizzesPanel({required this.courseId});

  @override
  State<_StudioQuizzesPanel> createState() => _StudioQuizzesPanelState();
}

class _StudioQuizzesPanelState extends State<_StudioQuizzesPanel> {
  final _lessonService = TeacherLessonService();
  final _db = FirebaseFirestore.instance;
  List<LessonModel> _lessons = [];
  Map<String, int> _quizCounts = {};
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final lessons = await _lessonService.getCourseLessons(widget.courseId);
      final counts = <String, int>{};
      for (final l in lessons) {
        final snap = await _db.collection('courses').doc(widget.courseId)
            .collection('lessons').doc(l.id).collection('quizzes').get();
        counts[l.id] = snap.docs.length;
      }
      if (mounted) setState(() { _lessons = lessons; _quizCounts = counts; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openQuizForLesson(LessonModel lesson) async {
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
        await _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: _sectionHeader('Quiz Builder', 'Add quizzes to any lesson'),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _amber))
              : _lessons.isEmpty
                  ? Center(child: Text('Add lessons first, then create quizzes.', style: TextStyle(color: Colors.grey[500])))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _lessons.length,
                      itemBuilder: (_, i) {
                        final lesson = _lessons[i];
                        final qCount = _quizCounts[lesson.id] ?? 0;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 42, height: 42,
                              decoration: BoxDecoration(
                                color: qCount > 0 ? Colors.purple.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.quiz_rounded, color: qCount > 0 ? Colors.purple : Colors.grey, size: 22),
                            ),
                            title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: Text(qCount > 0 ? '$qCount question${qCount == 1 ? '' : 's'}' : 'No quiz yet',
                                style: TextStyle(fontSize: 12, color: qCount > 0 ? Colors.purple : Colors.grey)),
                            trailing: FilledButton.icon(
                              onPressed: () => _openQuizForLesson(lesson),
                              style: FilledButton.styleFrom(
                                backgroundColor: qCount > 0 ? Colors.purple : _amber,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              icon: Icon(qCount > 0 ? Icons.edit_rounded : Icons.add_rounded, size: 16),
                              label: Text(qCount > 0 ? 'Edit Quiz' : 'Add Quiz', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PANEL 4: STUDENTS
// ─────────────────────────────────────────────────────────────────────────────

class _StudioStudentsPanel extends StatefulWidget {
  final String courseId;
  const _StudioStudentsPanel({required this.courseId});

  @override
  State<_StudioStudentsPanel> createState() => _StudioStudentsPanelState();
}

class _StudioStudentsPanelState extends State<_StudioStudentsPanel> {
  final _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _students = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final snap = await _db.collection('courses').doc(widget.courseId).collection('enrollments').get();
      final list = <Map<String, dynamic>>[];
      for (final doc in snap.docs) {
        final data = doc.data();
        final uid = doc.id;
        final userDoc = await _db.collection('users').doc(uid).get();
        final u = userDoc.data() ?? {};
        final raw = u['displayName'] ?? u['name'] ?? '';
        final name = raw.contains('|') ? raw.split('|').first : (raw.isNotEmpty ? raw : u['email'] ?? uid);
        final quizSnap = await _db.collection('users').doc(uid).collection('quiz_results')
            .where('courseId', isEqualTo: widget.courseId).get();
        double avgScore = 0;
        if (quizSnap.docs.isNotEmpty) {
          for (final r in quizSnap.docs) {
            final d = r.data(); avgScore += (d['score'] ?? 0) / (d['totalQuestions'] ?? 1) * 100;
          }
          avgScore /= quizSnap.docs.length;
        }
        final projDoc = await _db.collection('courses').doc(widget.courseId).collection('projectSubmissions').doc(uid).get();
        final projStatus = projDoc.exists ? (projDoc.data()?['status'] ?? 'none') : 'none';
        list.add({
          'uid': uid, 'name': name, 'email': u['email'] ?? '',
          'progress': (data['progress'] ?? 0.0).toDouble(),
          'status': data['status'] ?? 'active',
          'enrolledAt': (data['enrolledAt'] as Timestamp?)?.toDate(),
          'quizzesTaken': quizSnap.docs.length,
          'avgScore': avgScore,
          'projectStatus': projStatus,
        });
      }
      if (mounted) setState(() { _students = list; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.isEmpty
        ? _students
        : _students.where((s) => (s['name'] as String).toLowerCase().contains(_search.toLowerCase()) ||
            (s['email'] as String).toLowerCase().contains(_search.toLowerCase())).toList();

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _sectionHeader('Students', '${_students.length} enrolled'),
            const SizedBox(height: 10),
            TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search students…',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true, fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ]),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _amber))
              : filtered.isEmpty
                  ? Center(child: Text(_search.isNotEmpty ? 'No matching students' : 'No students enrolled yet',
                      style: TextStyle(color: Colors.grey[500])))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _StudentRow(student: filtered[i]),
                      ),
                    ),
        ),
      ],
    );
  }
}

class _StudentRow extends StatelessWidget {
  final Map<String, dynamic> student;
  const _StudentRow({required this.student});

  @override
  Widget build(BuildContext context) {
    final name = student['name'] as String;
    final progress = (student['progress'] as double) * 100;
    final quizTaken = student['quizzesTaken'] as int;
    final avgScore = student['avgScore'] as double;
    final status = student['status'] as String;
    final projStatus = student['projectStatus'] as String;

    Color statusColor = Colors.blue;
    if (status == 'completed') statusColor = Colors.green;
    else if (status == 'inactive') statusColor = Colors.grey;

    Color projColor = Colors.grey;
    IconData projIcon = Icons.assignment_outlined;
    if (projStatus == 'passed') { projColor = Colors.green; projIcon = Icons.check_circle_rounded; }
    else if (projStatus == 'failed') { projColor = Colors.red; projIcon = Icons.cancel_rounded; }
    else if (projStatus == 'submitted') { projColor = Colors.blue; projIcon = Icons.hourglass_top_rounded; }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6)]),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              backgroundColor: _amber.withValues(alpha: 0.15), radius: 20,
              child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(color: _amber, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(student['email'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(status, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 12),
          // Progress bar
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Progress', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text('${progress.toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 4),
              ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (student['progress'] as double).clamp(0, 1),
                  backgroundColor: Colors.grey[100], color: _amber, minHeight: 6)),
            ])),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _statChip(Icons.quiz_rounded, quizTaken > 0 ? '${avgScore.toInt()}% avg' : 'No quiz', Colors.purple),
            const SizedBox(width: 8),
            _statChip(projIcon, projStatus == 'none' ? 'No project' : projStatus, projColor),
            if (student['enrolledAt'] != null) ...[
              const SizedBox(width: 8),
              _statChip(Icons.calendar_today_rounded, _fmtDate(student['enrolledAt'] as DateTime), Colors.grey),
            ],
          ]),
        ]),
      ),
    );
  }

  Widget _statChip(IconData icon, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 11, color: color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    ]),
  );

  String _fmtDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

Widget _sectionHeader(String title, String subtitle) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
  ]);
}

Widget _pill(IconData icon, String label, Color color) => Container(
  margin: const EdgeInsets.only(right: 6, top: 2),
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
  child: Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 10, color: color),
    const SizedBox(width: 3),
    Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
  ]),
);

String _formatDuration(Duration d) {
  if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
  if (d.inMinutes > 0) return '${d.inMinutes}m';
  return '${d.inSeconds}s';
}

// ─────────────────────────────────────────────────────────────────────────────
// PANEL 3: ASSIGNMENTS (Final Project)
// ─────────────────────────────────────────────────────────────────────────────

class _StudioAssignmentsPanel extends StatefulWidget {
  final String courseId;
  const _StudioAssignmentsPanel({required this.courseId});

  @override
  State<_StudioAssignmentsPanel> createState() => _StudioAssignmentsPanelState();
}

class _StudioAssignmentsPanelState extends State<_StudioAssignmentsPanel>
    with SingleTickerProviderStateMixin {
  final FinalProjectService _svc = FinalProjectService();
  late TabController _tab;

  // Setup form
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _instrCtrl = TextEditingController();
  final _maxScoreCtrl = TextEditingController(text: '100');
  final _passScoreCtrl = TextEditingController(text: '60');
  bool _isRequired = true;
  bool _saving = false;
  bool _loadingSetup = true;
  bool _hasExisting = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _loadSetup();
  }

  @override
  void dispose() {
    _tab.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _instrCtrl.dispose();
    _maxScoreCtrl.dispose();
    _passScoreCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSetup() async {
    final data = await _svc.getProject(widget.courseId);
    if (mounted) {
      setState(() {
        _loadingSetup = false;
        if (data != null) {
          _hasExisting = true;
          _titleCtrl.text = data['title'] ?? '';
          _descCtrl.text = data['description'] ?? '';
          _instrCtrl.text = data['instructions'] ?? '';
          _maxScoreCtrl.text = '${data['maxScore'] ?? 100}';
          _passScoreCtrl.text = '${data['passingScore'] ?? 60}';
          _isRequired = data['isRequired'] ?? true;
        }
      });
    }
  }

  Future<void> _saveAssignment() async {
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final instr = _instrCtrl.text.trim();
    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title and description are required')));
      return;
    }
    final max = int.tryParse(_maxScoreCtrl.text) ?? 100;
    final pass = int.tryParse(_passScoreCtrl.text) ?? 60;
    setState(() => _saving = true);
    try {
      await _svc.saveProject(widget.courseId,
          title: title,
          description: desc,
          instructions: instr,
          maxScore: max,
          passingScore: pass,
          isRequired: _isRequired);
      if (mounted) {
        setState(() { _saving = false; _hasExisting = true; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_hasExisting ? 'Assignment updated!' : 'Assignment created!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _deleteAssignment() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Assignment?'),
        content: const Text('This will remove the assignment definition. Existing submissions will remain.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _svc.deleteProject(widget.courseId);
    if (mounted) {
      setState(() {
        _hasExisting = false;
        _titleCtrl.clear(); _descCtrl.clear(); _instrCtrl.clear();
        _maxScoreCtrl.text = '100'; _passScoreCtrl.text = '60';
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignment deleted'), backgroundColor: Colors.orange));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment_rounded, color: _amber, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assignments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Create a final project for students to complete',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  if (_hasExisting)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded, size: 14, color: Colors.green),
                          SizedBox(width: 4),
                          Text('Active', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TabBar(
                controller: _tab,
                labelColor: _amber,
                unselectedLabelColor: Colors.grey,
                indicatorColor: _amber,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Setup'),
                  Tab(text: 'Submissions & Grading'),
                ],
              ),
            ],
          ),
        ),
        // Body
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildSetupTab(),
              _buildSubmissionsTab(),
            ],
          ),
        ),
      ],
    );
  }

  // ── Setup Tab ───────────────────────────────────────────────────────────────

  Widget _buildSetupTab() {
    if (_loadingSetup) {
      return const Center(child: CircularProgressIndicator(color: _amber));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_hasExisting)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.blue, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'No assignment yet. Fill in the form below and tap Save to create one.',
                      style: TextStyle(fontSize: 13, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          _sectionCard(
            title: 'Basic Info',
            icon: Icons.info_rounded,
            children: [
              _field('Assignment Title', _titleCtrl, hint: 'e.g. Final Project: Build a Mobile App'),
              const SizedBox(height: 14),
              _field('Description', _descCtrl, hint: 'Brief overview of what students will build', maxLines: 3),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Instructions',
            icon: Icons.list_alt_rounded,
            children: [
              _field(
                'Detailed Instructions',
                _instrCtrl,
                hint: 'Step-by-step instructions, requirements, deliverables…',
                maxLines: 6,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Marking Scheme',
            icon: Icons.grading_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Maximum Marks', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _maxScoreCtrl,
                          keyboardType: TextInputType.number,
                          decoration: _inputDec('e.g. 100'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Passing Marks', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passScoreCtrl,
                          keyboardType: TextInputType.number,
                          decoration: _inputDec('e.g. 60'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Switch(
                    value: _isRequired,
                    activeColor: _amber,
                    onChanged: (v) => setState(() => _isRequired = v),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isRequired ? 'Required to pass course' : 'Optional assignment',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _isRequired
                            ? 'Students must complete this to get a certificate'
                            : 'Students can skip this assignment',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _saving ? null : _saveAssignment,
                  style: FilledButton.styleFrom(
                    backgroundColor: _amber,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save_rounded, color: Colors.white),
                  label: Text(
                    _saving ? 'Saving…' : (_hasExisting ? 'Update Assignment' : 'Save Assignment'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              if (_hasExisting) ...[
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _deleteAssignment,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Delete'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Submissions & Grading Tab ───────────────────────────────────────────────

  Widget _buildSubmissionsTab() {
    if (!_hasExisting && !_loadingSetup) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            const Text('No assignment created yet',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 6),
            const Text('Go to Setup tab to create one first',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _tab.animateTo(0),
              child: const Text('Go to Setup'),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _svc.streamSubmissions(widget.courseId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _amber));
        }
        final subs = snap.data ?? [];
        if (subs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_rounded, size: 56, color: Colors.grey[300]),
                const SizedBox(height: 12),
                const Text('No submissions yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 6),
                const Text('Students will appear here once they submit',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          );
        }

        final pending = subs.where((s) => s['status'] == 'submitted').length;
        final graded = subs.where((s) => s['status'] != 'submitted').length;
        final passed = subs.where((s) => s['passed'] == true).length;

        return Column(
          children: [
            // Stats bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _submissionStat('${subs.length}', 'Total', Colors.blue),
                  const SizedBox(width: 16),
                  _submissionStat('$pending', 'Pending', Colors.orange),
                  const SizedBox(width: 16),
                  _submissionStat('$graded', 'Graded', Colors.purple),
                  const SizedBox(width: 16),
                  _submissionStat('$passed', 'Passed', Colors.green),
                ],
              ),
            ),
            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: subs.length,
                itemBuilder: (_, i) => _submissionCard(subs[i]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _submissionStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _submissionCard(Map<String, dynamic> sub) {
    final status = sub['status'] ?? 'submitted';
    final isPending = status == 'submitted';
    final passed = sub['passed'] == true;
    final score = sub['score'];
    final maxScore = sub['maxScore'] ?? int.tryParse(_maxScoreCtrl.text) ?? 100;
    final passScore = int.tryParse(_passScoreCtrl.text) ?? 60;

    Color statusColor;
    String statusLabel;
    if (isPending) { statusColor = Colors.orange; statusLabel = 'Pending Review'; }
    else if (passed) { statusColor = Colors.green; statusLabel = 'Passed'; }
    else { statusColor = Colors.red; statusLabel = 'Failed'; }

    final submittedAt = sub['submittedAt'];
    String dateStr = '';
    if (submittedAt is Timestamp) {
      final d = submittedAt.toDate();
      dateStr = '${d.day}/${d.month}/${d.year}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _amber.withValues(alpha: 0.15),
                  child: Text(
                    (sub['studentName'] ?? 'S').isNotEmpty
                        ? (sub['studentName'] as String)[0].toUpperCase()
                        : 'S',
                    style: const TextStyle(color: _amber, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sub['studentName'] ?? 'Student',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(sub['studentEmail'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(statusLabel,
                      style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            if ((sub['submissionText'] ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sub['submissionText'] ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
            if ((sub['submissionUrl'] ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.link_rounded, size: 14, color: Colors.blue),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      sub['submissionUrl'] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                if (dateStr.isNotEmpty)
                  Text('Submitted $dateStr',
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const Spacer(),
                if (!isPending && score != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: passed
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Score: $score / $maxScore',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: passed ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _openGradeDialog(sub, maxScore, passScore),
                  style: FilledButton.styleFrom(
                    backgroundColor: isPending ? _amber : Colors.grey[200],
                    foregroundColor: isPending ? Colors.white : Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(isPending ? Icons.grading_rounded : Icons.edit_rounded, size: 15),
                  label: Text(isPending ? 'Grade' : 'Re-grade',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            if (!isPending && (sub['feedback'] ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.comment_rounded, size: 13, color: Colors.blue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        sub['feedback'] ?? '',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openGradeDialog(Map<String, dynamic> sub, int maxScore, int passScore) {
    final scoreCtrl = TextEditingController(text: '${sub['score'] ?? ''}');
    final feedbackCtrl = TextEditingController(text: sub['feedback'] ?? '');
    bool grading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.grading_rounded, color: _amber),
              const SizedBox(width: 8),
              Expanded(child: Text('Grade: ${sub['studentName'] ?? 'Student'}',
                  style: const TextStyle(fontSize: 16))),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('Max: $maxScore marks · Passing: $passScore marks',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Score Awarded', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: scoreCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDec('Enter score (0–$maxScore)'),
                ),
                const SizedBox(height: 14),
                const Text('Feedback to Student', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: feedbackCtrl,
                  maxLines: 4,
                  decoration: _inputDec('Write constructive feedback…'),
                ),
                const SizedBox(height: 8),
                Builder(builder: (_) {
                  final s = int.tryParse(scoreCtrl.text) ?? 0;
                  final willPass = s >= passScore;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: (willPass ? Colors.green : Colors.red).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(willPass ? Icons.check_circle_rounded : Icons.cancel_rounded,
                            size: 15, color: willPass ? Colors.green : Colors.red),
                        const SizedBox(width: 6),
                        Text(
                          willPass
                              ? 'Student will PASS and receive a certificate'
                              : 'Student will FAIL — certificate not issued',
                          style: TextStyle(
                              fontSize: 12,
                              color: willPass ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: grading ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _amber),
              onPressed: grading
                  ? null
                  : () async {
                      final score = int.tryParse(scoreCtrl.text);
                      if (score == null || score < 0 || score > maxScore) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Enter a score between 0 and $maxScore'),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      setLocal(() => grading = true);
                      try {
                        await _svc.gradeSubmission(
                          widget.courseId,
                          sub['studentId'] ?? sub['id'],
                          score: score,
                          maxScore: maxScore,
                          passingScore: passScore,
                          feedback: feedbackCtrl.text.trim(),
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        final passed = score >= passScore;
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(passed
                                ? '✓ Graded — student passed and certificate issued!'
                                : 'Graded — student did not pass'),
                            backgroundColor: passed ? Colors.green : Colors.orange,
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      } catch (e) {
                        setLocal(() => grading = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                        }
                      }
                    },
              child: grading
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Submit Grade'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _sectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: _amber),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {String hint = '', int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: _inputDec(hint),
        ),
      ],
    );
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _amber, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}
