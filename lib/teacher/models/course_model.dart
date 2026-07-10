/// Course Model
/// 
/// The core data structure for educational courses in the system.
/// Contains metadata, pricing, status, and aggregated statistics.

import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a complete course entity.
class CourseModel {
  /// Unique identifier for the course.
  final String id;
  /// ID of the teacher who created the course.
  final String teacherId;
  /// Name of the primary instructor.
  final String instructorName;
  /// Main title of the course.
  final String title;
  /// Brief catchy subtitle.
  final String subtitle;
  /// Comprehensive course description.
  final String description;
  /// Course category (e.g. subject area).
  final String category;
  /// List of searchable tags.
  final List<String> tags;
  /// URL to the main course cover image.
  final String? thumbnailUrl;
  /// Difficulty level (e.g., 'beginner', 'intermediate', 'advanced').
  final String level;
  /// Primary language of instruction.
  final String language;
  /// List of requirements before taking this course.
  final List<String> prerequisites;
  /// Aggregated count of student enrollments.
  final int totalEnrolled;
  /// Aggregated count of students who finished the course.
  final int totalCompleted;
  /// Total number of lessons in this course.
  final int totalLessons;
  /// Estimated time required to finish (in hours).
  final double totalDurationHours;
  /// Average student rating (calculated from reviews).
  final double averageRating;
  /// Total number of ratings received.
  final int totalReviews;
  /// Whether the course is accessible without payment.
  final bool isFree;
  /// Price of the course (if not free).
  final double? price;
  /// Total financial earnings from this course.
  final double totalRevenue;
  /// Current lifecycle stage: 'draft', 'published', or 'archived'.
  final String status; // 'draft', 'published', 'archived'
  /// Access control: 'public', 'private', or 'invitation-only'.
  final String visibility; // 'public', 'private', 'invitation-only'
  /// URL-friendly version of the title.
  final String slug;
  /// SEO keywords for search discovery.
  final String keywords;
  /// Timestamp of creation.
  final DateTime createdAt;
  /// Timestamp of last modification.
  final DateTime updatedAt;
  /// Timestamp when the course was first made public.
  final DateTime? publishedAt;

  CourseModel({
    required this.id,
    required this.teacherId,
    this.instructorName = '',
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.tags,
    this.thumbnailUrl,
    required this.level,
    required this.language,
    required this.prerequisites,
    required this.totalEnrolled,
    required this.totalCompleted,
    required this.totalLessons,
    required this.totalDurationHours,
    required this.averageRating,
    required this.totalReviews,
    required this.isFree,
    this.price,
    required this.totalRevenue,
    required this.status,
    required this.visibility,
    required this.slug,
    required this.keywords,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  /// Handles conversion from various date formats used in Firestore/JSON.
  /// 
  /// Supports [DateTime], Firestore [Timestamp], and ISO-8601 strings.
  /// Returns [fallback] or current time if parsing fails.
  static DateTime _parseDate(dynamic value, {DateTime? fallback}) {
    if (value == null) return fallback ?? DateTime.now();
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return fallback ?? DateTime.now();
    }
  }

  /// Same as [_parseDate] but returns null instead of a fallback.
  static DateTime? _parseDateNullable(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  /// Creates a [CourseModel] from a Map (JSON/Firestore).
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? '',
      teacherId: json['teacherId'] ?? '',
      instructorName: json['instructorName'] as String? ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      thumbnailUrl: json['thumbnailUrl'],
      level: json['level'] ?? 'beginner',
      language: json['language'] ?? 'English',
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      totalEnrolled: (json['totalEnrolled'] ?? 0) as int,
      totalCompleted: (json['totalCompleted'] ?? 0) as int,
      totalLessons: (json['totalLessons'] ?? 0) as int,
      totalDurationHours: ((json['totalDurationHours'] ?? 0) as num).toDouble(),
      averageRating: ((json['averageRating'] ?? 0) as num).toDouble(),
      totalReviews: (json['totalReviews'] ?? json['totalRatings'] ?? 0) as int,
      isFree: json['isFree'] ?? true,
      price: (json['price'] as num?)?.toDouble(),
      totalRevenue: ((json['totalRevenue'] ?? 0) as num).toDouble(),
      status: json['status'] ?? 'draft',
      visibility: json['visibility'] ?? 'public',
      slug: json['slug'] ?? '',
      keywords: json['keywords'] ?? '',
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      publishedAt: _parseDateNullable(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'teacherId': teacherId,
    'instructorName': instructorName,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'category': category,
    'tags': tags,
    'thumbnailUrl': thumbnailUrl,
    'level': level,
    'language': language,
    'prerequisites': prerequisites,
    'totalEnrolled': totalEnrolled,
    'totalCompleted': totalCompleted,
    'totalLessons': totalLessons,
    'totalDurationHours': totalDurationHours,
    'averageRating': averageRating,
    'totalReviews': totalReviews,
    'isFree': isFree,
    'price': price,
    'totalRevenue': totalRevenue,
    'status': status,
    'visibility': visibility,
    'slug': slug,
    'keywords': keywords,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'publishedAt': publishedAt?.toIso8601String(),
  };

  bool get isPublished => status == 'published';
  bool get isDraft => status == 'draft';
  bool get isArchived => status == 'archived';
  int get completionPercentage => totalEnrolled > 0
      ? (totalCompleted * 100 ~/ totalEnrolled)
      : 0;
}
