class CourseProgressModel {
  final String enrollmentId;
  final String courseId;
  final String studentId;
  final double overallCompletionPercentage;
  final List<LessonProgressModel> lessonProgress;
  final int totalTimeSpentSeconds;
  final DateTime lastAccessedAt;
  final int sessionCount;
  final double? averageQuizScore;
  final int certificateEligibilityPercentage;
  final int currentStreak;
  final int longestStreak;

  CourseProgressModel({
    required this.enrollmentId,
    required this.courseId,
    required this.studentId,
    required this.overallCompletionPercentage,
    required this.lessonProgress,
    required this.totalTimeSpentSeconds,
    required this.lastAccessedAt,
    required this.sessionCount,
    this.averageQuizScore,
    required this.certificateEligibilityPercentage,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    return CourseProgressModel(
      enrollmentId: json['enrollmentId'] ?? '',
      courseId: json['courseId'] ?? '',
      studentId: json['studentId'] ?? '',
      overallCompletionPercentage:
          (json['overallCompletionPercentage'] ?? 0).toDouble(),
      lessonProgress: (json['lessonProgress'] as List?)
              ?.map((e) => LessonProgressModel.fromJson(e))
              .toList() ??
          [],
      totalTimeSpentSeconds: json['totalTimeSpentSeconds'] ?? 0,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'].toString())
          : DateTime.now(),
      sessionCount: json['sessionCount'] ?? 0,
      averageQuizScore: json['averageQuizScore']?.toDouble(),
      certificateEligibilityPercentage:
          json['certificateEligibilityPercentage'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'enrollmentId': enrollmentId,
    'courseId': courseId,
    'studentId': studentId,
    'overallCompletionPercentage': overallCompletionPercentage,
    'lessonProgress': lessonProgress.map((e) => e.toJson()).toList(),
    'totalTimeSpentSeconds': totalTimeSpentSeconds,
    'lastAccessedAt': lastAccessedAt.toIso8601String(),
    'sessionCount': sessionCount,
    'averageQuizScore': averageQuizScore,
    'certificateEligibilityPercentage': certificateEligibilityPercentage,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
  };

  bool get isCertificateEligible =>
      overallCompletionPercentage >=
      certificateEligibilityPercentage;
}

class LessonProgressModel {
  final String lessonId;
  final bool isCompleted;
  final double completionPercentage;
  final int timeSpentSeconds;
  final DateTime? completedAt;
  final double? quizScore;
  final bool quizPassed;

  LessonProgressModel({
    required this.lessonId,
    required this.isCompleted,
    required this.completionPercentage,
    required this.timeSpentSeconds,
    this.completedAt,
    this.quizScore,
    required this.quizPassed,
  });

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      lessonId: json['lessonId'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
      timeSpentSeconds: json['timeSpentSeconds'] ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'].toString())
          : null,
      quizScore: json['quizScore']?.toDouble(),
      quizPassed: json['quizPassed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'lessonId': lessonId,
    'isCompleted': isCompleted,
    'completionPercentage': completionPercentage,
    'timeSpentSeconds': timeSpentSeconds,
    'completedAt': completedAt?.toIso8601String(),
    'quizScore': quizScore,
    'quizPassed': quizPassed,
  };
}
