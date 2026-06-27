import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';

import 'quiz_model.dart';
import 'quiz_data.dart';

class TeacherCreateExamScreen extends StatefulWidget {
  const TeacherCreateExamScreen({super.key});

  @override
  State<TeacherCreateExamScreen> createState() =>
      _TeacherCreateExamScreenState();
}

class _TeacherCreateExamScreenState extends State<TeacherCreateExamScreen> {
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // ✅ USE THEME BACKGROUND ONLY
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Create Exam"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // CARD uses theme.cardTheme automatically
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: "Exam Title",
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      hintText: "Subject",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ THEMED BUTTON (from AppTheme elevatedButtonTheme)
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

          // LIST
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: QuizData.exams.length,
            itemBuilder: (context, index) {
              final exam = QuizData.exams[index];

              return Card(
                child: ListTile(
                  title: Text(
                    exam.title,
                    style: theme.textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    exam.subject,
                    style: theme.textTheme.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.iconTheme.color,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}