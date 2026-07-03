import 'package:flutter/material.dart';

/// 3.5 QUESTION TYPE
/// Defines if question is MCQ or text answer
enum QuestionType {
  mcq,
  text,
}

/// 3.6 QUIZ MODEL
/// Represents a single question in the exam
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

  /// 3.7 FROM JSON
  /// Converts Firebase data → Dart object
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? -1,
      type: json['type'] == 'text'
          ? QuestionType.text
          : QuestionType.mcq,
    );
  }

  /// 3.8 TO JSON (IMPORTANT FIX)
  /// Converts Dart object → Firebase format
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "options": options,
      "correctIndex": correctIndex,
      "type": type == QuestionType.text ? "text" : "mcq",
    };
  }
}

/// 2.1 EXAM MODEL
/// Represents a full exam (title + subject + questions)
class ExamModel {
  final String id;
  final String title;
  final String subject;
  final List<QuizModel> questions;
  final bool isTaken;

  ExamModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
    this.isTaken = false,
  });

  /// 2.2 FROM JSON
  /// Loads exam from Firestore
  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      questions: (json['questions'] as List? ?? [])
          .map((e) => QuizModel.fromJson(e))
          .toList(),
      isTaken: json['isTaken'] ?? false,
    );
  }

  /// 2.3 TO JSON
  /// Saves exam to Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "subject": subject,

      /// convert all questions to JSON
      "questions": questions.map((e) => e.toJson()).toList(),

      "isTaken": isTaken,
    };
  }
}