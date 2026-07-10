/// Lesson Model
/// 
/// Defines a single educational unit within a course. Lessons act as
/// containers for multiple content items and an optional quiz.

import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a lesson within a course.
class LessonModel {
  /// Unique identifier for the lesson.
  final String id;
  /// ID of the course this lesson belongs to.
  final String courseId;
  /// Title of the lesson.
  final String title;
  /// Detailed description of lesson objectives.
  final String description;
  /// Order of the lesson in the course sequence.
  final int sequenceNumber;
  /// List of IDs for content (video, PDF, etc.) belonging to this lesson.
  final List<String> contentIds;
  /// ID of the quiz associated with this lesson, if any.
  final String? attachedQuizId;
  /// Total number of times this lesson has been viewed.
  final int totalViews;
  /// Total number of students who completed this lesson.
  final int totalCompleted;
  /// Average student rating for this specific lesson.
  final double averageRating;
  /// Total estimated duration for consuming all content in the lesson.
  final Duration totalDuration;
  /// Timestamp of creation.
  final DateTime createdAt;
  /// Timestamp of last modification.
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

  /// Safely parses date fields from Firestore/JSON formats.
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  /// Constructs a [LessonModel] from a Map.
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
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
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
  double get completionRate =>
      totalViews > 0 ? (totalCompleted / totalViews * 100) : 0;
}
