class CourseEnrollmentModel {
  final String id;
  final String courseId;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String status; // 'active', 'completed', 'dropped'
  final double progressPercentage;
  final int lessonsCompleted;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final DateTime? lastAccessedAt;
  final bool certificateEarned;
  final String? certificateId;
  final DateTime? certificateIssuedAt;
  final double? rating;
  final String? review;
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
