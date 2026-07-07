import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// DashboardService — fetches real data from Firestore
class DashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<int> getCoursesCount() async {
    if (user == null) return 0;
    final snap = await _db
        .collection('enrollments')
        .where('userId', isEqualTo: user!.uid)
        .count()
        .get();
    return snap.count ?? 0;
  }

  Future<int> getQuizzesTakenCount() async {
    if (user == null) return 0;
    final snap = await _db
        .collectionGroup('quiz_results')
        .where('userId', isEqualTo: user!.uid)
        .count()
        .get();
    return snap.count ?? 0;
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    if (user == null) return {'name': 'Student', 'role': 'Student'};
    final doc = await _db.collection('users').doc(user!.uid).get();
    final data = doc.data() ?? {};
    final rawName = (data['displayName'] ?? user!.displayName ?? '').toString();
    final name = rawName.split('|').first.trim();
    return {
      'name': name.isNotEmpty ? name : 'Student',
      'role': data['role'] ?? data['position'] ?? 'Student',
    };
  }
}
