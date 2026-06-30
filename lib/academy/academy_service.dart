import 'package:cloud_firestore/cloud_firestore.dart';

class AcademyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getPlatformStats() async {
    final results = await Future.wait([
      _db.collection('users').where('role', isEqualTo: 'teacher').get(),
      _db.collection('users').where('role', isEqualTo: 'student').get(),
      _db.collection('courses').get(),
      _db.collection('courses').where('status', isEqualTo: 'published').get(),
    ]);

    final teachers = results[0].docs;
    final students = results[1].docs;
    final allCourses = results[2].docs;
    final publishedCourses = results[3].docs;

    int totalEnrolled = 0;
    for (final doc in allCourses) {
      totalEnrolled += (doc.data()['totalEnrolled'] as int? ?? 0);
    }

    return {
      'teacherCount': teachers.length,
      'studentCount': students.length,
      'totalCourses': allCourses.length,
      'publishedCourses': publishedCourses.length,
      'totalEnrollments': totalEnrolled,
    };
  }

  Stream<List<Map<String, dynamic>>> streamTeachers() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'teacher')
        .snapshots()
        .asyncMap((snap) async {
      final teachers = <Map<String, dynamic>>[];
      for (final doc in snap.docs) {
        final data = {'id': doc.id, ...doc.data()};
        final coursesSnap = await _db
            .collection('courses')
            .where('teacherId', isEqualTo: doc.id)
            .get();
        data['courseCount'] = coursesSnap.docs.length;
        int enrolled = 0;
        for (final c in coursesSnap.docs) {
          enrolled += (c.data()['totalEnrolled'] as int? ?? 0);
        }
        data['totalStudents'] = enrolled;
        teachers.add(data);
      }
      return teachers;
    });
  }

  Stream<List<Map<String, dynamic>>> streamAllCourses() {
    return _db
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Future<List<Map<String, dynamic>>> getTopCourses({int limit = 10}) async {
    final snap = await _db
        .collection('courses')
        .where('status', isEqualTo: 'published')
        .orderBy('totalEnrolled', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> getRecentStudents(
      {int limit = 20}) async {
    final snap = await _db
        .collection('users')
        .where('role', isEqualTo: 'student')
        .limit(limit)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }
}
