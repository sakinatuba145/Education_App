import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/constants/theme.dart';
import 'quiz_model.dart';
import 'quiz_data.dart';
import 'question_model.dart';

/// 3.1 CREATE EXAM SCREEN
/// Allows teachers to create a new exam and manage existing exams.
class TeacherCreateExamScreen extends StatefulWidget {
  static const String id = 'create_exam_screen';

  const TeacherCreateExamScreen({super.key});

  @override
  State<TeacherCreateExamScreen> createState() =>
      _TeacherCreateExamScreenState();
}

class _TeacherCreateExamScreenState extends State<TeacherCreateExamScreen> {

  /// 3.2 INPUT CONTROLLERS
  /// Store the exam title and subject entered by the teacher.
  final titleController = TextEditingController();
  final subjectController = TextEditingController();
  /// 3.3 CREATE EXAM
  /// Saves a new exam to Firestore with an empty question list.
  void createExam() async {
    if (titleController.text.isEmpty || subjectController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('quizzes').add({
      "title": titleController.text,
      "subject": subjectController.text,
      "questions": [],
      "createdAt": Timestamp.now(),
    });

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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [

                            const SizedBox(height: 20),

                            Text(
                              "Create Exam",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Add exam title and subject",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),

                            const SizedBox(height: 30),

                            /// INPUT CARD
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

                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: createExam,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeColors.button,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text("Create Exam"),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),
                            /// 3.25 EXAMS LIST
                            /// Displays all created exams from Firestore in real time.
                            StreamBuilder(
                              stream: QuizData.getExams(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final exams = snapshot.data!.docs;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: exams.length,
                                  itemBuilder: (context, index) {
                                    final exam = exams[index];

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [

                                          Expanded(
                                            child: ListTile(
                                              title: Text(exam['title']),
                                              subtitle: Text(exam['subject']),
                                              /// Open the selected exam to add questions.
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        TeacherAddQuestionScreen(
                                                          examId: exam.id,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          /// Deletes the selected exam from Firestore.
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('quizzes')
                                                  .doc(exam.id)
                                                  .delete();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            )
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