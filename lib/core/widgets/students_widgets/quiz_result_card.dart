import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';


class QuizResultCard extends StatelessWidget {
  const QuizResultCard({
    super.key,
    required this.correct,
    required this.correctAnswer,
  });

  final bool correct;
  final String correctAnswer;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(AppDimensions.spacing_12),
      decoration: BoxDecoration(
        color: correct
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius:
        BorderRadius.circular(AppDimensions.radius_large),
        border: Border.all(
          color: correct
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            correct
                ? Icons.check_circle
                : Icons.cancel,
            color: correct
                ? AppColors.success
                : AppColors.error,
          ),
          SizedBox(width: AppDimensions.spacing_12),
          Expanded(
            child: Text(
              correct
                  ? 'Correct! Great job!'
                  : 'Incorrect. The correct answer is: $correctAnswer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: correct
                    ? AppColors.success
                    : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}