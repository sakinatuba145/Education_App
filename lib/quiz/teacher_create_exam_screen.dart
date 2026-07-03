import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'quiz_model.dart';
import 'question_screen.dart';
import 'package:education_app/core/constants/theme.dart';

class TeacherCreateExamScreen extends StatefulWidget {
  static const id = "teacher_create_exam_screen";

  const TeacherCreateExamScreen({super.key});

  @override
  State<TeacherCreateExamScreen> createState() =>
      _TeacherCreateExamScreenState();
}

class _TeacherCreateExamScreenState extends State<TeacherCreateExamScreen> {

  /// 3.17 EXAM INPUT CONTROLLERS
  /// controls exam title + subject input
  final titleController = TextEditingController();
  final subjectController = TextEditingController();

  /// 3.18 CREATE EXAM
  /// saves empty exam in Firestore
  Future<void> createExam() async {
    if (titleController.text.isEmpty || subjectController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection("quizzes").add({
      "title": titleController.text.trim(),
      "subject": subjectController.text.trim(),

      /// EMPTY QUESTIONS ARRAY (will be filled later)
      "questions": [],

      /// timestamp for sorting exams
      "createdAt": FieldValue.serverTimestamp(),
    });

    /// clear inputs after saving
    titleController.clear();
    subjectController.clear();
  }

  /// 3.19 INPUT DECORATION HELPER
  InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
    );
  }

  /// 3.20 LOAD EXAMS STREAM
  /// listens to Firestore real-time updates
  Stream<QuerySnapshot> getExamsStream() {
    return FirebaseFirestore.instance
        .collection("quizzes")
        .orderBy("createdAt", descending: true)
        .snapshots();
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
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              /// MAIN CONTENT
              Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [

                          const SizedBox(height: 20),

                          /// TITLE
                          FadeInDown(
                            child: Text(
                              "Create Exam",
                              style: theme.textTheme.headlineLarge,
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// CREATE EXAM FORM
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Column(
                              children: [

                                /// EXAM TITLE INPUT
                                TextField(
                                  controller: titleController,
                                  decoration: input("Exam Title"),
                                ),

                                const SizedBox(height: 14),

                                /// SUBJECT INPUT
                                TextField(
                                  controller: subjectController,
                                  decoration: input("Subject"),
                                ),

                                const SizedBox(height: 20),

                                /// CREATE BUTTON
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeColors.button,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    onPressed: createExam,
                                    child: const Text(
                                      "Create Exam",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// EXAMS LIST (REALTIME FIREBASE STREAM)
                          StreamBuilder<QuerySnapshot>(
                            stream: getExamsStream(),
                            builder: (context, snapshot) {

                              /// loading state
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              /// empty state
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Text("No exams found");
                              }

                              final exams = snapshot.data!.docs;

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: exams.length,
                                itemBuilder: (context, index) {

                                  final doc = exams[index];
                                  final data =
                                  doc.data() as Map<String, dynamic>;

                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(18),
                                    ),

                                    /// EXAM ITEM
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,

                                      /// TITLE
                                      title: Text(data["title"] ?? ""),

                                      /// SUBJECT
                                      subtitle: Text(data["subject"] ?? ""),

                                      /// OPEN ADD QUESTION SCREEN
                                      trailing: const Icon(Icons.arrow_forward_ios),

                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                TeacherAddQuestionScreen(
                                                  exam: ExamModel(
                                                    id: doc.id,
                                                    title: data["title"],
                                                    subject: data["subject"],
                                                    questions: [],
                                                  ),
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}