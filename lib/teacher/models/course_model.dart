import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String teacherId;
  final String instructorName;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final List<String> tags;
  final String? thumbnailUrl;
  final String level;
  final String language;
  final List<String> prerequisites;
  final int totalEnrolled;
  final int totalCompleted;
  final int totalLessons;
  final double totalDurationHours;
  final double averageRating;
  final int totalReviews;
  final bool isFree;
  final double? price;
  final double totalRevenue;
  final String status; // 'draft', 'published', 'archived'
  final String visibility; // 'public', 'private', 'invitation-only'
  final String slug;
  final String keywords;
  final DateTime createdAt;
  final DateTime updatedAt;
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

  /// Handles Firestore Timestamp, ISO string, or null safely.
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
