class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int sequenceNumber;
  final List<String> contentIds;
  final String? attachedQuizId;
  final int totalViews;
  final int totalCompleted;
  final double averageRating;
  final Duration totalDuration;
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.sequenceNumber,
    required this.contentIds,
    this.attachedQuizId,
    required this.totalViews,
    required this.totalCompleted,
    required this.averageRating,
    required this.totalDuration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      sequenceNumber: json['sequenceNumber'] ?? 0,
      contentIds: List<String>.from(json['contentIds'] ?? []),
      attachedQuizId: json['attachedQuizId'],
      totalViews: json['totalViews'] ?? 0,
      totalCompleted: json['totalCompleted'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalDuration: Duration(seconds: json['totalDurationSeconds'] ?? 0),
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
    'title': title,
    'description': description,
    'sequenceNumber': sequenceNumber,
    'contentIds': contentIds,
    'attachedQuizId': attachedQuizId,
    'totalViews': totalViews,
    'totalCompleted': totalCompleted,
    'averageRating': averageRating,
    'totalDurationSeconds': totalDuration.inSeconds,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  bool get hasQuiz => attachedQuizId != null && attachedQuizId!.isNotEmpty;
  double get completionRate => totalViews > 0
      ? (totalCompleted / totalViews * 100)
      : 0;
}
