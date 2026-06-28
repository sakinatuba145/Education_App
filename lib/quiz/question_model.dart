import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'quiz_screen.dart';
import 'package:education_app/core/constants/theme.dart';

class TeacherAddQuestionScreen extends StatefulWidget {
  final ExamModel exam;

  const TeacherAddQuestionScreen({
    super.key,
    required this.exam,
  });

  @override
  State<TeacherAddQuestionScreen> createState() =>
      _TeacherAddQuestionScreenState();
}

class _TeacherAddQuestionScreenState
    extends State<TeacherAddQuestionScreen> {
  final questionController = TextEditingController();
  final options = List.generate(4, (_) => TextEditingController());

  QuestionType selectedType = QuestionType.mcq;
  int correctIndex = 0;

  void addQuestion() {
    if (questionController.text.isEmpty) return;

    widget.exam.questions.add(
      QuizModel(
        id: DateTime.now().toString(),
        question: questionController.text,
        options: selectedType == QuestionType.mcq
            ? options.map((e) => e.text).toList()
            : [],
        correctIndex: selectedType == QuestionType.mcq ? correctIndex : -1,
        type: selectedType,
      ),
    );

    questionController.clear();
    for (var o in options) {
      o.clear();
    }

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
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
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),

                            const SizedBox(height: 30),

                            Container(
                              padding: const EdgeInsets.all(18),
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ChoiceChip(
                                        label: const Text("MCQ"),
                                        selected:
                                        selectedType == QuestionType.mcq,
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
                                        selectedType == QuestionType.text,
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
                                        padding: const EdgeInsets.only(
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
                                      decoration:
                                      const InputDecoration(),
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
                                      child: const Text(
                                        "Add Question",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => QuizScreen(
                                              exam: widget.exam,
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