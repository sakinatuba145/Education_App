/// Course Analytics Model
/// 
/// This file defines the data structure for course-level analytics, including
/// enrollment counts, completion rates, and financial metrics.

/// Represents comprehensive analytics for a specific course.
class CourseAnalyticsModel {
  /// Unique identifier for the course.
  final String courseId;
  /// Total number of students who have ever enrolled.
  final int totalEnrolled;
  /// Number of students currently active in the course.
  final int activeStudents;
  /// Number of students who have completed the course.
  final int completedStudents;
  /// Percentage of enrolled students who completed the course.
  final double completionRate;
  /// Sales conversion rate (if applicable).
  final double conversionRate;
  /// Average time students spend on a single lesson.
  final double avgTimePerLessonMinutes;
  /// Average total time spent in the course.
  final double avgTimePerCourseMinutes;
  /// Count of discussion forum posts/threads.
  final int forumDiscussions;
  /// Average star rating from student reviews.
  final double averageRating;
  /// Total number of reviews received.
  final int totalReviews;
  /// Distribution of ratings (e.g., 5-star count, 4-star count).
  final Map<int, int> ratingDistribution;
  /// Total earnings from the course.
  final double totalRevenue;
  /// Average selling price per enrollment.
  final double averagePrice;
  /// Total number of refunds processed.
  final int totalRefunds;
  /// Time-series data for enrollments.
  final List<DailyMetric> dailyEnrollment;
  /// Time-series data for revenue.
  final List<DailyMetric> dailyRevenue;

  CourseAnalyticsModel({
    required this.courseId,
    required this.totalEnrolled,
    required this.activeStudents,
    required this.completedStudents,
    required this.completionRate,
    required this.conversionRate,
    required this.avgTimePerLessonMinutes,
    required this.avgTimePerCourseMinutes,
    required this.forumDiscussions,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.totalRevenue,
    required this.averagePrice,
    required this.totalRefunds,
    required this.dailyEnrollment,
    required this.dailyRevenue,
  });

  factory CourseAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return CourseAnalyticsModel(
      courseId: json['courseId'] ?? '',
      totalEnrolled: json['totalEnrolled'] ?? 0,
      activeStudents: json['activeStudents'] ?? 0,
      completedStudents: json['completedStudents'] ?? 0,
      completionRate: (json['completionRate'] ?? 0).toDouble(),
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      avgTimePerLessonMinutes: (json['avgTimePerLessonMinutes'] ?? 0).toDouble(),
      avgTimePerCourseMinutes: (json['avgTimePerCourseMinutes'] ?? 0).toDouble(),
      forumDiscussions: json['forumDiscussions'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      ratingDistribution: Map<int, int>.from(
        (json['ratingDistribution'] as Map?)?.map(
              (k, v) => MapEntry(int.parse(k.toString()), v),
            ) ??
            {},
      ),
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      averagePrice: (json['averagePrice'] ?? 0).toDouble(),
      totalRefunds: json['totalRefunds'] ?? 0,
      dailyEnrollment: (json['dailyEnrollment'] as List?)
              ?.map((e) => DailyMetric.fromJson(e))
              .toList() ??
          [],
      dailyRevenue: (json['dailyRevenue'] as List?)
              ?.map((e) => DailyMetric.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'courseId': courseId,
    'totalEnrolled': totalEnrolled,
    'activeStudents': activeStudents,
    'completedStudents': completedStudents,
    'completionRate': completionRate,
    'conversionRate': conversionRate,
    'avgTimePerLessonMinutes': avgTimePerLessonMinutes,
    'avgTimePerCourseMinutes': avgTimePerCourseMinutes,
    'forumDiscussions': forumDiscussions,
    'averageRating': averageRating,
    'totalReviews': totalReviews,
    'ratingDistribution': ratingDistribution,
    'totalRevenue': totalRevenue,
    'averagePrice': averagePrice,
    'totalRefunds': totalRefunds,
    'dailyEnrollment': dailyEnrollment.map((e) => e.toJson()).toList(),
    'dailyRevenue': dailyRevenue.map((e) => e.toJson()).toList(),
  };
}

class DailyMetric {
  final DateTime date;
  final double value;

  DailyMetric({
    required this.date,
    required this.value,
  });

  factory DailyMetric.fromJson(Map<String, dynamic> json) {
    return DailyMetric(
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : DateTime.now(),
      value: (json['value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'value': value,
  };
}
