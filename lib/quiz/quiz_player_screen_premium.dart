import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/core/constants/app_dimensions.dart';
import 'package:education_app/core/widgets/animated_button.dart';
import 'package:education_app/core/widgets/animated_progress_indicators.dart';

/// Premium quiz interface with animated options
class QuizPlayerScreenPremium extends StatefulWidget {
  const QuizPlayerScreenPremium({super.key});

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

  final List<Quiz> _quizzes = [
    Quiz(
      question: 'What is the purpose of BuildContext in Flutter?',
      options: [
        'To manage widget state',
        'To provide access to theme and navigation',
        'To define widget layout',
        'To handle user input',
      ],
      correctAnswer: 1,
    ),
    Quiz(
      question: 'Which widget is used for scrollable content?',
      options: [
        'Column',
        'Container',
        'SingleChildScrollView',
        'Stack',
      ],
      correctAnswer: 2,
    ),
    Quiz(
      question: 'What is hot reload in Flutter?',
      options: [
        'A way to reload the app completely',
        'A feature to refresh the UI without restarting the app',
        'A debugging tool',
        'A performance optimization',
      ],
      correctAnswer: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _optionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (!_answered) {
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
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete! 🎉'),
        content: const Text('You have successfully completed the quiz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _quizzes[_currentQuestion];
    final progress = (_currentQuestion + 1) / _quizzes.length;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Quiz'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spacing_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
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
            // Question
            Text(
              quiz.question,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: AppDimensions.spacing_32),
            // Options
            ...List.generate(
              quiz.options.length,
              (index) => _buildOptionCard(quiz, index),
            ),
            SizedBox(height: AppDimensions.spacing_32),
            // Submit button
            if (_answered)
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimensions.spacing_12),
                    decoration: BoxDecoration(
                      color: (_selectedAnswer == quiz.correctAnswer)
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radius_large),
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
                                ? 'Correct answer!'
                                : 'Wrong answer. Try next question.',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                        ? 'Finish Quiz'
                        : 'Next Question',
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
              // Option indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderColor.withValues(alpha: 0.2),
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
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

class Quiz {
  final String question;
  final List<String> options;
  final int correctAnswer;

  Quiz({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}
