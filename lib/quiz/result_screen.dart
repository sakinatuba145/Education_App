import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'package:education_app/core/constants.dart';

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
    final passed = percentage >= 50;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [

                  Icon(
                    passed ? Icons.emoji_events : Icons.close,
                    size: 60,
                    color: passed ? Colors.green : Colors.red,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    passed ? "Excellent!" : "Try Again",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "$score / $total",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  Text(
                    "$percentage%",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: exam.questions.length,
                itemBuilder: (context, i) {
                  final q = exam.questions[i];

                  bool correct = false;

                  if (q.type == QuestionType.mcq) {
                    correct = answers[i] == q.correctIndex;
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: correct ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          q.question,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          correct ? "Correct" : "Wrong",
                          style: TextStyle(
                            color: correct
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(14),
                  ),
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