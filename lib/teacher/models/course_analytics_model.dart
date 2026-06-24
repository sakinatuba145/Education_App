class CourseAnalyticsModel {
  final String courseId;
  final int totalEnrolled;
  final int activeStudents;
  final int completedStudents;
  final double completionRate;
  final double conversionRate;
  final double avgTimePerLessonMinutes;
  final double avgTimePerCourseMinutes;
  final int forumDiscussions;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;
  final double totalRevenue;
  final double averagePrice;
  final int totalRefunds;
  final List<DailyMetric> dailyEnrollment;
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
