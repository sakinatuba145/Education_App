import 'package:flutter/material.dart';
import '../../../quiz/quiz_player_screen_premium.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/theme.dart';
import '../animated_button.dart';
import '../animated_progress_indicators.dart';
import 'quiz_option_card.dart';


class QuizScreenBody extends StatelessWidget {
  const QuizScreenBody({
    super.key,
    required this.quizTitle,
    required this.quizzes,
    required this.currentQuestion,
    required this.selectedAnswer,
    required this.answered,
    required this.onSelectAnswer,
    required this.onNextQuestion,
  });

  final String? quizTitle;
  final List<Quiz> quizzes;

  final int currentQuestion;
  final int? selectedAnswer;
  final bool answered;

  final Function(int) onSelectAnswer;
  final VoidCallback onNextQuestion;

  @override
  Widget build(BuildContext context) {
    final quiz = quizzes[currentQuestion];
    final progress = (currentQuestion + 1) / quizzes.length;

    return Scaffold(
      backgroundColor: ThemeColors.background,

      appBar: AppBar(
        title: Text(quizTitle ?? 'Quiz'),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.gray300,
            valueColor: const AlwaysStoppedAnimation(ThemeColors.primary),
            minHeight: 3,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spacing_16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentQuestion + 1} of ${quizzes.length}',
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

            /// Question Card
            Container(
              padding: EdgeInsets.all(AppDimensions.spacing_20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radius_large),
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

            /// Options
            ...List.generate(
              quiz.options.length,
              (index) => QuizOptionCard(
                quiz: quiz,
                index: index,
                selectedAnswer: selectedAnswer,
                answered: answered,
                onSelect: onSelectAnswer,
              ),
            ),

            SizedBox(height: AppDimensions.spacing_32),

            /// Result
            if (answered)
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),

                    padding: EdgeInsets.all(AppDimensions.spacing_12),
                    decoration: BoxDecoration(
                      color: selectedAnswer == quiz.correctAnswer
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),

                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius_large,
                      ),

                      border: Border.all(
                        color: selectedAnswer == quiz.correctAnswer
                            ? AppColors.success.withValues(alpha: 0.3)
                            : AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),

                    child: Row(
                      children: [
                        Icon(
                          selectedAnswer == quiz.correctAnswer
                              ? Icons.check_circle
                              : Icons.cancel,

                          color: selectedAnswer == quiz.correctAnswer
                              ? AppColors.success
                              : AppColors.error,
                        ),

                        SizedBox(width: AppDimensions.spacing_12),

                        Expanded(
                          child: Text(
                            selectedAnswer == quiz.correctAnswer
                                ? 'Correct! Great job!'
                                : 'Incorrect. The correct answer is: ${quiz.options[quiz.correctAnswer]}',

                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: selectedAnswer == quiz.correctAnswer
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
                    label: currentQuestion == quizzes.length - 1
                        ? 'Finish & See Results'
                        : 'Next Question →',

                    onPressed: onNextQuestion,

                    isFullWidth: true,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
