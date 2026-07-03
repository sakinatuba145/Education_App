import 'package:flutter/material.dart';
import 'package:education_app/teacher/services/teacher_quiz_service.dart';

const _primary = Color(0xFFFFA726);
const _bg = Color(0xFFFFF3E0);

class QuizBuilderScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String quizId;
  final String quizTitle;
  const QuizBuilderScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  State<QuizBuilderScreen> createState() => _QuizBuilderScreenState();
}

class _QuizBuilderScreenState extends State<QuizBuilderScreen> {
  final TeacherQuizService _quizService = TeacherQuizService();

  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  bool _isSaving = false;

  int _passingScore = 70;
  bool _shuffleQuestions = false;
  String _showAnswersOption = 'immediately';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final quiz = await _quizService.getQuiz(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        quizId: widget.quizId,
      );
      if (mounted) {
        setState(() {
          _questions = List<Map<String, dynamic>>.from(quiz.questions);
          _passingScore = quiz.passingScore;
          _shuffleQuestions = quiz.shuffleQuestions;
          _showAnswersOption = quiz.showAnswersOption;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveQuiz() async {
    setState(() => _isSaving = true);
    try {
      await _quizService.updateQuiz(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
        quizId: widget.quizId,
        data: {
          'questions': _questions,
          'passingScore': _passingScore,
          'shuffleQuestions': _shuffleQuestions,
          'showAnswersOption': _showAnswersOption,
        },
      );
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz saved!')));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.quizTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
            Text('${_questions.length} questions',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          if (_isSaving)
            const Padding(padding: EdgeInsets.all(16),
                child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: _primary, strokeWidth: 2)))
          else
            TextButton(
              onPressed: _saveQuiz,
              child: const Text('Save', style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildSettingsCard()),
                _questions.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.help_outline, size: 72, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text('No questions yet', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                              const SizedBox(height: 8),
                              Text('Tap + to add your first question',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                            ],
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _questionCard(i),
                          childCount: _questions.length,
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addQuestion,
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Question', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quiz Settings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Passing Score (%)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _passingScore,
                      decoration: InputDecoration(
                        filled: true, fillColor: const Color(0xFFF5F7FB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      items: [50, 60, 70, 75, 80, 90, 100]
                          .map((v) => DropdownMenuItem(value: v, child: Text('$v%')))
                          .toList(),
                      onChanged: (v) => setState(() => _passingScore = v ?? 70),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Show Answers', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _showAnswersOption,
                      decoration: InputDecoration(
                        filled: true, fillColor: const Color(0xFFF5F7FB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'immediately', child: Text('Immediately')),
                        DropdownMenuItem(value: 'after_completion', child: Text('After Submit')),
                        DropdownMenuItem(value: 'never', child: Text('Never')),
                      ],
                      onChanged: (v) => setState(() => _showAnswersOption = v ?? 'immediately'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: _primary,
            title: const Text('Shuffle Questions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text('Randomize question order for each attempt', style: TextStyle(fontSize: 12)),
            value: _shuffleQuestions,
            onChanged: (v) => setState(() => _shuffleQuestions = v),
          ),
        ],
      ),
    );
  }

  Widget _questionCard(int index) {
    final q = _questions[index];
    final options = List<String>.from(q['options'] ?? []);
    final correctIndex = q['correctIndex'] ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(8)),
                  child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(q['question'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: _primary, size: 20),
                  onPressed: () => _editQuestion(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => _deleteQuestion(index),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: options.asMap().entries.map((e) {
                final isCorrect = e.key == correctIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isCorrect ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(e.value,
                            style: TextStyle(
                              fontSize: 14,
                              color: isCorrect ? Colors.green[700] : Colors.black,
                              fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                            )),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _addQuestion() => _showQuestionDialog();

  void _editQuestion(int index) => _showQuestionDialog(editIndex: index);

  void _deleteQuestion(int index) {
    setState(() => _questions.removeAt(index));
  }

  void _showQuestionDialog({int? editIndex}) {
    final isEdit = editIndex != null;
    final existing = isEdit ? _questions[editIndex] : null;

    final questionCtrl = TextEditingController(text: existing?['question'] ?? '');
    final optionCtrls = List.generate(4, (i) {
      final opts = existing != null ? List<String>.from(existing['options'] ?? []) : [];
      return TextEditingController(text: i < opts.length ? opts[i] : '');
    });
    int selectedCorrect = existing?['correctIndex'] ?? 0;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Question' : 'Add Question'),
          contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Question *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: questionCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter your question here...',
                      filled: true, fillColor: const Color(0xFFF5F7FB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Answer Options *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('Tap ✓ to mark as correct answer', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 10),
                  ...List.generate(4, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setDialogState(() => selectedCorrect = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: selectedCorrect == i ? Colors.green : Colors.grey[100],
                              shape: BoxShape.circle,
                              border: Border.all(color: selectedCorrect == i ? Colors.green : Colors.grey[300]!),
                            ),
                            child: Center(
                              child: Text(String.fromCharCode(65 + i),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                                      color: selectedCorrect == i ? Colors.white : Colors.grey[600])),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: optionCtrls[i],
                            decoration: InputDecoration(
                              hintText: 'Option ${String.fromCharCode(65 + i)}',
                              filled: true,
                              fillColor: selectedCorrect == i ? Colors.green.withValues(alpha: 0.06) : const Color(0xFFF5F7FB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: selectedCorrect == i ? const BorderSide(color: Colors.green) : BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: selectedCorrect == i ? const BorderSide(color: Colors.green) : BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _primary),
              onPressed: () {
                final question = questionCtrl.text.trim();
                final options = optionCtrls.map((c) => c.text.trim()).toList();
                if (question.isEmpty || options.any((o) => o.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in the question and all 4 options')),
                  );
                  return;
                }
                Navigator.pop(ctx);
                setState(() {
                  final q = {'question': question, 'options': options, 'correctIndex': selectedCorrect};
                  if (isEdit) {
                    _questions[editIndex!] = q;
                  } else {
                    _questions.add(q);
                  }
                });
              },
              child: Text(isEdit ? 'Update' : 'Add', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
