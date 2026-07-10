/// Lesson Quiz Model
/// 
/// Defines the structure for quizzes attached to lessons. Includes
/// configuration for scoring, time limits, and performance metrics.

/// Represents a quiz associated with a lesson.
class LessonQuizModel {
  /// Unique identifier for the quiz.
  final String id;
  /// ID of the parent course.
  final String courseId;
  /// ID of the parent lesson.
  final String lessonId;
  /// Title of the quiz.
  final String title;
  /// Brief description of the quiz content.
  final String description;
  /// Specific instructions for students (e.g., 'Choose the best answer').
  final String instruction;
  /// Optional time limit in minutes.
  final int? durationMinutes;
  /// Percentage required to pass (0-100).
  final int passingScore;
  /// If true, questions are presented in a random order.
  final bool shuffleQuestions;
  /// When to reveal correct answers: 'immediately', 'after_completion', or 'never'.
  final String showAnswersOption; // 'immediately', 'after_completion', 'never'
  /// List of quiz questions and their respective options/answers.
  final List<Map<String, dynamic>> questions;
  /// Total number of times this quiz has been taken.
  final int totalAttempts;
  /// Average score across all attempts.
  final double averageScore;
  /// Percentage of students who passed the quiz.
  final double passRate;
  /// Average time spent on the quiz in seconds.
  final int averageTimeSeconds;
  /// Timestamp of creation.
  final DateTime createdAt;
  /// Timestamp of last modification.
  final DateTime updatedAt;

  LessonQuizModel({
    required this.id,
    required this.courseId,
    required this.lessonId,
    required this.title,
    required this.description,
    required this.instruction,
    this.durationMinutes,
    required this.passingScore,
    required this.shuffleQuestions,
    required this.showAnswersOption,
    required this.questions,
    required this.totalAttempts,
    required this.averageScore,
    required this.passRate,
    required this.averageTimeSeconds,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Constructs a [LessonQuizModel] from a Map.
  factory LessonQuizModel.fromJson(Map<String, dynamic> json) {
    return LessonQuizModel(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      lessonId: json['lessonId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instruction: json['instruction'] ?? '',
      durationMinutes: json['durationMinutes'],
      passingScore: json['passingScore'] ?? 70,
      shuffleQuestions: json['shuffleQuestions'] ?? false,
      showAnswersOption: json['showAnswersOption'] ?? 'immediately',
      questions: List<Map<String, dynamic>>.from(json['questions'] ?? []),
      totalAttempts: json['totalAttempts'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
      passRate: (json['passRate'] ?? 0).toDouble(),
      averageTimeSeconds: json['averageTimeSeconds'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'lessonId': lessonId,
    'title': title,
    'description': description,
    'instruction': instruction,
    'durationMinutes': durationMinutes,
    'passingScore': passingScore,
    'shuffleQuestions': shuffleQuestions,
    'showAnswersOption': showAnswersOption,
    'questions': questions,
    'totalAttempts': totalAttempts,
    'averageScore': averageScore,
    'passRate': passRate,
    'averageTimeSeconds': averageTimeSeconds,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  int get questionCount => questions.length;
  bool get isTimedQuiz => durationMinutes != null && durationMinutes! > 0;
}
