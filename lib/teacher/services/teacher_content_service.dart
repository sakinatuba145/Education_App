/// Service for managing course content (videos, PDFs, etc.) in Firestore.
///
/// This service handles:
/// 1. Content CRUD operations within lessons
/// 2. Batch fetching of content for courses or lessons
/// 3. Usage statistics (views, downloads)
/// 4. Storage accounting and filtering
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/course_content_model.dart';

/// [TeacherContentService] provides an interface for interacting with lesson content.
/// It uses the singleton pattern to ensure efficient resource usage.
class TeacherContentService {
  static final TeacherContentService _instance =
      TeacherContentService._internal();

  factory TeacherContentService() {
    return _instance;
  }

  TeacherContentService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE - Create content
  /// Creates a new content entry in a specific lesson.
  ///
  /// Adds the content to the [CONTENT_SUBCOLLECTION] and updates the document with its Firestore ID.
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
  /// Fetches a specific content item by its ID.
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
  /// Fetches all content associated with a particular lesson.
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
  /// Fetches all content items for an entire course across all lessons.
  ///
  /// Iterates through each lesson to retrieve its nested content.
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
  /// Updates existing content data.
  ///
  /// Automatically updates the `uploadedAt` timestamp.
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
  /// Deletes a content entry from Firestore.
  /// Note: This doesn't automatically delete the associated file in Storage.
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
  /// Retrieves engagement statistics for a specific content item.
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
  /// Retrieves all content of a specific type (e.g., 'video') within a course.
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
  /// Calculates the total storage bytes used by all content in a course.
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
  /// Atomically increments the view count for a content item.
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
  /// Atomically increments the download count for a content item.
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
