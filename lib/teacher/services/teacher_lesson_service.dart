import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/lesson_model.dart';

class TeacherLessonService {
  static final TeacherLessonService _instance = TeacherLessonService._internal();

  factory TeacherLessonService() {
    return _instance;
  }

  TeacherLessonService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE - Create lesson
  Future<String> createLesson({
    required String courseId,
    required LessonModel lesson,
  }) async {
    try {
      final docRef = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .add(lesson.toJson());

      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create lesson: ${e.toString()}');
    }
  }

  // READ - Get lesson
  Future<LessonModel> getLesson({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final doc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .get();

      if (!doc.exists) throw Exception('Lesson not found');

      return LessonModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get lesson: ${e.toString()}');
    }
  }

  // READ - Get all lessons
  Future<List<LessonModel>> getCourseLessons(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .orderBy('sequenceNumber')
          .get();

      return snapshot.docs
          .map((doc) => LessonModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get lessons: ${e.toString()}');
    }
  }

  // UPDATE - Update lesson
  Future<void> updateLesson({
    required String courseId,
    required String lessonId,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update lesson: ${e.toString()}');
    }
  }

  // DELETE - Delete lesson
  Future<void> deleteLesson({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final lessonRef = _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId);

      // Delete all content
      final contentSnapshot = await lessonRef
          .collection(CONTENT_SUBCOLLECTION)
          .get();

      for (var doc in contentSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete lesson
      await lessonRef.delete();
    } catch (e) {
      throw Exception('Failed to delete lesson: ${e.toString()}');
    }
  }

  // REORDER - Reorder lessons
  Future<void> reorderLessons({
    required String courseId,
    required List<String> lessonIds,
  }) async {
    try {
      final batch = _firestore.batch();

      for (int i = 0; i < lessonIds.length; i++) {
        batch.update(
          _firestore
              .collection(COURSES_COLLECTION)
              .doc(courseId)
              .collection(LESSONS_SUBCOLLECTION)
              .doc(lessonIds[i]),
          {'sequenceNumber': i},
        );
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to reorder lessons: ${e.toString()}');
    }
  }

  // STATS - Get lesson statistics
  Future<Map<String, dynamic>> getLessonStats({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final doc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .get();

      if (!doc.exists) throw Exception('Lesson not found');

      final data = doc.data()!;

      return {
        'studentCount': data['totalViews'] ?? 0,
        'completionCount': data['totalCompleted'] ?? 0,
        'completionRate': ((data['totalCompleted'] ?? 0) /
            (data['totalViews'] ?? 1) * 100).toStringAsFixed(1),
        'avgRating': data['averageRating'] ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to get stats: ${e.toString()}');
    }
  }

  // Calculate duration
  Future<int> calculateLessonDuration({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final contentSnapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .get();

      int totalSeconds = 0;

      for (var doc in contentSnapshot.docs) {
        final durationSeconds = doc['durationSeconds'];
        if (durationSeconds != null) {
          totalSeconds += durationSeconds as int;
        }
      }

      return totalSeconds;
    } catch (e) {
      return 0;
    }
  }
}
