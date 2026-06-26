import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/lesson_quiz_model.dart';
import 'package:education_app/teacher/services/teacher_lesson_service.dart';
import 'package:education_app/teacher/services/teacher_quiz_service.dart';
import 'package:education_app/teacher/screens/quiz_builder_screen.dart';

const _primary = Color(0xFFFFA726);
const _bg = Color(0xFFFFF3E0);

class LessonEditorScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  const LessonEditorScreen({super.key, required this.courseId, required this.lessonId});

  @override
  State<LessonEditorScreen> createState() => _LessonEditorScreenState();
}

class _LessonEditorScreenState extends State<LessonEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TeacherLessonService _lessonService = TeacherLessonService();
  final TeacherQuizService _quizService = TeacherQuizService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _lessonTitle = '';
  String _youtubeUrl = '';
  String _notes = '';
  String _assignmentTitle = '';
  String _assignmentInstructions = '';
  List<LessonQuizModel> _quizzes = [];

  bool _isLoading = true;
  bool _isSaving = false;

  final _titleCtrl = TextEditingController();
  final _youtubeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _assignmentTitleCtrl = TextEditingController();
  final _assignmentInstrCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final doc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(widget.courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(widget.lessonId)
          .get();

      final data = doc.data() ?? {};
      final quizSnap = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(widget.courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(widget.lessonId)
          .collection('quizzes')
          .get();

      if (mounted) {
        setState(() {
          _lessonTitle = data['title'] ?? '';
          _youtubeUrl = data['youtubeUrl'] ?? '';
          _notes = data['notes'] ?? '';
          _assignmentTitle = data['assignmentTitle'] ?? '';
          _assignmentInstructions = data['assignmentInstructions'] ?? '';

          _titleCtrl.text = _lessonTitle;
          _youtubeCtrl.text = _youtubeUrl;
          _notesCtrl.text = _notes;
          _assignmentTitleCtrl.text = _assignmentTitle;
          _assignmentInstrCtrl.text = _assignmentInstructions;

          _quizzes = quizSnap.docs
              .map((d) => LessonQuizModel.fromJson(d.data()))
              .toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveLesson() async {
    setState(() => _isSaving = true);
    try {
      await _lessonService.updateLesson(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        data: {
          'title': _titleCtrl.text.trim(),
          'youtubeUrl': _youtubeCtrl.text.trim(),
          'notes': _notesCtrl.text.trim(),
          'assignmentTitle': _assignmentTitleCtrl.text.trim(),
          'assignmentInstructions': _assignmentInstrCtrl.text.trim(),
        },
      );
      if (mounted) {
        setState(() { _isSaving = false; _lessonTitle = _titleCtrl.text.trim(); });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lesson saved!')));
      }
    } catch (e) {
      if (mounted) { setState(() => _isSaving = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'))); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(_lessonTitle.isEmpty ? 'Lesson Editor' : _lessonTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis),
        actions: [
          if (_isSaving)
            const Padding(padding: EdgeInsets.all(16), child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: _primary, strokeWidth: 2)))
          else
            TextButton(
              onPressed: _saveLesson,
              child: const Text('Save', style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: _primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: _primary,
          tabs: const [
            Tab(icon: Icon(Icons.play_circle_outline), text: 'Video'),
            Tab(icon: Icon(Icons.notes_outlined), text: 'Notes'),
            Tab(icon: Icon(Icons.quiz_outlined), text: 'Quiz'),
            Tab(icon: Icon(Icons.assignment_outlined), text: 'Assignment'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildVideoTab(),
                _buildNotesTab(),
                _buildQuizTab(),
                _buildAssignmentTab(),
              ],
            ),
    );
  }

  Widget _buildVideoTab() {
    final videoId = _extractYouTubeId(_youtubeCtrl.text.trim());
    final thumbUrl = videoId != null ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg' : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Lesson Title'),
          const SizedBox(height: 8),
          TextField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              hintText: 'e.g. Introduction to Variables',
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('YouTube Video'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.link, color: _primary, size: 20),
                    SizedBox(width: 8),
                    Text('Paste YouTube URL', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _youtubeCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'https://www.youtube.com/watch?v=...',
                    filled: true,
                    fillColor: const Color(0xFFF5F7FB),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    suffixIcon: _youtubeCtrl.text.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () { _youtubeCtrl.clear(); setState(() {}); })
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Supports: youtube.com/watch?v=... or youtu.be/...', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          if (thumbUrl != null) ...[
            const SizedBox(height: 16),
            _sectionTitle('Preview'),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(thumbUrl, width: double.infinity, height: 200, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 200, color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 48, color: Colors.grey))),
                  Container(
                    height: 200, width: double.infinity,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                  const Icon(Icons.play_circle_filled, color: Colors.white, size: 64),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Video ID: $videoId', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
          if (thumbUrl == null && _youtubeCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withValues(alpha: 0.2))),
              child: const Row(
                children: [Icon(Icons.warning_amber, color: Colors.red, size: 18), SizedBox(width: 8), Text('Invalid YouTube URL', style: TextStyle(color: Colors.red))],
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveLesson,
              style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Save Lesson', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Lesson Notes'),
          const SizedBox(height: 4),
          Text('Add supplementary text content, key points, or reading material for this lesson.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: TextField(
              controller: _notesCtrl,
              maxLines: 20,
              decoration: InputDecoration(
                hintText: 'Write lesson notes, key concepts, code examples, links...\n\nYou can use plain text formatting.',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveLesson,
              style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Save Notes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuizTab() {
    return Column(
      children: [
        Expanded(
          child: _quizzes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz_outlined, size: 72, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No quizzes yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                      const SizedBox(height: 8),
                      Text('Add a quiz to test your students', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _quizzes.length,
                  itemBuilder: (_, i) {
                    final q = _quizzes[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                      child: ListTile(
                        leading: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: _primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.quiz, color: _primary),
                        ),
                        title: Text(q.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${q.questionCount} questions • ${q.passingScore}% to pass',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: _primary, size: 20),
                              onPressed: () => _openQuiz(q),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              onPressed: () => _deleteQuiz(q),
                            ),
                          ],
                        ),
                        onTap: () => _openQuiz(q),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _createQuiz,
              style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Quiz', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Assignment'),
          const SizedBox(height: 4),
          Text('Give students a task to complete after this lesson.',
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 20),
          _label('Assignment Title'),
          const SizedBox(height: 8),
          TextField(
            controller: _assignmentTitleCtrl,
            decoration: InputDecoration(
              hintText: 'e.g. Build a Counter App',
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          _label('Instructions'),
          const SizedBox(height: 8),
          TextField(
            controller: _assignmentInstrCtrl,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Describe what students need to do...\n\nInclude steps, requirements, and submission instructions.',
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveLesson,
              style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Save Assignment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) =>
      Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold));

  Widget _label(String text) =>
      Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600));

  String? _extractYouTubeId(String url) {
    if (url.isEmpty) return null;
    final patterns = [
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(url);
      if (m != null) return m.group(1);
    }
    return null;
  }

  Future<void> _createQuiz() async {
    final titleCtrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Quiz'),
        content: TextField(
          controller: titleCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Quiz title (e.g. Lesson 1 Quiz)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _primary),
            onPressed: () => Navigator.pop(context, titleCtrl.text.trim()),
            child: const Text('Create', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;

    try {
      final quiz = LessonQuizModel(
        id: '', courseId: widget.courseId, lessonId: widget.lessonId,
        title: result, description: '', instruction: 'Answer all questions.',
        passingScore: 70, shuffleQuestions: false,
        showAnswersOption: 'immediately', questions: [],
        totalAttempts: 0, averageScore: 0, passRate: 0, averageTimeSeconds: 0,
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
      );
      final quizId = await _quizService.createQuiz(
        courseId: widget.courseId, lessonId: widget.lessonId, quiz: quiz,
      );
      if (mounted) {
        await Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizBuilderScreen(courseId: widget.courseId, lessonId: widget.lessonId, quizId: quizId, quizTitle: result),
        ));
        _load();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _openQuiz(LessonQuizModel quiz) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => QuizBuilderScreen(courseId: widget.courseId, lessonId: widget.lessonId, quizId: quiz.id, quizTitle: quiz.title),
    )).then((_) => _load());
  }

  void _deleteQuiz(LessonQuizModel quiz) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: Text('Delete "${quiz.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await _quizService.deleteQuiz(courseId: widget.courseId, lessonId: widget.lessonId, quizId: quiz.id);
      _load();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleCtrl.dispose();
    _youtubeCtrl.dispose();
    _notesCtrl.dispose();
    _assignmentTitleCtrl.dispose();
    _assignmentInstrCtrl.dispose();
    super.dispose();
  }
}
