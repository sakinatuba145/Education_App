import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/course_model.dart';

class TeacherCourseService {
  static final TeacherCourseService _instance = TeacherCourseService._internal();

  factory TeacherCourseService() {
    return _instance;
  }

  TeacherCourseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE - Create new course
  Future<String> createCourse({required CourseModel course}) async {
    try {
      final docRef = await _firestore
          .collection(COURSES_COLLECTION)
          .add(course.toJson());

      // Update document with ID
      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create course: ${e.toString()}');
    }
  }

  // READ - Get course by ID
  Future<CourseModel> getCourseById(String courseId) async {
    try {
      final doc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .get();

      if (!doc.exists) {
        throw Exception('Course not found');
      }

      return CourseModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get course: ${e.toString()}');
    }
  }

  // READ - Get teacher's courses
  Future<List<CourseModel>> getMyCourses({
    required String teacherId,
    String status = 'all', // 'active', 'draft', 'archived', 'all'
    String sortBy = 'updated', // 'created', 'updated', 'popular', 'earnings'
  }) async {
    try {
      // Use only a single-field filter — no orderBy — to avoid requiring composite indexes.
      // Sorting is done client-side.
      Query query = _firestore
          .collection(COURSES_COLLECTION)
          .where('teacherId', isEqualTo: teacherId);

      if (status != 'all') {
        query = query.where('status', isEqualTo: status);
      }

      final snapshot = await query.get();

      final courses = snapshot.docs
          .map((doc) => CourseModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Sort client-side
      courses.sort((a, b) {
        if (sortBy == 'created') return b.createdAt.compareTo(a.createdAt);
        if (sortBy == 'popular') return b.totalEnrolled.compareTo(a.totalEnrolled);
        if (sortBy == 'earnings') return b.totalRevenue.compareTo(a.totalRevenue);
        return b.updatedAt.compareTo(a.updatedAt); // default: updated
      });

      return courses;
    } catch (e) {
      throw Exception('Failed to get courses: ${e.toString()}');
    }
  }

  // UPDATE - Update course
  Future<void> updateCourse({
    required String courseId,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update course: ${e.toString()}');
    }
  }

  // DELETE - Archive course
  Future<void> archiveCourse(String courseId) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .update({
        'status': 'archived',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to archive course: ${e.toString()}');
    }
  }

  // DELETE - Hard delete course (with all subcollections)
  Future<void> deleteCourse(String courseId) async {
    try {
      final courseRef = _firestore.collection(COURSES_COLLECTION).doc(courseId);

      // Delete lessons and content
      final lessonsSnapshot = await courseRef
          .collection(LESSONS_SUBCOLLECTION)
          .get();

      for (var lessonDoc in lessonsSnapshot.docs) {
        // Delete content in lesson
        final contentSnapshot = await lessonDoc.reference
            .collection(CONTENT_SUBCOLLECTION)
            .get();

        for (var contentDoc in contentSnapshot.docs) {
          await contentDoc.reference.delete();
        }

        await lessonDoc.reference.delete();
      }

      // Delete enrollments
      final enrollmentsSnapshot =
          await courseRef.collection(ENROLLMENTS_SUBCOLLECTION).get();

      for (var enrollmentDoc in enrollmentsSnapshot.docs) {
        await enrollmentDoc.reference.delete();
      }

      // Delete course
      await courseRef.delete();
    } catch (e) {
      throw Exception('Failed to delete course: ${e.toString()}');
    }
  }

  // PUBLISH - Publish course
  Future<void> publishCourse(String courseId) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .update({
        'status': 'published',
        'visibility': 'public',
        'publishedAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to publish course: ${e.toString()}');
    }
  }

  // DRAFT - Save as draft
  Future<void> saveDraft(String courseId) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .update({
        'status': 'draft',
        'visibility': 'private',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to save draft: ${e.toString()}');
    }
  }

