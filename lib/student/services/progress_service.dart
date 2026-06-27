import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizResult {
  final String id;
  final String quizId;
  final String quizTitle;
  final String courseId;
  final String lessonId;
  final int score;
  final int totalQuestions;
  final DateTime takenAt;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.courseId,
    required this.lessonId,
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
      lessonId: map['lessonId'] ?? '',
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
  String get _displayName =>
      _auth.currentUser?.displayName?.split('|').first ??
      _auth.currentUser?.email?.split('@').first ??
      'Student';
  String get _email => _auth.currentUser?.email ?? '';

  Future<void> saveQuizResult({
    required String quizId,
    required String quizTitle,
    required String courseId,
    required String lessonId,
    required int score,
    required int totalQuestions,
  }) async {
    if (_uid == null) return;

    final now = Timestamp.now();
    final percentage = totalQuestions > 0 ? (score / totalQuestions * 100).round() : 0;
    final passed = percentage >= 70;

    final batch = _firestore.batch();

    // 1. Save to student's quiz_results (existing)
    final resultRef = _firestore
        .collection('users')
        .doc(_uid)
        .collection('quiz_results')
        .doc();
    batch.set(resultRef, {
      'quizId': quizId,
      'quizTitle': quizTitle,
      'courseId': courseId,
      'lessonId': lessonId,
      'score': score,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'passed': passed,
      'takenAt': now,
      'userId': _uid,
    });

    // 2. Mark quiz as completed on the lesson quiz document
    if (courseId.isNotEmpty && lessonId.isNotEmpty && quizId.isNotEmpty) {
      final responseRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('lessons')
          .doc(lessonId)
          .collection('quizzes')
          .doc(quizId)
          .collection('responses')
          .doc(_uid);
      batch.set(responseRef, {
        'studentId': _uid,
        'studentName': _displayName,
        'studentEmail': _email,
        'score': score,
        'totalQuestions': totalQuestions,
        'percentage': percentage,
        'passed': passed,
        'takenAt': now,
      });
    }

    // 3. Teacher notification — written to course's notifications subcollection
    if (courseId.isNotEmpty) {
      final notifRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('quizNotifications')
          .doc();
      batch.set(notifRef, {
        'type': 'quiz_completed',
        'studentId': _uid,
        'studentName': _displayName,
        'studentEmail': _email,
        'lessonId': lessonId,
        'quizId': quizId,
        'quizTitle': quizTitle,
        'score': score,
        'totalQuestions': totalQuestions,
        'percentage': percentage,
        'passed': passed,
        'takenAt': now,
        'read': false,
      });

      // 4. Update course analytics counters
      final courseRef = _firestore.collection('courses').doc(courseId);
      batch.update(courseRef, {
        'totalQuizzesTaken': FieldValue.increment(1),
        'lastActivityAt': now,
      });
    }

    await batch.commit();
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

  /// Returns a map of `courseId_lessonId` → best QuizResult for quick lookups.
  Future<Map<String, QuizResult>> getCompletedQuizMap() async {
    final results = await getMyQuizResults();
    final map = <String, QuizResult>{};
    for (final r in results) {
      final key = '${r.courseId}_${r.lessonId}';
      // Keep highest score
      if (!map.containsKey(key) || r.percentageInt > map[key]!.percentageInt) {
        map[key] = r;
      }
    }
    return map;
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
