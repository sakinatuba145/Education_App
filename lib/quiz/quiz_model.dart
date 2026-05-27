enum QuestionType {
  mcq,
  text,
}

class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final QuestionType type;

  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.type = QuestionType.mcq,
  });
}

class ExamModel {
  final String id;
  final String title;
  final String subject;
  final List<QuizModel> questions;

  bool isTaken;

  ExamModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
    this.isTaken = false,
  });
}