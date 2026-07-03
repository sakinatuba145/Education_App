import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'package:education_app/core/constants/theme.dart';

class ResultScreen extends StatelessWidget {

  /// 3.15 QUIZ RESULT DATA
  /// score, total questions, exam, and user answers
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
    final theme = Theme.of(context);

    /// 3.16 PERCENTAGE CALCULATION
    final percentage = ((score / total) * 100).round();

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [

                      const SizedBox(height: 20),

                      /// RESULT TITLE
                      Text(
                        "Result",
                        style: theme.textTheme.headlineLarge,
                      ),

                      const SizedBox(height: 20),

                      /// SCORE CARD
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [

                            Text(
                              "$score / $total",
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: ThemeColors.primary,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "$percentage%",
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// QUESTION REVIEW LIST
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: exam.questions.length,
                        itemBuilder: (context, i) {

                          final q = exam.questions[i];
                          final userAnswer = answers[i];

                          /// CHECK IF ANSWER IS CORRECT
                          final isCorrect = q.type == QuestionType.mcq
                              ? userAnswer == q.correctIndex
                              : (userAnswer ?? "").toString().isNotEmpty;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// QUESTION TEXT
                                Text(q.question),

                                const SizedBox(height: 8),

                                /// USER ANSWER
                                if (q.type == QuestionType.mcq)
                                  Text(
                                    "Your Answer: ${q.options[userAnswer ?? 0]}",
                                  )
                                else
                                  Text("Your Answer: ${userAnswer ?? ""}"),

                                const SizedBox(height: 6),

                                /// RESULT STATUS
                                Text(
                                  isCorrect ? "Correct" : "Wrong",
                                  style: TextStyle(
                                    color: isCorrect ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      /// BACK TO HOME BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColors.button,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.popUntil(
                              context,
                                  (route) => route.isFirst,
                            );
                          },
                          child: const Text("Back to Home"),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}