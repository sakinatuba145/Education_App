import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'result_screen.dart';
import 'package:education_app/core/constants.dart';

class QuizScreen extends StatefulWidget {
  final ExamModel exam;

  const QuizScreen({
    super.key,
    required this.exam,
  });

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
        if (answers[i] == q.correctIndex) {
          score++;
        }
      } else {
        if ((answers[i] ?? "").toString().isNotEmpty) {
          score++;
        }
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

  void nextQuestion() {
    if (currentIndex < widget.exam.questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void prevQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.exam.questions[currentIndex];
    final isLast = currentIndex == widget.exam.questions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Q ${currentIndex + 1}/${widget.exam.questions.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  q.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: q.type == QuestionType.mcq
                    ? ListView.builder(
                  itemCount: q.options.length,
                  itemBuilder: (context, i) {
                    final selected =
                        answers[currentIndex] == i;

                    return GestureDetector(
                      onTap: () => selectAnswer(i),
                      child: Container(
                        margin:
                        const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withOpacity(0.2)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(q.options[i]),
                      ),
                    );
                  },
                )
                    : TextField(
                  onChanged: (val) {
                    answers[currentIndex] = val;
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Write answer...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Row(
                children: [


                  Expanded(
                    child: ElevatedButton(
                      onPressed: prevQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Text("Previous"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLast ? submitQuiz : nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: Text(isLast ? "Submit" : "Next"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}