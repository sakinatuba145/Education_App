import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'quiz_screen.dart';

class TeacherAddQuestionScreen extends StatefulWidget {
  final ExamModel exam;

  const TeacherAddQuestionScreen({super.key, required this.exam});

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
        correctIndex:
        selectedType == QuestionType.mcq ? correctIndex : -1,
        type: selectedType,
      ),
    );

    questionController.clear();
    for (var o in options) {
      o.clear();
    }

    setState(() {});
  }

  InputDecoration input(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                const SizedBox(width: 10),
                Text(
                  "Add Questions",
                  style: theme.textTheme.headlineMedium,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [

                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("MCQ"),
                        selected: selectedType == QuestionType.mcq,
                        onSelected: (_) =>
                            setState(() => selectedType = QuestionType.mcq),
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("Text"),
                        selected: selectedType == QuestionType.text,
                        onSelected: (_) =>
                            setState(() => selectedType = QuestionType.text),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: questionController,
                    decoration: input(context, "Question"),
                  ),

                  const SizedBox(height: 14),

                  if (selectedType == QuestionType.mcq)
                    ...List.generate(4, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: options[i],
                          decoration:
                          input(context, "Option ${i + 1}"),
                        ),
                      );
                    }),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: addQuestion,
                    child: const Text("Add Question"),
                  ),

                  const SizedBox(height: 10),

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
    );
  }
}