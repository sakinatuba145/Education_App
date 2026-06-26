import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/models/course_model.dart';
import 'package:education_app/teacher/models/lesson_model.dart';
import 'package:education_app/teacher/services/teacher_course_service.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/teacher/services/teacher_storage_service.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/screens/lesson_editor_screen.dart';

const _primary = Color(0xFFFFA726);
const _bg = Color(0xFFFFF3E0);

class CourseEditorScreen extends StatefulWidget {
  final String courseId;
  const CourseEditorScreen({super.key, required this.courseId});

  @override
  State<CourseEditorScreen> createState() => _CourseEditorScreenState();
}

class _CourseEditorScreenState extends State<CourseEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TeacherCourseService _courseService = TeacherCourseService();
  final TeacherLessonService _lessonService = TeacherLessonService();
  final TeacherStorageService _storageService = TeacherStorageService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CourseModel? _course;
  List<LessonModel> _lessons = [];
  bool _isLoading = true;
  bool _isSaving = false;

  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = '';
  String _level = 'beginner';
  String _language = 'English';
  bool _isFree = true;
  double _price = 0;
  String _visibility = 'public';
  File? _newThumbnail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final course = await _courseService.getCourseById(widget.courseId);
      final lessons = await _lessonService.getCourseLessons(widget.courseId);
      if (mounted) {
        setState(() {
          _course = course;
          _lessons = lessons;
          _titleCtrl.text = course.title;
          _subtitleCtrl.text = course.subtitle;
          _descCtrl.text = course.description;
          _category = course.category;
          _level = course.level;
          _language = course.language;
          _isFree = course.isFree;
          _price = course.price ?? 0;
          _visibility = course.visibility;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) { setState(() => _isLoading = false); }
    }
  }

  Future<void> _saveOverview() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title is required')));
      return;
    }
    setState(() => _isSaving = true);
    try {
      String? thumbnailUrl;
      if (_newThumbnail != null) {
        final uid = _auth.currentUser!.uid;
        thumbnailUrl = await _storageService.uploadThumbnail(
          file: _newThumbnail!,
          courseId: widget.courseId,
          teacherUid: uid,
        );
      }

      final data = <String, dynamic>{
        'title': _titleCtrl.text.trim(),
        'subtitle': _subtitleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'category': _category,
        'level': _level,
        'language': _language,
        'slug': _titleCtrl.text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-'),
      };
      if (thumbnailUrl != null) data['thumbnailUrl'] = thumbnailUrl;

      await _courseService.updateCourse(courseId: widget.courseId, data: data);
      if (mounted) {
        setState(() { _newThumbnail = null; _isSaving = false; });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Overview saved!')));
        _load();
      }
    } catch (e) {
      if (mounted) { setState(() => _isSaving = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'))); }
    }
  }

  Future<void> _savePricing() async {
    setState(() => _isSaving = true);
    try {
      await _courseService.updateCourse(courseId: widget.courseId, data: {
        'isFree': _isFree,
        'price': _isFree ? null : _price,
      });
      if (mounted) { setState(() => _isSaving = false); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pricing saved!'))); }
    } catch (e) {
      if (mounted) { setState(() => _isSaving = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'))); }
    }
  }

  Future<void> _publishCourse() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Publish Course'),
        content: const Text('Make this course visible to students?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Publish')),
        ],
      ),
    );
    if (confirm == true) {
      await _courseService.publishCourse(widget.courseId);
      _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course published!')));
    }
  }

  Future<void> _saveDraft() async {
    await _courseService.saveDraft(widget.courseId);
    _load();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved as draft')));
  }

  @override
  Widget build(BuildContext context) {
    final isPublished = _course?.isPublished ?? false;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(_course?.title ?? 'Course Editor',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis),
        actions: [
          if (_isSaving)
            const Padding(padding: EdgeInsets.all(16), child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: _primary, strokeWidth: 2)))
          else
            TextButton(
              onPressed: _tabController.index == 0
                  ? _saveOverview
                  : _tabController.index == 2
                      ? _savePricing
                      : null,
              child: const Text('Save', style: TextStyle(color: _primary, fontWeight: FontWeight.bold)),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) => setState(() {}),
          labelColor: _primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: _primary,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline), text: 'Overview'),
            Tab(icon: Icon(Icons.list_alt), text: 'Curriculum'),
            Tab(icon: Icon(Icons.attach_money), text: 'Pricing'),
            Tab(icon: Icon(Icons.settings_outlined), text: 'Settings'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCurriculumTab(),
                _buildPricingTab(),
                _buildSettingsTab(isPublished),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Course Thumbnail'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickThumbnail,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[100],
                border: Border.all(color: _primary.withValues(alpha: 0.3), width: 2),
              ),
              clipBehavior: Clip.hardEdge,
              child: _newThumbnail != null
                  ? Image.file(_newThumbnail!, fit: BoxFit.cover, width: double.infinity)
                  : (_course?.thumbnailUrl != null && _course!.thumbnailUrl!.isNotEmpty)
                      ? Image.network(_course!.thumbnailUrl!, fit: BoxFit.cover, width: double.infinity,
                          errorBuilder: (_, __, ___) => _thumbnailPlaceholderWidget())
                      : _thumbnailPlaceholderWidget(),
            ),
          ),
          const SizedBox(height: 4),
          Center(child: Text('Tap to change thumbnail', style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
          const SizedBox(height: 20),
          _sectionTitle('Basic Information'),
          const SizedBox(height: 8),
          _field('Course Title *', _titleCtrl, hint: 'e.g. Complete Flutter Development Bootcamp'),
          const SizedBox(height: 12),
          _field('Subtitle', _subtitleCtrl, hint: 'e.g. Build 25+ apps with Flutter and Dart'),
          const SizedBox(height: 12),
          _field('Description *', _descCtrl, hint: 'Describe what students will learn...', maxLines: 6),
          const SizedBox(height: 20),
          _sectionTitle('Course Details'),
          const SizedBox(height: 8),
          _dropdown('Category', _category.isEmpty ? null : _category, COURSE_CATEGORIES, (v) => setState(() => _category = v ?? '')),
          const SizedBox(height: 12),
          _dropdown('Level', _level, ['beginner', 'intermediate', 'advanced'], (v) => setState(() => _level = v ?? 'beginner')),
          const SizedBox(height: 12),
          _dropdown('Language', _language, SUPPORTED_LANGUAGES, (v) => setState(() => _language = v ?? 'English')),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveOverview,
              style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCurriculumTab() {
    return Column(
      children: [
        Expanded(
          child: _lessons.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library_outlined, size: 72, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No lessons yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                      const SizedBox(height: 8),
                      Text('Add your first lesson below', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                    ],
                  ),
                )
              : ReorderableListView(
                  padding: const EdgeInsets.all(16),
                  onReorder: _reorderLessons,
                  children: _lessons.asMap().entries.map((e) => _lessonTile(e.key, e.value)).toList(),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _addLesson,
              style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Lesson', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lessonTile(int index, LessonModel lesson) {
    return Card(
      key: Key(lesson.id),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle, color: Colors.grey),
        ),
        title: Text('${index + 1}. ${lesson.title}', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${lesson.contentIds.length} content items', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: _primary, size: 20),
              onPressed: () => _openLesson(lesson),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: () => _deleteLesson(lesson),
            ),
          ],
        ),
        onTap: () => _openLesson(lesson),
      ),
    );
  }

  Widget _buildPricingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Pricing'),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                RadioListTile<bool>(
                  activeColor: _primary,
                  title: const Text('Free', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Students can enroll for free'),
                  value: true,
                  groupValue: _isFree,
                  onChanged: (v) => setState(() => _isFree = v ?? true),
                ),
                const Divider(height: 1, indent: 16),
                RadioListTile<bool>(
                  activeColor: _primary,
                  title: const Text('Paid', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Set a price for your course'),
                  value: false,
                  groupValue: _isFree,
                  onChanged: (v) => setState(() => _isFree = v ?? false),
                ),
              ],
            ),
          ),
          if (!_isFree) ...[
            const SizedBox(height: 16),
            _sectionTitle('Course Price (USD)'),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _price > 0 ? _price.toString() : '',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '\$ ',
                hintText: '29.99',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
              onChanged: (v) => _price = double.tryParse(v) ?? 0,
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _savePricing,
              style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Save Pricing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(bool isPublished) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Visibility'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                RadioListTile<String>(
                  activeColor: _primary,
                  title: const Text('Public'),
                  subtitle: const Text('Visible to all students'),
                  value: 'public',
                  groupValue: _visibility,
                  onChanged: (v) => setState(() => _visibility = v!),
                ),
                const Divider(height: 1, indent: 16),
                RadioListTile<String>(
                  activeColor: _primary,
                  title: const Text('Private'),
                  subtitle: const Text('Only visible to invited students'),
                  value: 'private',
                  groupValue: _visibility,
                  onChanged: (v) => setState(() => _visibility = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () async {
                await _courseService.setCourseVisibility(courseId: widget.courseId, visibility: _visibility);
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visibility saved!')));
              },
              style: OutlinedButton.styleFrom(side: const BorderSide(color: _primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Save Visibility', style: TextStyle(color: _primary, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Status'),
          const SizedBox(height: 8),
          if (!isPublished)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green.withValues(alpha: 0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ready to publish?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Make your course visible to students. Make sure you\'ve added all your content first.', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _publishCourse,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      icon: const Icon(Icons.public, color: Colors.white),
                      label: const Text('Publish Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orange.withValues(alpha: 0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 8), const Text('Published', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
                  const SizedBox(height: 8),
                  Text('Your course is live. Students can enroll.', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.orange), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: const Text('Unpublish (Save as Draft)', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black));

  Widget _field(String label, TextEditingController ctrl, {String? hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _thumbnailPlaceholderWidget() {
    return Container(
      height: 180, width: double.infinity,
      color: _primary.withValues(alpha: 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 48, color: _primary),
          const SizedBox(height: 8),
          const Text('Add Thumbnail', style: TextStyle(color: _primary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Recommended: 1280×720', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }

  Future<void> _pickThumbnail() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _newThumbnail = File(img.path));
  }

  void _addLesson() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Lesson'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Introduction to Dart'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primary),
            onPressed: () async {
              final title = ctrl.text.trim();
              if (title.isEmpty) return;
              Navigator.pop(context);
              await _createAndOpenLesson(title);
            },
            child: const Text('Create', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _createAndOpenLesson(String title) async {
    try {
      final newLesson = LessonModel(
        id: '',
        courseId: widget.courseId,
        title: title,
        description: '',
        sequenceNumber: _lessons.length,
        contentIds: [],
        totalViews: 0,
        totalCompleted: 0,
        averageRating: 0,
        totalDuration: Duration.zero,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final lessonId = await _lessonService.createLesson(courseId: widget.courseId, lesson: newLesson);
      if (mounted) {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => LessonEditorScreen(courseId: widget.courseId, lessonId: lessonId)));
        _load();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _openLesson(LessonModel lesson) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LessonEditorScreen(courseId: widget.courseId, lessonId: lesson.id)))
        .then((_) => _load());
  }

  void _deleteLesson(LessonModel lesson) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Lesson'),
        content: Text('Delete "${lesson.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await _lessonService.deleteLesson(courseId: widget.courseId, lessonId: lesson.id);
      _load();
    }
  }

  void _reorderLessons(int oldIndex, int newIndex) async {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final lesson = _lessons.removeAt(oldIndex);
      _lessons.insert(newIndex, lesson);
    });
    await _lessonService.reorderLessons(courseId: widget.courseId, lessonIds: _lessons.map((l) => l.id).toList());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
}
