import 'package:flutter/material.dart';
import 'package:education_app/core/constants.dart';
import 'quiz_model.dart';
import 'quiz_data.dart';
import 'question_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
      filled: true,
      fillColor: AppColors.softWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 10),

                      Text(
                        "Create Exam",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Create Exam",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          exam.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          exam.subject,
                          style: GoogleFonts.poppins(),
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