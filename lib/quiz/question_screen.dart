import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/constants/theme.dart';
import 'quiz_model.dart';
import 'quiz_screen.dart';

/// 3.1 TEACHER ADD QUESTION SCREEN
/// Teachers create questions and save them to Firebase

class TeacherAddQuestionScreen extends StatefulWidget {
  final ExamModel exam;

  const TeacherAddQuestionScreen({super.key, required this.exam});

  @override
  State<TeacherAddQuestionScreen> createState() =>
      _TeacherAddQuestionScreenState();
}

class _TeacherAddQuestionScreenState extends State<TeacherAddQuestionScreen> {

  /// 3.2 INPUT CONTROLLERS
  final questionController = TextEditingController();
  final options = List.generate(4, (_) => TextEditingController());

  /// 3.3 QUESTION STATE
  QuestionType selectedType = QuestionType.mcq;
  int correctIndex = 0;

  /// 3.4 ADD QUESTION (SAVE TO FIREBASE)
  Future<void> addQuestion() async {
    if (questionController.text.trim().isEmpty) return;

    final newQuestion = QuizModel(
      id: DateTime.now().toString(),
      question: questionController.text.trim(),
      options: selectedType == QuestionType.mcq
          ? options.map((e) => e.text).toList()
          : [],
      correctIndex: selectedType == QuestionType.mcq ? correctIndex : -1,
      type: selectedType,
    );


    final updatedQuestions = List<QuizModel>.from(widget.exam.questions)
      ..add(newQuestion);

    await FirebaseFirestore.instance
        .collection("quizzes")
        .doc(widget.exam.id)
        .update({
      "questions": updatedQuestions.map((q) => q.toJson()).toList(),
    });

    /// clear UI
    questionController.clear();
    for (var o in options) {
      o.clear();
    }

    setState(() {
      widget.exam.questions.add(newQuestion); // update UI only AFTER save
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        /// TITLE
                        Text(
                          "Add Questions",
                          style: theme.textTheme.headlineLarge,
                        ),

                        const SizedBox(height: 20),

                        /// CARD
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            children: [

                              /// TYPE SELECT
                              Row(
                                children: [
                                  ChoiceChip(
                                    label: const Text("MCQ"),
                                    selected: selectedType == QuestionType.mcq,
                                    onSelected: (_) {
                                      setState(() => selectedType = QuestionType.mcq);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  ChoiceChip(
                                    label: const Text("Text"),
                                    selected: selectedType == QuestionType.text,
                                    onSelected: (_) {
                                      setState(() => selectedType = QuestionType.text);
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              /// QUESTION
                              TextField(
                                controller: questionController,
                                decoration: const InputDecoration(
                                  hintText: "Question",
                                ),
                              ),

                              const SizedBox(height: 14),

                              /// OPTIONS
                              if (selectedType == QuestionType.mcq)
                                ...List.generate(4, (i) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextField(
                                      controller: options[i],
                                      decoration: InputDecoration(
                                        hintText: "Option ${i + 1}",
                                      ),
                                    ),
                                  );
                                }),

                              const SizedBox(height: 10),

                              /// ADD BUTTON
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.button,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: addQuestion,
                                  child: const Text("Add Question"),
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// PREVIEW
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          QuizScreen(exam: widget.exam),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.remove_red_eye),
                                label: const Text("Preview Quiz"),
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
          ],
        ),
         ),),
    );
  }
}