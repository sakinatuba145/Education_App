import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'result_screen.dart';
import 'quiz_model.dart';
import 'package:education_app/core/constants/theme.dart';

/// 3.11  QUIZ SCREEN
/// Displays quiz questions and handles user answers and scoring.
class QuizScreen extends StatefulWidget {
  static String id = 'quiz_screen';
  final String examId;

  const QuizScreen({super.key, required this.examId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  ///  CURRENT QUESTION INDEX
  /// Tracks which question is currently shown.
  int currentIndex = 0;

  ///  USER ANSWERS
  /// Stores selected answers for each question.
  final Map<int, dynamic> answers = {};

  /// Controller for text answers
  final TextEditingController answerController = TextEditingController();

  /// Saves user selected answer for current question.
  void selectAnswer(int value) {
    setState(() {
      answers[currentIndex] = value;
    });
  }

  ///SUBMIT QUIZ
  /// Calculates score and navigates to result screen.
  void submitQuiz(List docs) {
    int score = 0;

    final questions = docs.map((q) {
      final data = q.data() as Map<String, dynamic>;
      return QuizModel(
        id: q.id,
        question: data['question'] ?? '',
        options: List<String>.from(data['options'] ?? const []),
        correctIndex: data['correctIndex'] ?? -1,
        type: data['type'] == 'QuestionType.text'
            ? QuestionType.text
            : QuestionType.mcq,
      );
    }).toList();

    for (int i = 0; i < docs.length; i++) {
      final q = docs[i];

      if (q['type'] == 'QuestionType.mcq') {
        if (answers[i] == q['correctIndex']) score++;
      } else {
        if ((answers[i] ?? "").toString().isNotEmpty) score++;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          score: score,
          total: docs.length,
          exam: ExamModel(
            id: widget.examId,
            title: '',
            subject: '',
            questions: questions,
          ),
          answers: answers,
        ),
      ),
    );
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ThemeColors.black),
        title: const Text("Quiz"),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.examId)
            .collection('questions')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final questions = snapshot.data!.docs;

          if (questions.isEmpty) {
            return const Center(child: Text("No questions found"));
          }

          final q = questions[currentIndex];
          final isLast = currentIndex == questions.length - 1;

          return AppBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 20),

                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    q['question'],
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// Displays MCQ options or text input based on question type.
                                Container(
                                  height: 260,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: q['type'] == 'QuestionType.mcq'
                                      ? ListView.builder(
                                          itemCount:
                                              (q['options'] as List).length,
                                          itemBuilder: (context, i) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  q['options'][i],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                onTap: () => selectAnswer(i),
                                              ),
                                            );
                                          },
                                        )
                                      : TextField(
                                          key: ValueKey(currentIndex),
                                          controller: answerController,
                                          onChanged: (val) {
                                            answers[currentIndex] = val;
                                          },
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: "Write answer...",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                ),

                                const SizedBox(height: 25),

                                /// Move between questions or submit quiz.
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade600,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        onPressed: currentIndex > 0
                                            ? () {
                                                setState(() {
                                                  currentIndex--;

                                                  // restore previous text answer if exists
                                                  final prev =
                                                      answers[currentIndex];
                                                  answerController.text =
                                                      prev is String
                                                      ? prev
                                                      : '';
                                                });
                                              }
                                            : null,
                                        child: const Text("Previous"),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ThemeColors.button,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        onPressed: isLast
                                            ? () => submitQuiz(questions)
                                            : () {
                                                setState(() {
                                                  currentIndex++;

                                                  // restore next question answer if exists
                                                  final next =
                                                      answers[currentIndex];
                                                  answerController.text =
                                                      next is String
                                                      ? next
                                                      : '';
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
