import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'result_screen.dart';
import 'package:education_app/core/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
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
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      "Q ${currentIndex + 1}/${widget.exam.questions.length}",
                      style: GoogleFonts.poppins(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    q.question,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
                              ? AppColors.primary.withOpacity(0.15)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary,
                          ),
                        ),
                        child: Text(
                          q.options[i],
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    );
                  },
                )
                    : TextField(
                  onChanged: (val) => answers[currentIndex] = val,
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

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: currentIndex > 0
                            ? () => setState(() => currentIndex--)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text("Previous"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLast
                            ? submitQuiz
                            : () => setState(() => currentIndex++),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(isLast ? "Submit" : "Next"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}