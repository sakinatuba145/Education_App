import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/course_enrollment_model.dart';

class TeacherEnrollmentService {
  static final TeacherEnrollmentService _instance =
      TeacherEnrollmentService._internal();

  factory TeacherEnrollmentService() {
    return _instance;
  }

  TeacherEnrollmentService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // GET - Get course enrollments
  Future<List<CourseEnrollmentModel>> getCourseEnrollments(
      String courseId) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(ENROLLMENTS_SUBCOLLECTION)
          .orderBy('enrolledAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CourseEnrollmentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get enrollments: ${e.toString()}');
    }
  }

  // SEARCH - Search enrollments
  Future<List<CourseEnrollmentModel>> searchEnrollments({
    required String courseId,
    required String query,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(ENROLLMENTS_SUBCOLLECTION)
          .get();

      final searchQuery = query.toLowerCase();

      return snapshot.docs
          .map((doc) => CourseEnrollmentModel.fromJson(doc.data()))
          .where((enrollment) =>
              enrollment.studentName.toLowerCase().contains(searchQuery) ||
              enrollment.studentEmail.toLowerCase().contains(searchQuery))
          .toList();
    } catch (e) {
      throw Exception('Failed to search: ${e.toString()}');
    }
  }

  // FILTER - Filter by status
  Future<List<CourseEnrollmentModel>> getEnrollmentsByStatus({
    required String courseId,
    required String status, // 'completed', 'in-progress', 'not-started'
  }) async {
    try {
      const completionThreshold = COMPLETION_THRESHOLD;

      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(ENROLLMENTS_SUBCOLLECTION)
          .get();

      return snapshot.docs
          .map((doc) => CourseEnrollmentModel.fromJson(doc.data()))
          .where((enrollment) {
            if (status == 'completed') {
              return enrollment.progressPercentage >= completionThreshold;
            } else if (status == 'in-progress') {
              return enrollment.progressPercentage > 0 &&
                  enrollment.progressPercentage < completionThreshold;
            } else {
              return enrollment.progressPercentage == 0;
            }
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to filter: ${e.toString()}');
    }
  }

  // SORT - Sort enrollments
  Future<List<CourseEnrollmentModel>> sortEnrollments({
    required String courseId,
    required String sortBy, // 'name', 'date-joined', 'progress', 'rating'
  }) async {
    try {
      final enrollments = await getCourseEnrollments(courseId);

      switch (sortBy) {
        case 'name':
          enrollments.sort((a, b) => a.studentName.compareTo(b.studentName));
          break;
        case 'progress':
          enrollments.sort(
              (a, b) => b.progressPercentage.compareTo(a.progressPercentage));
          break;
        case 'rating':
          enrollments
              .sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'date-joined':
        default:
          enrollments.sort((a, b) => b.enrolledAt.compareTo(a.enrolledAt));
          break;
      }

      return enrollments;
    } catch (e) {
      throw Exception('Failed to sort: ${e.toString()}');
    }
  }

  // GET - Get student progress
  Future<Map<String, dynamic>> getStudentProgress({
    required String courseId,
    required String studentUid,
  }) async {
    try {
      final enrollmentSnapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(ENROLLMENTS_SUBCOLLECTION)
          .where('studentId', isEqualTo: studentUid)
          .limit(1)
          .get();

      if (enrollmentSnapshot.docs.isEmpty) {
        throw Exception('Student not enrolled');
      }

      final enrollmentData = enrollmentSnapshot.docs.first.data();

      return {
        'studentName': enrollmentData['studentName'],
        'studentEmail': enrollmentData['studentEmail'],
        'enrollmentDate': enrollmentData['enrolledAt'],
        'completionDate': enrollmentData['completedAt'],
        'progressPercentage': enrollmentData['progressPercentage'],
        'lessonsCompleted': enrollmentData['lessonsCompleted'],
        'certificateEarned': enrollmentData['certificateEarned'],
        'rating': enrollmentData['rating'],
      };
    } catch (e) {
      throw Exception('Failed to get progress: ${e.toString()}');
    }
  }

  // REMOVE - Remove student
  Future<void> removeStudentFromCourse({
    required String courseId,
    required String studentUid,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(ENROLLMENTS_SUBCOLLECTION)
          .where('studentId', isEqualTo: studentUid)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to remove student: ${e.toString()}');
    }
  }

  // GET - Get student lesson progress
  Future<List<Map<String, dynamic>>> getStudentLessonProgress({
    required String courseId,
    required String studentUid,
  }) async {
    try {
      // This would be implemented with a separate progress collection
      // For now, return empty list
      return [];
    } catch (e) {
      throw Exception('Failed to get lesson progress: ${e.toString()}');
    }
  }

  // Count by status
  Future<Map<String, int>> getEnrollmentCounts(String courseId) async {
    try {
      final enrollments = await getCourseEnrollments(courseId);

      int completed = 0;
      int inProgress = 0;
      int notStarted = 0;

      for (var enrollment in enrollments) {
        if (enrollment.isCompleted) {
          completed++;
        } else if (enrollment.progressPercentage > 0) {
          inProgress++;
        } else {
          notStarted++;
        }
      }

      return {
        'completed': completed,
        'inProgress': inProgress,
        'notStarted': notStarted,
        'total': enrollments.length,
      };
    } catch (e) {
      return {'completed': 0, 'inProgress': 0, 'notStarted': 0, 'total': 0};
    }
  }
}
