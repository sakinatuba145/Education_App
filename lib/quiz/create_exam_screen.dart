import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';
import 'quiz_model.dart';
import 'quiz_data.dart';
import 'question_model.dart';

class TeacherCreateExamScreen extends StatefulWidget {
  static const String id = 'create_exam_screen';

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

    titleController.clear();
    subjectController.clear();

    setState(() {});
  }

  InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.edit),
    );
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

                            /// HEADER (LIKE REGISTER SCREEN)
                            Text(
                              "Create Exam",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Add exam title and subject",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),

                            const SizedBox(height: 30),

                            /// CARD CONTAINER (REGISTER STYLE)
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
                                  TextField(
                                    controller: titleController,
                                    decoration: input("Exam Title"),
                                  ),

                                  const SizedBox(height: 16),

                                  TextField(
                                    controller: subjectController,
                                    decoration: input("Subject"),
                                  ),

                                  const SizedBox(height: 22),

                                  /// BUTTON (THEME CORRECT)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: createExam,
                                      child: const Text("Create Exam"),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),

                            /// LIST OF EXAMS
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: QuizData.exams.length,
                              itemBuilder: (context, index) {
                                final exam = QuizData.exams[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: ListTile(
                                    title: Text(exam.title),
                                    subtitle: Text(exam.subject),
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              TeacherAddQuestionScreen(
                                                  exam: exam),
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