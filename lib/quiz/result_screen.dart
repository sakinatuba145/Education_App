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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Result",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Text(
                    "$score / $total",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: ThemeColors.primary,
                    ),
                  ),
                  Text(
                    "$percentage%",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exam.questions.length,
              itemBuilder: (context, i) {
                final q = exam.questions[i];
                final userAnswer = answers[i];

                bool isCorrect = q.type == QuestionType.mcq
                    ? userAnswer == q.correctIndex
                    : (userAnswer ?? "").toString().isNotEmpty;

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                      color: isCorrect ? Colors.green : Colors.red,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.question,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 8),

                      if (q.type == QuestionType.mcq) ...[
                        Text(
                          "Your Answer: ${q.options[userAnswer ?? 0]}",
                          style: TextStyle(
                            color:
                            isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        Text(
                          "Correct Answer: ${q.options[q.correctIndex]}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else
                        Text(
                          "Your Answer: ${userAnswer ?? ""}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                      const SizedBox(height: 6),

                      Text(
                        isCorrect ? "Correct" : "Wrong",
                        style: TextStyle(
                          color:
                          isCorrect ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                          (route) => route.isFirst,
                    );
                  },
                  child: const Text("Back to Home"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}