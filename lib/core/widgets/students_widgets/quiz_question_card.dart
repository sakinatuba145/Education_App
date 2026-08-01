import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';


class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    super.key,
    required this.question,
  });

  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        question,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}