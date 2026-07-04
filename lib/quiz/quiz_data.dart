import 'package:cloud_firestore/cloud_firestore.dart';
/// 3.8 QUIZ DATA SERVICE
/// Handles communication with the quizzes collection in Firestore.
class QuizData {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Stream all exams (LIVE DATA)
  static Stream<QuerySnapshot> getExams() {
    return firestore.collection('quizzes').snapshots();
  }
}