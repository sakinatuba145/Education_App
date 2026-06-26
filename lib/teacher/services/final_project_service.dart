import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FinalProjectService {
  static final FinalProjectService _instance = FinalProjectService._internal();
  factory FinalProjectService() => _instance;
  FinalProjectService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Project definition ────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getProject(String courseId) async {
    try {
      final doc = await _db
          .collection('courses').doc(courseId)
          .collection('finalProject').doc('config').get();
      return doc.exists ? doc.data() : null;
    } catch (_) { return null; }
  }

  Future<void> saveProject(String courseId, {
    required String title,
    required String description,
    required String instructions,
    required int passingScore,
    required int maxScore,
    required bool isRequired,
  }) async {
    await _db
        .collection('courses').doc(courseId)
        .collection('finalProject').doc('config').set({
      'title': title,
      'description': description,
      'instructions': instructions,
      'passingScore': passingScore,
      'maxScore': maxScore,
      'isRequired': isRequired,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteProject(String courseId) async {
    await _db
        .collection('courses').doc(courseId)
        .collection('finalProject').doc('config').delete();
  }

  // ── Student submissions ───────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> streamSubmissions(String courseId) {
    return _db
        .collection('courses').doc(courseId)
        .collection('projectSubmissions')
        .snapshots()
        .map((snap) => snap.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Future<List<Map<String, dynamic>>> getSubmissions(String courseId) async {
    try {
      final snap = await _db
          .collection('courses').doc(courseId)
          .collection('projectSubmissions').get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (_) { return []; }
  }

  Future<Map<String, dynamic>?> getMySubmission(String courseId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    try {
      final doc = await _db
          .collection('courses').doc(courseId)
          .collection('projectSubmissions').doc(uid).get();
      return doc.exists ? {'id': doc.id, ...doc.data()!} : null;
    } catch (_) { return null; }
  }

  Future<void> submitProject(String courseId, {
    required String submissionText,
    required String submissionUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');
    final name = user.displayName?.contains('|') == true
        ? user.displayName!.split('|').first
        : (user.displayName ?? user.email ?? '');
    await _db
        .collection('courses').doc(courseId)
        .collection('projectSubmissions').doc(user.uid).set({
      'studentId': user.uid,
      'studentName': name,
      'studentEmail': user.email ?? '',
      'submissionText': submissionText,
      'submissionUrl': submissionUrl,
      'submittedAt': FieldValue.serverTimestamp(),
      'status': 'submitted',
      'score': null,
      'feedback': '',
      'gradedAt': null,
      'gradedBy': null,
    });
  }

  // ── Teacher grading ───────────────────────────────────────────────────────

  Future<void> gradeSubmission(String courseId, String studentId, {
    required int score,
    required int maxScore,
    required int passingScore,
    required String feedback,
  }) async {
    final teacher = _auth.currentUser;
    final passed = score >= passingScore;
    final status = passed ? 'passed' : 'failed';

    // 1. Update the submission doc
    await _db
        .collection('courses').doc(courseId)
        .collection('projectSubmissions').doc(studentId)
        .update({
      'score': score,
      'maxScore': maxScore,
      'feedback': feedback,
      'status': status,
      'passed': passed,
      'gradedAt': FieldValue.serverTimestamp(),
      'gradedBy': teacher?.uid ?? '',
    });

    // 2. Update student's enrollment record
    await _db
        .collection('users').doc(studentId)
        .collection('enrollments').doc(courseId)
        .update({
      'projectScore': score,
      'projectPassed': passed,
      'projectStatus': status,
      if (passed) 'status': 'completed',
      if (passed) 'progress': 1.0,
    });

    await _db
        .collection('courses').doc(courseId)
        .collection('enrollments').doc(studentId)
        .update({
      'projectScore': score,
      'projectPassed': passed,
      'projectStatus': status,
      if (passed) 'progress': 1.0,
      if (passed) 'status': 'completed',
    });

    // 3. If passed, issue certificate
    if (passed) {
      final courseDoc = await _db.collection('courses').doc(courseId).get();
      final courseData = courseDoc.data() ?? {};
      final certId = 'CERT-${courseId.substring(0, 6).toUpperCase()}-${studentId.substring(0, 6).toUpperCase()}';
      await _db
          .collection('users').doc(studentId)
          .collection('certificates').doc(courseId).set({
        'courseId': courseId,
        'courseTitle': courseData['title'] ?? 'Course',
        'certificateId': certId,
        'score': score,
        'maxScore': maxScore,
        'passed': true,
        'issuedAt': FieldValue.serverTimestamp(),
        'teacherId': teacher?.uid ?? '',
      });
      // Also increment course completed count
      await _db.collection('courses').doc(courseId).update({
        'totalCompleted': FieldValue.increment(1),
      }).catchError((_) {});
    }
  }

  // ── Certificate ───────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getMyCertificate(String courseId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    try {
      final doc = await _db
          .collection('users').doc(uid)
          .collection('certificates').doc(courseId).get();
      return doc.exists ? doc.data() : null;
    } catch (_) { return null; }
  }

  Future<List<Map<String, dynamic>>> getMyCertificates() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    try {
      final snap = await _db
          .collection('users').doc(uid)
          .collection('certificates').get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (_) { return []; }
  }
}
