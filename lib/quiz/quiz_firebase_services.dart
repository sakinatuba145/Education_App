import 'package:cloud_firestore/cloud_firestore.dart';

class QuizFirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get quizzes from Firestore
  Future<List<Map<String, dynamic>>> getQuizzes() async {
    final snapshot = await firestore.collection('quizzes').get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
  // Save result
  Future<void> saveResult({
    required String uid,
    required String quizId,
    required int score,
  }) async {
    await firestore.collection('results').add({
      "uid": uid,
      "quizId": quizId,
      "score": score,
      "createdAt": DateTime.now(),
    });
  }
}
