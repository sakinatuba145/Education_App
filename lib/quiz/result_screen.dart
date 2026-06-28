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
      appBar: AppBar(
        title: const Text("Result"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ThemeColors.black),
      ),

      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [

                  /// TITLE
                  Text(
                    "Your Result",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),

                  const SizedBox(height: 20),

                  /// SCORE CARD
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
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
                        const SizedBox(height: 6),
                        Text(
                          "$percentage%",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// QUESTIONS REVIEW
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
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.question,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isCorrect ? "Correct" : "Wrong",
                              style: TextStyle(
                                color: isCorrect
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// BUTTON (MATCH CREATE EXAM STYLE)
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.popUntil(
                        context,
                            (route) => route.isFirst,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.button,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "Back to Home",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}