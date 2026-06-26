import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizResult {
  final String id;
  final String quizId;
  final String quizTitle;
  final String courseId;
  final int score;
  final int totalQuestions;
  final DateTime takenAt;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.courseId,
    required this.score,
    required this.totalQuestions,
    required this.takenAt,
  });

  factory QuizResult.fromMap(String id, Map<String, dynamic> map) {
    return QuizResult(
      id: id,
      quizId: map['quizId'] ?? '',
      quizTitle: map['quizTitle'] ?? 'Quiz',
      courseId: map['courseId'] ?? '',
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 1,
      takenAt: (map['takenAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  double get percentage => totalQuestions > 0 ? score / totalQuestions : 0;
  int get percentageInt => (percentage * 100).round();
  bool get passed => percentageInt >= 70;
}

class StudentStats {
  final int enrolledCourses;
  final int completedCourses;
  final int quizzesTaken;
  final double avgProgress;
  final double avgScore;

  StudentStats({
    required this.enrolledCourses,
    required this.completedCourses,
    required this.quizzesTaken,
    required this.avgProgress,
    required this.avgScore,
  });

  int get avgProgressPercent => (avgProgress * 100).round();
  int get avgScorePercent => (avgScore * 100).round();
}

class ProgressService {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> saveQuizResult({
    required String quizId,
    required String quizTitle,
    required String courseId,
    required int score,
    required int totalQuestions,
  }) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('quiz_results')
        .add({
      'quizId': quizId,
      'quizTitle': quizTitle,
      'courseId': courseId,
      'score': score,
      'totalQuestions': totalQuestions,
      'takenAt': Timestamp.now(),
      'userId': _uid,
    });
  }

  Future<List<QuizResult>> getMyQuizResults() async {
    if (_uid == null) return [];
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('quiz_results')
        .orderBy('takenAt', descending: true)
        .get();
    return snapshot.docs
        .map((d) => QuizResult.fromMap(d.id, d.data()))
        .toList();
  }

  Future<StudentStats> getStudentStats() async {
    if (_uid == null) {
      return StudentStats(
          enrolledCourses: 0,
          completedCourses: 0,
          quizzesTaken: 0,
          avgProgress: 0,
          avgScore: 0);
    }

    final enrollmentsSnap = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('enrollments')
        .get();

    final quizResultsSnap = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('quiz_results')
        .get();

    int enrolled = enrollmentsSnap.docs.length;
    int completed = 0;
    double totalProgress = 0;

    for (final doc in enrollmentsSnap.docs) {
      final data = doc.data();
      final progress = (data['progress'] ?? 0.0).toDouble();
      totalProgress += progress;
      if (data['status'] == 'completed') completed++;
    }

    double avgProgress = enrolled > 0 ? totalProgress / enrolled : 0;

    int quizzesTaken = quizResultsSnap.docs.length;
    double totalScore = 0;
    for (final doc in quizResultsSnap.docs) {
      final data = doc.data();
      final score = (data['score'] ?? 0) as int;
      final total = (data['totalQuestions'] ?? 1) as int;
      totalScore += total > 0 ? score / total : 0;
    }
    double avgScore = quizzesTaken > 0 ? totalScore / quizzesTaken : 0;

    return StudentStats(
      enrolledCourses: enrolled,
      completedCourses: completed,
      quizzesTaken: quizzesTaken,
      avgProgress: avgProgress,
      avgScore: avgScore,
    );
  }
}
