import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_model.dart';
import 'quiz_screen.dart';
import 'package:education_app/core/constants/theme.dart';

/// 3.4 ADD QUESTION SCREEN
/// Allows teachers to add questions.

class TeacherAddQuestionScreen extends StatefulWidget {
  final String examId;

  const TeacherAddQuestionScreen({
    super.key,
    required this.examId,
  });

  @override
  State<TeacherAddQuestionScreen> createState() =>
      _TeacherAddQuestionScreenState();
}

class _TeacherAddQuestionScreenState extends State<TeacherAddQuestionScreen> {
  /// 3.5 QUESTION DATA
  /// Stores the question, answer options, and question type.
  final questionController = TextEditingController();
  final options = List.generate(4, (_) => TextEditingController());

  QuestionType selectedType = QuestionType.mcq;
  int correctIndex = 0;
  /// 3.6 ADD QUESTION
  /// Saves the question and its answers to Firestore.
  void addQuestion() async {
    if (questionController.text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.examId)
        .collection('questions')
        .add({
      "question": questionController.text,
      "type": selectedType.toString(),
      "options":
      selectedType == QuestionType.mcq
          ? options.map((e) => e.text).toList()
          : [],
      "correctIndex":
      selectedType == QuestionType.mcq ? correctIndex : -1,
    });

    questionController.clear();
    for (var o in options) {
      o.clear();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ConstrainedBox(
                  constraints:
                  BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),

                            Text(
                              "Add Questions",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Create questions for this exam",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),

                            const SizedBox(height: 30),

                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(22),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  /// 3.7 QUESTION TYPE
                                  /// Teacher chooses whether the question is MCQ or Text.
                                  Row(
                                    children: [
                                      ChoiceChip(
                                        label: const Text("MCQ"),
                                        selected:
                                        selectedType ==
                                            QuestionType.mcq,
                                        onSelected: (_) {
                                          setState(() {
                                            selectedType =
                                                QuestionType.mcq;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      ChoiceChip(
                                        label: const Text("Text"),
                                        selected:
                                        selectedType ==
                                            QuestionType.text,
                                        onSelected: (_) {
                                          setState(() {
                                            selectedType =
                                                QuestionType.text;
                                          });
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  TextField(
                                    controller: questionController,
                                    decoration: const InputDecoration(
                                      hintText: "Question",
                                      prefixIcon:
                                      Icon(Icons.help_outline),
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  if (selectedType ==
                                      QuestionType.mcq) ...[
                                    ...List.generate(4, (i) {
                                      return Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            bottom: 10),
                                        child: TextField(
                                          controller: options[i],
                                          decoration: InputDecoration(
                                            hintText:
                                            "Option ${i + 1}",
                                            prefixIcon: const Icon(
                                                Icons.circle_outlined),
                                          ),
                                        ),
                                      );
                                    }),

                                    DropdownButtonFormField<int>(
                                      value: correctIndex,
                                      items: List.generate(4, (i) {
                                        return DropdownMenuItem(
                                          value: i,
                                          child: Text(
                                              "Correct Answer ${i + 1}"),
                                        );
                                      }),
                                      onChanged: (v) {
                                        setState(() {
                                          correctIndex = v!;
                                        });
                                      },
                                    ),
                                  ],

                                  const SizedBox(height: 22),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: addQuestion,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        ThemeColors.button,
                                        foregroundColor:
                                        Colors.white,
                                      ),
                                      child: const Text("Add Question"),
                                    ),
                                  ),

                                  const SizedBox(height: 12),
                                  /// PREVIEW QUIZ
                                  /// Opens the quiz so the teacher can test it before publishing.
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                QuizScreen(
                                                  examId: widget.examId,
                                                ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.remove_red_eye),
                                      label:
                                      const Text("Preview Quiz"),
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}