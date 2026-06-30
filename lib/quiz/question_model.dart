import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';
import 'quiz_model.dart';
import 'quiz_screen.dart';

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

  InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: ThemeColors.secondary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Add Questions",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
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

                  TextField(
                    controller: questionController,
                    decoration: input("Question"),
                  ),

                  const SizedBox(height: 14),

                  if (selectedType == QuestionType.mcq) ...[
                    ...List.generate(4, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: options[i],
                          decoration: input("Option ${i + 1}"),
                        ),
                      );
                    }),

                    DropdownButton<int>(
                      value: correctIndex,
                      isExpanded: true,
                      items: List.generate(4, (i) {
                        return DropdownMenuItem(
                          value: i,
                          child: Text("Correct Answer ${i + 1}"),
                        );
                      }),
                      onChanged: (v) {
                        setState(() => correctIndex = v!);
                      },
                    ),
                  ],

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: addQuestion,
                      child: const Text("Add Question"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(exam: widget.exam),
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
    );
  }
}