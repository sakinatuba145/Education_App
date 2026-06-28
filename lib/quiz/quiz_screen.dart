import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'result_screen.dart';
import 'package:education_app/core/constants/theme.dart';

class QuizScreen extends StatefulWidget {
  static String id = 'quiz_screen';
  final ExamModel exam;

  const QuizScreen({super.key, required this.exam});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  final Map<int, dynamic> answers = {};

  void selectAnswer(int value) {
    setState(() {
      answers[currentIndex] = value;
    });
  }

  void submitQuiz() {
    int score = 0;

    for (int i = 0; i < widget.exam.questions.length; i++) {
      final q = widget.exam.questions[i];

      if (q.type == QuestionType.mcq) {
        if (answers[i] == q.correctIndex) score++;
      } else {
        if ((answers[i] ?? "").toString().isNotEmpty) score++;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: score,
          total: widget.exam.questions.length,
          exam: widget.exam,
          answers: answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.exam.questions[currentIndex];
    final isLast = currentIndex == widget.exam.questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Q ${currentIndex + 1}/${widget.exam.questions.length}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
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

                  /// QUESTION CARD
                  Container(
                    padding: const EdgeInsets.all(18),
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
                    child: Text(
                      q.question,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// OPTIONS
                  q.type == QuestionType.mcq
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: q.options.length,
                    itemBuilder: (context, i) {
                      final selected = answers[currentIndex] == i;

                      return GestureDetector(
                        onTap: () => selectAnswer(i),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: selected
                                ? ThemeColors.secondary.withOpacity(0.3)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: ThemeColors.primary),
                          ),
                          child: Text(
                            q.options[i],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      );
                    },
                  )
                      : TextField(
                    onChanged: (val) =>
                    answers[currentIndex] = val,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "Write answer...",
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTONS
                  Row(
                    children: [

                      /// PREVIOUS
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: currentIndex > 0
                                ? () => setState(() => currentIndex--)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Previous",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// NEXT / SUBMIT
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLast
                                ? submitQuiz
                                : () => setState(() => currentIndex++),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColors.button,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              isLast ? "Submit" : "Next",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
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