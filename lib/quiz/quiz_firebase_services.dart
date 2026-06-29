import 'package:cloud_firestore/cloud_firestore.dart';

class QuizFirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///3.31 CREATE EXAM
  Future<void> createQuiz({
    required String title,
    required String subject,
  }) async {
    await firestore.collection('quizzes').add({
      "title": title,
      "subject": subject,
      "questions": [],
      "createdAt": Timestamp.now(),
    });
  }

  /// STREAM QUIZZES
  Stream<QuerySnapshot> getQuizzesStream() {
    return firestore.collection('quizzes').snapshots();
  }

  /// Save result
  Future<void> saveResult({
    required String uid,
    required String quizId,
    required int score,
  }) async {
    await firestore.collection('results').add({
      "uid": uid,
      "quizId": quizId,
      "score": score,
      "createdAt": Timestamp.now(),
    });
  }
}