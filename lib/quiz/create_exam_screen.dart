import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';
import 'quiz_model.dart';
import 'quiz_data.dart';
import 'question_model.dart';

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
    if (titleController.text.isEmpty ||
        subjectController.text.isEmpty) return;

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

  InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
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
                    "Create Exam",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: input("Exam Title"),
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: subjectController,
                      decoration: input("Subject"),
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
            ),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: QuizData.exams.length,
              itemBuilder: (context, index) {
                final exam = QuizData.exams[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      exam.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      exam.subject,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TeacherAddQuestionScreen(exam: exam),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
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