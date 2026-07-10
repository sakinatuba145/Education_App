/// Course Enrollment Model
/// 
/// Tracks the relationship between a student and a course, including
/// progress, completion status, and certification details.

/// Represents a student's enrollment in a specific course.
class CourseEnrollmentModel {
  /// Unique identifier for the enrollment record.
  final String id;
  /// ID of the course the student is enrolled in.
  final String courseId;
  /// ID of the student user.
  final String studentId;
  /// Cached student name for display in the teacher dashboard.
  final String studentName;
  /// Cached student email for contact purposes.
  final String studentEmail;
  /// Enrollment status: 'active', 'completed', or 'dropped'.
  final String status; // 'active', 'completed', 'dropped'
  /// Overall progress through the course (0.0 to 100.0).
  final double progressPercentage;
  /// Number of lessons the student has marked as completed.
  final int lessonsCompleted;
  /// Timestamp when the student first enrolled.
  final DateTime enrolledAt;
  /// Timestamp when the course was finished.
  final DateTime? completedAt;
  /// Timestamp of the student's most recent interaction with the course.
  final DateTime? lastAccessedAt;
  /// Whether the student has met the criteria for a certificate.
  final bool certificateEarned;
  /// ID of the issued certificate document.
  final String? certificateId;
  /// Timestamp when the certificate was generated.
  final DateTime? certificateIssuedAt;
  /// Star rating given by the student (1-5).
  final double? rating;
  /// Text review provided by the student.
  final String? review;
  /// Timestamp when the review was submitted.
  final DateTime? reviewedAt;

  CourseEnrollmentModel({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.status,
    required this.progressPercentage,
    required this.lessonsCompleted,
    required this.enrolledAt,
    this.completedAt,
    this.lastAccessedAt,
    required this.certificateEarned,
    this.certificateId,
    this.certificateIssuedAt,
    this.rating,
    this.review,
    this.reviewedAt,
  });

  factory CourseEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return CourseEnrollmentModel(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      studentEmail: json['studentEmail'] ?? '',
      status: json['status'] ?? 'active',
      progressPercentage: (json['progressPercentage'] ?? 0).toDouble(),
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
      enrolledAt: json['enrolledAt'] != null
          ? DateTime.parse(json['enrolledAt'].toString())
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'].toString())
          : null,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'].toString())
          : null,
      certificateEarned: json['certificateEarned'] ?? false,
      certificateId: json['certificateId'],
      certificateIssuedAt: json['certificateIssuedAt'] != null
          ? DateTime.parse(json['certificateIssuedAt'].toString())
          : null,
      rating: json['rating']?.toDouble(),
      review: json['review'],
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'studentId': studentId,
    'studentName': studentName,
    'studentEmail': studentEmail,
    'status': status,
    'progressPercentage': progressPercentage,
    'lessonsCompleted': lessonsCompleted,
    'enrolledAt': enrolledAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'lastAccessedAt': lastAccessedAt?.toIso8601String(),
    'certificateEarned': certificateEarned,
    'certificateId': certificateId,
    'certificateIssuedAt': certificateIssuedAt?.toIso8601String(),
    'rating': rating,
    'review': review,
    'reviewedAt': reviewedAt?.toIso8601String(),
  };

  bool get isCompleted => status == 'completed';
  bool get isActive => status == 'active';
  bool get isDropped => status == 'dropped';
}
