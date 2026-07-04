import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';
/// 3.12 RESULT SCREEN
/// Shows final quiz score and percentage after submission.
class ResultScreen extends StatelessWidget {
  /// Receives score, total questions, and user answers.
  final int score;
  final int total;
  final Map<int, dynamic> answers;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    /// Converts score into percentage value.
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

                  Text(
                    "Your Result",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),

                  const SizedBox(height: 20),
                  /// Shows score and percentage in a styled card.
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

                  const Center(
                    child: Text(
                      "Review removed in Firestore version",
                    ),
                  ),

                  const SizedBox(height: 20),

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
                      ),
                      child: const Text("Back to Home"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}