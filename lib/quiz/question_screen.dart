
import 'package:flutter/material.dart';
import 'package:education_app/core/constants.dart';
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

  final options =
  List.generate(4, (_) => TextEditingController());

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
        correctIndex: selectedType == QuestionType.mcq
            ? correctIndex
            : -1,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
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
                  const Text(
                    "Add Questions",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
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
                          Row(
                            children: [
                              ChoiceChip(
                                label: const Text("MCQ"),
                                selected: selectedType ==
                                    QuestionType.mcq,
                                selectedColor: AppColors.primary,
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
                                selected: selectedType ==
                                    QuestionType.text,
                                selectedColor: AppColors.primary,
                                onSelected: (_) {
                                  setState(() {
                                    selectedType =
                                        QuestionType.text;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),
                          TextField(
                            controller: questionController,
                            decoration: input("Question"),
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
                                  decoration:
                                  input("Option ${i + 1}"),
                                ),
                              );
                            }),

                            DropdownButton<int>(
                              value: correctIndex,
                              isExpanded: true,
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

                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: addQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                AppColors.primary,
                                padding:
                                const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                ),
                              ),
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
                                Icons.remove_red_eye,
                                color: AppColors.primary,
                              ),
                              label: const Text(
                                "Preview Quiz",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                                padding:
                                const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.exam.questions.length,
                      itemBuilder: (context, index) {
                        final q =
                        widget.exam.questions[index];

                        return Container(
                          margin:
                          const EdgeInsets.only(bottom: 12),
                          padding:
                          const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.question,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                q.type == QuestionType.mcq
                                    ? "MCQ Question"
                                    : "Text Question",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}