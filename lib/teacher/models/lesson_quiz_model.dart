class LessonQuizModel {
  final String id;
  final String courseId;
  final String lessonId;
  final String title;
  final String description;
  final String instruction;
  final int? durationMinutes;
  final int passingScore;
  final bool shuffleQuestions;
  final String showAnswersOption; // 'immediately', 'after_completion', 'never'
  final List<Map<String, dynamic>> questions;
  final int totalAttempts;
  final double averageScore;
  final double passRate;
  final int averageTimeSeconds;
  final DateTime createdAt;
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
