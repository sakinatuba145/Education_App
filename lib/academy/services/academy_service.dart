import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/models/course_model.dart';

class AcademyStats {
  final int totalTeachers;
  final int totalCourses;
  final int totalStudents;
  final double totalRevenue;

  AcademyStats({
    required this.totalTeachers,
    required this.totalCourses,
    required this.totalStudents,
    required this.totalRevenue,
  });
}

class AcademyTeacher {
  final String uid;
  final String name;
  final String email;
  final int courseCount;
  final int studentCount;
  final String status;

  AcademyTeacher({
    required this.uid,
    required this.name,
    required this.email,
    required this.courseCount,
    required this.studentCount,
    required this.status,
  });
}

class AcademyService {
  static final AcademyService _instance = AcademyService._internal();
  factory AcademyService() => _instance;
  AcademyService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<AcademyStats> getAcademyStats() async {
    try {
      final coursesSnap = await _firestore
          .collection('courses')
          .where('academyId', isEqualTo: _uid)
          .get();

      int totalStudents = 0;
      double totalRevenue = 0;

      for (final doc in coursesSnap.docs) {
        final data = doc.data();
        totalStudents += (data['totalEnrolled'] ?? 0) as int;
        final price = (data['price'] ?? 0.0) as num;
        final enrolled = (data['totalEnrolled'] ?? 0) as int;
        totalRevenue += price * enrolled;
      }

      final teachersSnap = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .where('academyId', isEqualTo: _uid)
          .get();

      return AcademyStats(
        totalTeachers: teachersSnap.size,
        totalCourses: coursesSnap.size,
        totalStudents: totalStudents,
        totalRevenue: totalRevenue,
      );
    } catch (e) {
      return AcademyStats(
          totalTeachers: 0,
          totalCourses: 0,
          totalStudents: 0,
          totalRevenue: 0);
    }
  }

  Future<List<AcademyTeacher>> getTeachers() async {
    try {
      final snap = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .where('academyId', isEqualTo: _uid)
          .get();

      final List<AcademyTeacher> teachers = [];
      for (final doc in snap.docs) {
        final data = doc.data();
        final coursesSnap = await _firestore
            .collection('courses')
            .where('teacherId', isEqualTo: doc.id)
            .get();

        int studentCount = 0;
        for (final c in coursesSnap.docs) {
          studentCount +=
              (c.data()['totalEnrolled'] ?? 0) as int;
        }

        final raw = data['displayName'] ?? data['name'] ?? '';
        final name = raw.contains('|') ? raw.split('|').first : raw;

        teachers.add(AcademyTeacher(
          uid: doc.id,
          name: name.isNotEmpty ? name : data['email'] ?? 'Teacher',
          email: data['email'] ?? '',
          courseCount: coursesSnap.size,
          studentCount: studentCount,
          status: data['status'] ?? 'active',
        ));
      }
      return teachers;
    } catch (_) {
      return [];
    }
  }

  Future<List<CourseModel>> getAcademyCourses() async {
    try {
      final snap = await _firestore
          .collection('courses')
          .where('academyId', isEqualTo: _uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CourseModel.fromJson(data);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> updateCourseStatus(
      String courseId, String status) async {
    await _firestore
        .collection('courses')
        .doc(courseId)
        .update({'status': status, 'updatedAt': FieldValue.serverTimestamp()});
  }
}
