import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';
import 'package:education_app/student/progress_service.dart';

import '../core/widgets/students_widgets/quiz_empty_view.dart';
import '../core/widgets/students_widgets/quiz_loading_view.dart';
import '../core/widgets/students_widgets/quiz_option_card.dart';
import '../core/widgets/students_widgets/quiz_screen_body.dart';

class Quiz {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String quizTitle;
  final String courseId;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.quizTitle,
    required this.courseId,
  });

  factory Quiz.fromMap(String id, Map<String, dynamic> map,
      {String title = 'Quiz', String courseId = ''}) {
    return Quiz(
      id: id,
      question: map['question'] ?? map['text'] ?? '',
      options: List<String>.from(map['options'] ?? map['choices'] ?? []),
      correctAnswer:
          (map['correctAnswer'] ?? map['correctIndex'] ?? 0) as int,
      quizTitle: title,
      courseId: courseId,
    );
  }
}

class QuizPlayerScreenPremium extends StatefulWidget {
  final String? courseId;
  final String? lessonId;
  final String? quizId;

  const QuizPlayerScreenPremium({
    super.key,
    this.courseId,
    this.lessonId,
    this.quizId,
  });

  @override
  State<QuizPlayerScreenPremium> createState() =>
      _QuizPlayerScreenPremiumState();
}

class _QuizPlayerScreenPremiumState extends State<QuizPlayerScreenPremium>
    with SingleTickerProviderStateMixin {
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  late AnimationController _optionController;
  final ProgressService _progressService = ProgressService();

  List<Quiz> _quizzes = [];
  bool _loading = true;
  String? _quizTitle;
  String? _quizId;

  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _optionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadQuizzes();
  }

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
  }

  Future<void> _loadQuizzes() async {
    try {
      setState(() => _loading = true);
      List<Quiz> quizzes = [];
      String? quizTitle;
      String? quizId;

      if (widget.courseId != null && widget.lessonId != null) {
        final snap = await FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .collection('lessons')
            .doc(widget.lessonId)
            .collection('quizzes')
            .get();
        for (final doc in snap.docs) {
          final data = doc.data();
          final title = data['title'] ?? 'Quiz';
          quizTitle = title;
          quizId = doc.id;
          final questions = List<Map<String, dynamic>>.from(
              data['questions'] ?? []);
          for (int i = 0; i < questions.length; i++) {
            quizzes.add(Quiz.fromMap('$i', questions[i],
                title: title, courseId: widget.courseId ?? ''));
          }
          break;
        }
      } else if (widget.quizId != null) {
        final doc = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizId)
            .get();
        if (doc.exists) {
          final data = doc.data()!;
          quizTitle = data['title'] ?? 'Quiz';
          quizId = doc.id;
          final questions = List<Map<String, dynamic>>.from(
              data['questions'] ?? []);
          for (int i = 0; i < questions.length; i++) {
            quizzes.add(Quiz.fromMap('$i', questions[i],
                title: quizTitle!, courseId: ''));
          }
        }
      } else {
        final snap = await FirebaseFirestore.instance
            .collection('quizzes')
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty) {
          final doc = snap.docs.first;
          final data = doc.data();
          quizTitle = data['title'] ?? 'Quiz';
          quizId = doc.id;
          final questions = List<Map<String, dynamic>>.from(
              data['questions'] ?? []);
          for (int i = 0; i < questions.length; i++) {
            quizzes.add(Quiz.fromMap('$i', questions[i],
                title: quizTitle!, courseId: ''));
          }
        }
      }

      setState(() {
        _quizzes = quizzes;
        _quizTitle = quizTitle;
        _quizId = quizId;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _selectAnswer(int index) {
    if (!_answered) {
      if (_quizzes[_currentQuestion].correctAnswer == index) {
        _correctCount++;
      }
      setState(() {
        _selectedAnswer = index;
        _answered = true;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestion < _quizzes.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      _submitQuiz();
    }
  }

  Future<void> _submitQuiz() async {
    await _progressService.saveQuizResult(
      quizId: _quizId ?? 'unknown',
      quizTitle: _quizTitle ?? 'Quiz',
      courseId: widget.courseId ?? '',
      lessonId: widget.lessonId ?? '',
      score: _correctCount,
      totalQuestions: _quizzes.length,
    );
    if (mounted) {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final percent =
        (_correctCount / _quizzes.length * 100).round();
    final passed = percent >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              color: passed ? AppColors.warning : AppColors.error,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(passed ? 'Well Done!' : 'Keep Practicing'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressAnimated(
              value: _correctCount / _quizzes.length,
              size: 100,
              strokeWidth: 8,
              showPercentage: false,
              centerChild: Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: passed ? AppColors.success : AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$_correctCount / ${_quizzes.length} correct',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              passed
                  ? 'Great job! You passed this quiz.'
                  : 'You need 70% to pass. Try again!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestion = 0;
                _selectedAnswer = null;
                _answered = false;
                _correctCount = 0;
              });
            },
            child: const Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    if (_loading) {
      return const QuizLoadingView();
    }

    if (_quizzes.isEmpty) {
      return const QuizEmptyView();
    }

    return QuizScreenBody(
      quizTitle: _quizTitle,
      quizzes: _quizzes,
      currentQuestion: _currentQuestion,
      selectedAnswer: _selectedAnswer,
      answered: _answered,
      onSelectAnswer: _selectAnswer,
      onNextQuestion: _nextQuestion,
    );
  }

}
