import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/course_content_model.dart';

class TeacherContentService {
  static final TeacherContentService _instance =
      TeacherContentService._internal();

  factory TeacherContentService() {
    return _instance;
  }

  TeacherContentService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE - Create content
  Future<String> createContent({
    required String courseId,
    required String lessonId,
    required CourseContentModel content,
  }) async {
    try {
      final docRef = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .add(content.toJson());

      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create content: ${e.toString()}');
    }
  }

  // READ - Get content
  Future<CourseContentModel> getContent({
    required String courseId,
    required String lessonId,
    required String contentId,
  }) async {
    try {
      final doc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .doc(contentId)
          .get();

      if (!doc.exists) throw Exception('Content not found');

      return CourseContentModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get content: ${e.toString()}');
    }
  }

  // READ - Get all content in lesson
  Future<List<CourseContentModel>> getLessonContent({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .get();

      return snapshot.docs
          .map((doc) => CourseContentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get lesson content: ${e.toString()}');
    }
  }

  // READ - Get all content in course
  Future<List<CourseContentModel>> getAllCourseContent(String courseId) async {
    try {
      final lessonsSnapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .get();

      List<CourseContentModel> allContent = [];

      for (var lesson in lessonsSnapshot.docs) {
        final contentSnapshot =
            await lesson.reference.collection(CONTENT_SUBCOLLECTION).get();

        for (var content in contentSnapshot.docs) {
          allContent.add(CourseContentModel.fromJson(content.data()));
        }
      }

      return allContent;
    } catch (e) {
      throw Exception('Failed to get course content: ${e.toString()}');
    }
  }

  // UPDATE - Update content
  Future<void> updateContent({
    required String courseId,
    required String lessonId,
    required String contentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['uploadedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .doc(contentId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update content: ${e.toString()}');
    }
  }

  // DELETE - Delete content
  Future<void> deleteContent({
    required String courseId,
    required String lessonId,
    required String contentId,
  }) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .doc(contentId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete content: ${e.toString()}');
    }
  }

  // STATS - Get content stats
  Future<Map<String, dynamic>> getContentStats({
    required String courseId,
    required String lessonId,
    required String contentId,
  }) async {
    try {
      final doc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .doc(contentId)
          .get();

      if (!doc.exists) throw Exception('Content not found');

      final data = doc.data()!;

      return {
        'views': data['totalViews'] ?? 0,
        'downloads': data['totalDownloads'] ?? 0,
        'avgWatchPercentage': data['averageWatchPercentage'] ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to get stats: ${e.toString()}');
    }
  }

  // Filter by type
  Future<List<CourseContentModel>> getContentByType({
    required String courseId,
    required String contentType,
  }) async {
    try {
      final lessonsSnapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .get();

      List<CourseContentModel> filteredContent = [];

      for (var lesson in lessonsSnapshot.docs) {
        final contentSnapshot = await lesson.reference
            .collection(CONTENT_SUBCOLLECTION)
            .where('contentType', isEqualTo: contentType)
            .get();

        for (var content in contentSnapshot.docs) {
          filteredContent.add(CourseContentModel.fromJson(content.data()));
        }
      }

      return filteredContent;
    } catch (e) {
      throw Exception('Failed to get content by type: ${e.toString()}');
    }
  }

  // Get total storage used
  Future<int> getTotalStorageUsed(String courseId) async {
    try {
      final allContent = await getAllCourseContent(courseId);

      int totalBytes = 0;
      for (var content in allContent) {
        totalBytes += content.fileSizeBytes;
      }

      return totalBytes;
    } catch (e) {
      return 0;
    }
  }

  // Increment views
  Future<void> incrementViews({
    required String courseId,
    required String lessonId,
    required String contentId,
  }) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .doc(contentId)
          .update({
        'totalViews': FieldValue.increment(1),
      });
    } catch (e) {
      // Error incrementing views silently
    }
  }

  // Increment downloads
  Future<void> incrementDownloads({
    required String courseId,
    required String lessonId,
    required String contentId,
  }) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection(CONTENT_SUBCOLLECTION)
          .doc(contentId)
          .update({
        'totalDownloads': FieldValue.increment(1),
      });
    } catch (e) {
      // Error incrementing downloads silently
    }
  }
}