  // VISIBILITY - Set course visibility
  Future<void> setCourseVisibility({
    required String courseId,
    required String visibility, // 'public', 'private', 'invitation-only'
  }) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .update({
        'visibility': visibility,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to set visibility: ${e.toString()}');
    }
  }

  // STATS - Get course statistics
  Future<Map<String, dynamic>> getCourseStats(String courseId) async {
    try {
      final courseDoc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .get();

      if (!courseDoc.exists) {
        throw Exception('Course not found');
      }

      final data = courseDoc.data()!;

      return {
        'studentCount': data['totalEnrolled'] ?? 0,
        'completionCount': data['totalCompleted'] ?? 0,
        'completionRate': ((data['totalCompleted'] ?? 0) /
            (data['totalEnrolled'] ?? 1) * 100).toStringAsFixed(1),
        'avgRating': data['averageRating'] ?? 0,
        'totalReviews': data['totalReviews'] ?? 0,
        'totalRevenue': data['totalRevenue'] ?? 0,
        'totalLessons': data['totalLessons'] ?? 0,
        'totalDurationHours': data['totalDurationHours'] ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to get stats: ${e.toString()}');
    }
  }

  // Get enrolled students
  Future<List<Map<String, dynamic>>> getCourseEnrolledStudents(
      String courseId) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(ENROLLMENTS_SUBCOLLECTION)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to get students: ${e.toString()}');
    }
  }

  // Search courses by teacher
  Future<List<CourseModel>> searchCourses({
    required String teacherId,
    required String query,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .where('teacherId', isEqualTo: teacherId)
          .where('status', isEqualTo: 'published')
          .get();

      // Client-side filtering for title search
      final searchQuery = query.toLowerCase();

      return snapshot.docs
          .map((doc) => CourseModel.fromJson(doc.data()))
          .where((course) =>
              course.title.toLowerCase().contains(searchQuery) ||
              course.description.toLowerCase().contains(searchQuery))
          .toList();
    } catch (e) {
      throw Exception('Failed to search: ${e.toString()}');
    }
  }

  // Get public courses — no composite index needed; filter + sort client-side
  Future<List<CourseModel>> getPublicCourses({int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .where('status', isEqualTo: 'published')
          .get();

      final courses = <CourseModel>[];
      for (final doc in snapshot.docs) {
        try {
          final course = CourseModel.fromJson(doc.data());
          // Accept public courses OR courses where visibility was never explicitly set private
          if (course.visibility != 'private') {
            courses.add(course);
          }
        } catch (_) {
          // Skip malformed documents silently
        }
      }

      courses.sort((a, b) => b.totalEnrolled.compareTo(a.totalEnrolled));
      return courses.take(limit).toList();
    } catch (e) {
      // Fallback: try fetching all courses if status filter fails
      try {
        final fallback = await _firestore
            .collection(COURSES_COLLECTION)
            .limit(limit)
            .get();
        final results = <CourseModel>[];
        for (final doc in fallback.docs) {
          try {
            final c = CourseModel.fromJson(doc.data());
            if (c.status == 'published' && c.visibility != 'private') {
              results.add(c);
            }
          } catch (_) {}
        }
        return results;
      } catch (_) {
        return [];
      }
    }
  }

  // Increment student count
  Future<void> incrementStudentCount(String courseId) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .update({
        'totalEnrolled': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to increment: ${e.toString()}');
    }
  }

  // Update course rating
  Future<void> updateCourseRating({
    required String courseId,
    required double rating,
  }) async {
    try {
      final courseRef =
          _firestore.collection(COURSES_COLLECTION).doc(courseId);
      final courseData = await courseRef.get();

      if (!courseData.exists) return;

      final currentData = courseData.data()!;
      final totalReviews = (currentData['totalReviews'] ?? 0) + 1;
      final currentRating = (currentData['averageRating'] ?? 0).toDouble();

      // Calculate new average rating
      final newRating = (currentRating * (totalReviews - 1) + rating) / totalReviews;

      await courseRef.update({
        'averageRating': newRating,
        'totalReviews': totalReviews,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update rating: ${e.toString()}');
    }
  }
}
