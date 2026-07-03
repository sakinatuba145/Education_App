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

  ///3.9 CURRENT QUESTION INDEX
  /// tracks which question user is on
  int currentIndex = 0;

  /// 3.10 USER ANSWERS STORAGE
  /// stores mcq index OR text answer
  final Map<int, dynamic> answers = {};

  /// TEXT CONTROLLERS (FIX FOR TEXT STICKING ISSUE)
  final Map<int, TextEditingController> controllers = {};

  /// GET CONTROLLER (PRESERVE TEXT PER QUESTION)
  TextEditingController getController(int index) {
    if (!controllers.containsKey(index)) {
      controllers[index] = TextEditingController(
        text: answers[index]?.toString() ?? "",
      );
    }
    return controllers[index]!;
  }

  /// 3.11SELECT MCQ ANSWER
  void selectAnswer(int value) {
    setState(() {
      answers[currentIndex] = value;
    });
  }

  /// 3.12 SUBMIT QUIZ
  /// calculates score and navigates to result screen
  void submitQuiz() {
    int score = 0;

    for (int i = 0; i < widget.exam.questions.length; i++) {
      final q = widget.exam.questions[i];

      if (q.type == QuestionType.mcq) {
        if (answers[i] == q.correctIndex) score++;
      } else {
        if ((answers[i] ?? "").toString().trim().isNotEmpty) score++;
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
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// 3.13 SAFE EMPTY STATE (NO CRASH)
    /// if no questions exist, show simple UI instead of crash
    if (widget.exam.questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No Questions Yet"),
        ),
      );
    }

    /// 3.14 CURRENT QUESTION
    final q = widget.exam.questions[currentIndex];
    final isLast = currentIndex == widget.exam.questions.length - 1;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Stack(
            children: [

              /// BACK BUTTON
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              /// MAIN UI
              Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [

                          const SizedBox(height: 10),

                          /// QUESTION NUMBER
                          Text(
                            "Q ${currentIndex + 1}/${widget.exam.questions.length}",
                            style: theme.textTheme.bodyLarge,
                          ),

                          const SizedBox(height: 20),

                          /// QUESTION BOX
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Text(q.question),
                          ),

                          const SizedBox(height: 20),

                          /// MCQ OR TEXT ANSWER
                          q.type == QuestionType.mcq
                              ? Column(
                            children: List.generate(q.options.length, (i) {
                              final selected = answers[currentIndex] == i;

                              return GestureDetector(
                                onTap: () => selectAnswer(i),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? ThemeColors.primary.withOpacity(0.2)
                                        : theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(q.options[i]),
                                ),
                              );
                            }),
                          )
                              : TextField(
                            controller: getController(currentIndex),
                            onChanged: (val) {
                              answers[currentIndex] = val;
                            },
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: "Write answer...",
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// NAVIGATION BUTTONS
                          Row(
                            children: [

                              /// PREVIOUS
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.button,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onPressed: currentIndex > 0
                                      ? () {
                                    setState(() {
                                      currentIndex--;
                                    });
                                  }
                                      : null,
                                  child: const Text("Previous"),
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// NEXT / SUBMIT
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.button,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onPressed: isLast
                                      ? submitQuiz
                                      : () {
                                    setState(() {
                                      currentIndex++;
                                    });
                                  },
                                  child: Text(isLast ? "Submit" : "Next"),
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
            ],
          ),
        ),
      ),
    );
  }
}