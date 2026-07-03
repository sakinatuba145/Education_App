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
  factory QuizModel.fromJson(Map<String,dynamic>json){
    return QuizModel(
        id: json['id'] as String,
        question: json['question'] as String,
        options: List<String>.from(json['options']),
        correctIndex: json['correctIndex'] as int,
        type: json['type'] =='text'? QuestionType.text:QuestionType.mcq);
  }
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
  factory ExamModel.fromJson(Map<String,dynamic>json){
    return ExamModel(
        id: json['id'] as String,
        title: json['title']as String,
        subject: json['subject'] as String,
        questions: (json['questions']as List)
        .map(
                (e) => QuizModel.fromJson(
                    e as Map<String,dynamic>)).toList(),
            isTaken:json['isTaken']?? false);
  }
}