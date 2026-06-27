import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';
import 'package:education_app/student/services/progress_service.dart';

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
              backgroundColor: AppColors.primary,
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
      return Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          title: const Text('Quizzes'),
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_quizzes.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          title: const Text('Quizzes'),
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz_outlined, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 24),
              Text(
                'No Quizzes Yet',
                style:
                    Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your teacher hasn\'t assigned any quizzes yet.\nCheck back soon!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final quiz = _quizzes[_currentQuestion];
    final progress = (_currentQuestion + 1) / _quizzes.length;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(_quizTitle ?? 'Quiz'),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.gray300,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spacing_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestion + 1} of ${_quizzes.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                CircularProgressAnimated(
                  value: progress,
                  size: 60,
                  strokeWidth: 4,
                  showPercentage: false,
                  centerChild: Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacing_24),

            Container(
              padding: EdgeInsets.all(AppDimensions.spacing_20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radius_large),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                quiz.question,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SizedBox(height: AppDimensions.spacing_24),

            ...List.generate(
              quiz.options.length,
              (index) => _buildOptionCard(quiz, index),
            ),
            SizedBox(height: AppDimensions.spacing_32),

            if (_answered)
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(AppDimensions.spacing_12),
                    decoration: BoxDecoration(
                      color: (_selectedAnswer == quiz.correctAnswer)
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius_large),
                      border: Border.all(
                        color: (_selectedAnswer == quiz.correctAnswer)
                            ? AppColors.success.withValues(alpha: 0.3)
                            : AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          (_selectedAnswer == quiz.correctAnswer)
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: (_selectedAnswer == quiz.correctAnswer)
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        SizedBox(width: AppDimensions.spacing_12),
                        Expanded(
                          child: Text(
                            (_selectedAnswer == quiz.correctAnswer)
                                ? 'Correct! Great job!'
                                : 'Incorrect. The correct answer is: ${quiz.options[quiz.correctAnswer]}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: (_selectedAnswer ==
                                          quiz.correctAnswer)
                                      ? AppColors.success
                                      : AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing_16),
                  AnimatedElevatedButton(
                    label: _currentQuestion == _quizzes.length - 1
                        ? 'Finish & See Results'
                        : 'Next Question →',
                    onPressed: _nextQuestion,
                    isFullWidth: true,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(Quiz quiz, int index) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = index == quiz.correctAnswer;
    final showResult = _answered;

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (showResult) {
      if (isCorrect) {
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
        textColor = AppColors.success;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        borderColor = AppColors.error;
        textColor = AppColors.error;
      } else {
        backgroundColor = AppColors.gray100;
        borderColor = AppColors.gray300;
        textColor = AppColors.gray700;
      }
    } else {
      if (isSelected) {
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        borderColor = AppColors.primary;
        textColor = AppColors.primary;
      } else {
        backgroundColor = Colors.white;
        borderColor = AppColors.gray300;
        textColor = AppColors.dark;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing_12),
      child: GestureDetector(
        onTap: () => _selectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(AppDimensions.spacing_16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                BorderRadius.circular(AppDimensions.radius_large),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderColor.withValues(alpha: 0.2),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Center(
                  child: showResult
                      ? Icon(
                          isCorrect
                              ? Icons.check
                              : (isSelected ? Icons.close : null),
                          color: borderColor,
                          size: 18,
                        )
                      : Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            color: borderColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(width: AppDimensions.spacing_16),
              Expanded(
                child: Text(
                  quiz.options[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
