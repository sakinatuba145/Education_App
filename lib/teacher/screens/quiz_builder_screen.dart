/// File: quiz_builder_screen.dart
/// Description: A comprehensive interface for teachers to create and edit course quizzes.
/// Provides functionality for managing questions, settings, and real-time persistence.

import 'package:flutter/material.dart';
import 'package:education_app/teacher/services/teacher_quiz_service.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../core/I18n/messages.dart';

const _primary = Color(0xFFFFA726);
const _bg = Color(0xFFFFF3E0);

/// QuizBuilderScreen
///
/// A StatefulWidget that allows teachers to build or edit a quiz for a specific lesson.
/// It handles question management (add, edit, delete) and quiz-wide settings.
class QuizBuilderScreen extends StatefulWidget {
  final String courseId;
  final String lessonId;
  final String quizId;
  final String quizTitle;

  /// Creates a [QuizBuilderScreen].
  /// [courseId], [lessonId], and [quizId] are required to identify and save the quiz in Firestore.
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

  /// List of questions for the quiz. Each question is a map containing:
  /// - 'question': The question text
  /// - 'options': A list of 4 answer options
  /// - 'correctIndex': The index of the correct answer (0-3)
  List<Map<String, dynamic>> _questions = [];

  /// Loading state for the initial data fetch.
  bool _isLoading = true;

  /// Saving state for when the quiz is being updated in Firestore.
  bool _isSaving = false;

  /// The percentage score required to pass the quiz.
  int _passingScore = 70;

  /// Whether the questions should be shuffled for each student attempt.
  bool _shuffleQuestions = false;

  /// Determines when students can see the correct answers (immediately, after submit, or never).
  String _showAnswersOption = 'immediately';

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Loads the quiz data from Firestore using [TeacherQuizService].
  /// Initializes the local state with the retrieved data.
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

  /// Saves the current quiz state (questions and settings) to Firestore.
  /// Validates the data before calling the service.
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
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(AppMessages.quizSaved.tr)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppMessages.errorMessage.tr}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFA726), Color(0xFFE65100)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(color: Color(0x33FFA726), blurRadius: 12, offset: Offset(0, 3)),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.quizTitle,
                          style: const TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                    Text(
                      '${_questions.length} ${AppMessages.question.tr}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.80),
                      ),
                        ),
                      ],
                    ),
                  ),
                  if (_isSaving)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: _saveQuiz,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.50)),
                          ),
                          child: Text(AppMessages.save.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
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
                              Text(AppMessages.noQuestionsYet.tr, style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                              const SizedBox(height: 8),
                              Text(AppMessages.addFirstQuestion.tr,
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
        label: Text(AppMessages.addQuestion.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  /// Builds the settings card at the top of the screen.
  /// Allows configuring passing score, answer visibility, and shuffling.
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
          Text(AppMessages.quizSettings.tr, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppMessages.passingScore.tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                    Text(AppMessages.showAnswers.tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _showAnswersOption,
                      decoration: InputDecoration(
                        filled: true, fillColor: const Color(0xFFF5F7FB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      items: [
                        DropdownMenuItem(value: 'immediately', child: Text(AppMessages.immediately.tr)),
                        DropdownMenuItem(value: 'after_completion', child: Text(AppMessages.afterSubmit.tr)),
                        DropdownMenuItem(value: 'never', child: Text(AppMessages.never.tr)),
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
            title: Text(AppMessages.shuffleQuestions.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text(AppMessages.randomizeQuestions.tr, style: TextStyle(fontSize: 12)),
            value: _shuffleQuestions,
            onChanged: (v) => setState(() => _shuffleQuestions = v),
          ),
        ],
      ),
    );
  }

  /// Builds an individual question card displaying the question and its options.
  /// Includes actions for editing and deleting the question.
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

  /// Opens the question dialog to add a new question.
  void _addQuestion() => _showQuestionDialog();

  /// Opens the question dialog to edit an existing question at [index].
  void _editQuestion(int index) => _showQuestionDialog(editIndex: index);

  /// Removes a question from the list at [index].
  void _deleteQuestion(int index) {
    setState(() => _questions.removeAt(index));
  }

  /// Displays a dialog for adding or editing a question.
  /// [editIndex] is provided when editing an existing question.
  /// Handles input validation and state updates.
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
          title: Text(isEdit ? AppMessages.editQuestion.tr : AppMessages.addQuestion.tr),
          contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppMessages.questionRequired.tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: questionCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: AppMessages.enterQuestion.tr,
                      filled: true, fillColor: const Color(0xFFF5F7FB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                   Text(AppMessages.answerOptions.tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(AppMessages.markCorrectAnswer.tr, style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                              hintText: '${AppMessages.option.tr} ${String.fromCharCode(65 + i)}',
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppMessages.cancel.tr)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _primary),
              onPressed: () {
                final question = questionCtrl.text.trim();
                final options = optionCtrls.map((c) => c.text.trim()).toList();
                if (question.isEmpty || options.any((o) => o.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppMessages.fillQuestionAndOptions.tr)),
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
              child: Text(isEdit ? AppMessages.update.tr :  AppMessages.add.tr, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
