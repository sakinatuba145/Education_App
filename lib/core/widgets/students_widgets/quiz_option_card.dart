import 'package:flutter/material.dart';
import '../../../quiz/quiz_player_screen_premium.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/theme.dart';


class QuizOptionCard extends StatelessWidget {
  const QuizOptionCard({
    super.key,
    required this.quiz,
    required this.index,
    required this.selectedAnswer,
    required this.answered,
    required this.onSelect,
  });

  final Quiz quiz;
  final int index;
  final int? selectedAnswer;
  final bool answered;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedAnswer == index;
    final isCorrect = index == quiz.correctAnswer;

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (answered) {
      if (isCorrect) {
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        borderColor = AppColors.success;
        textColor = AppColors.success;
      } else if (isSelected) {
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
        backgroundColor = ThemeColors.primary.withValues(alpha: 0.1);
        borderColor = ThemeColors.primary;
        textColor = ThemeColors.primary;
      } else {
        backgroundColor = Colors.white;
        borderColor = AppColors.gray300;
        textColor = ThemeColors.black;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacing_12),
      child: GestureDetector(
        onTap: () => onSelect(index),
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
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: answered
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