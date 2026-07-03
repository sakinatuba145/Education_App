import 'package:flutter/material.dart';
import 'quiz_model.dart';
import 'quiz_data.dart';
import 'question_screen.dart';

class TeacherCreateExamScreen extends StatefulWidget {
  const TeacherCreateExamScreen({super.key});

  @override
  State<TeacherCreateExamScreen> createState() =>
      _TeacherCreateExamScreenState();
}

class _TeacherCreateExamScreenState
    extends State<TeacherCreateExamScreen> {
  final titleController = TextEditingController();
  final subjectController = TextEditingController();

  void createExam() {
    if (titleController.text.isEmpty || subjectController.text.isEmpty) return;

    QuizData.exams.add(
      ExamModel(
        id: DateTime.now().toString(),
        title: titleController.text,
        subject: subjectController.text,
        questions: [],
      ),
    );

    titleController.clear();
    subjectController.clear();
    setState(() {});
  }

  InputDecoration input(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
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
                  "Create Exam",
                  style: theme.textTheme.headlineMedium,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [

                  TextField(
                    controller: titleController,
                    decoration: input(context, "Exam Title"),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: subjectController,
                    decoration: input(context, "Subject"),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: createExam,
                      child: const Text("Create Exam"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: QuizData.exams.length,
              itemBuilder: (context, index) {
                final exam = QuizData.exams[index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      exam.title,
                      style: theme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      exam.subject,
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TeacherAddQuestionScreen(exam: exam),
                        ),
                      ).then((_) => setState(() {}));
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}