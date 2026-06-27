import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'package:education_app/core/constants/theme.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final ExamModel exam;
  final Map<int, dynamic> answers;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.exam,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = ((score / total) * 100).round();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Result"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: ThemeColors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Text(
                  "$score / $total",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: ThemeColors.primary),
                ),
                Text(
                  "$percentage%",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exam.questions.length,
            itemBuilder: (context, i) {
              final q = exam.questions[i];
              final userAnswer = answers[i];

              final isCorrect = q.type == QuestionType.mcq
                  ? userAnswer == q.correctIndex
                  : (userAnswer ?? "").toString().isNotEmpty;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.question,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isCorrect ? "Correct" : "Wrong",
                      style: TextStyle(
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () => Navigator.popUntil(
              context,
                  (route) => route.isFirst,
            ),
            child: const Text("Back to Home"),
          ),
        ],
      ),
    );
  }
}