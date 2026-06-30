import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/teacher/constants/teacher_constants.dart';
import 'package:education_app/teacher/models/lesson_quiz_model.dart';

class TeacherQuizService {
  static final TeacherQuizService _instance = TeacherQuizService._internal();

  factory TeacherQuizService() {
    return _instance;
  }

  TeacherQuizService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE - Create quiz
  Future<String> createQuiz({
    required String courseId,
    required String lessonId,
    required LessonQuizModel quiz,
  }) async {
    try {
      final docRef = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection('quizzes')
          .add(quiz.toJson());

      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create quiz: ${e.toString()}');
    }
  }

  // READ - Get quiz
  Future<LessonQuizModel> getQuiz({
    required String courseId,
    required String lessonId,
    required String quizId,
  }) async {
    try {
      final doc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection('quizzes')
          .doc(quizId)
          .get();

      if (!doc.exists) throw Exception('Quiz not found');

      return LessonQuizModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get quiz: ${e.toString()}');
    }
  }

  // UPDATE - Update quiz
  Future<void> updateQuiz({
    required String courseId,
    required String lessonId,
    required String quizId,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection('quizzes')
          .doc(quizId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update quiz: ${e.toString()}');
    }
  }

  // DELETE - Delete quiz
  Future<void> deleteQuiz({
    required String courseId,
    required String lessonId,
    required String quizId,
  }) async {
    try {
      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection('quizzes')
          .doc(quizId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete quiz: ${e.toString()}');
    }
  }

  // ADD QUESTION
  Future<void> addQuestion({
    required String courseId,
    required String lessonId,
    required String quizId,
    required Map<String, dynamic> question,
  }) async {
    try {
      final quiz = await getQuiz(
        courseId: courseId,
        lessonId: lessonId,
        quizId: quizId,
      );

      final updatedQuestions = [...quiz.questions, question];

      await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection('quizzes')
          .doc(quizId)
          .update({
        'questions': updatedQuestions,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add question: ${e.toString()}');
    }
  }

  // GET - Get quiz results
  Future<List<Map<String, dynamic>>> getQuizResults({
    required String courseId,
    required String lessonId,
    required String quizId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection('quizzes')
          .doc(quizId)
          .collection('results')
          .orderBy('completedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to get results: ${e.toString()}');
    }
  }

  // GET - Get quiz stats
  Future<Map<String, dynamic>> getQuizStats({
    required String courseId,
    required String lessonId,
    required String quizId,
  }) async {
    try {
      final doc = await _firestore
          .collection(COURSES_COLLECTION)
          .doc(courseId)
          .collection(LESSONS_SUBCOLLECTION)
          .doc(lessonId)
          .collection('quizzes')
          .doc(quizId)
          .get();

      if (!doc.exists) throw Exception('Quiz not found');

      final data = doc.data()!;

      return {
        'totalAttempts': data['totalAttempts'] ?? 0,
        'averageScore': data['averageScore'] ?? 0,
        'passRate': data['passRate'] ?? 0,
        'averageTime': data['averageTimeSeconds'] ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to get stats: ${e.toString()}');
    }
  }
}
