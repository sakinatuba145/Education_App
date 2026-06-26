import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/models/course_model.dart';

// ── Data models ────────────────────────────────────────────────────────────

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
  final String? photoUrl;
  final int courseCount;
  final int studentCount;
  final String status;

  AcademyTeacher({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.courseCount,
    required this.studentCount,
    required this.status,
  });
}

class TrendPoint {
  final String label;
  final double value;
  const TrendPoint(this.label, this.value);
}

class AcademyInvite {
  final String id;
  final String email;
  final String name;
  final String status;
  final DateTime createdAt;

  AcademyInvite({
    required this.id,
    required this.email,
    required this.name,
    required this.status,
    required this.createdAt,
  });
}

// ── Service ────────────────────────────────────────────────────────────────

class AcademyService {
  static final AcademyService _instance = AcademyService._internal();
  factory AcademyService() => _instance;
  AcademyService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // ── Summary stats ──────────────────────────────────────────────────────
  Future<AcademyStats> getAcademyStats() async {
    try {
      final results = await Future.wait([
        _db.collection('courses').where('academyId', isEqualTo: _uid).get(),
        _db
            .collection('users')
            .where('role', isEqualTo: 'teacher')
            .where('academyId', isEqualTo: _uid)
            .get(),
      ]);

      final coursesSnap = results[0];
      final teachersSnap = results[1];

      int totalStudents = 0;
      double totalRevenue = 0;

      for (final doc in coursesSnap.docs) {
        final data = doc.data();
        final enrolled = (data['totalEnrolled'] ?? 0) as int;
        final price = (data['price'] ?? 0.0) as num;
        totalStudents += enrolled;
        if (data['status'] == 'published') totalRevenue += price * enrolled;
      }

      return AcademyStats(
        totalTeachers: teachersSnap.size,
        totalCourses: coursesSnap.size,
        totalStudents: totalStudents,
        totalRevenue: totalRevenue,
      );
    } catch (_) {
      return AcademyStats(
          totalTeachers: 0, totalCourses: 0, totalStudents: 0, totalRevenue: 0);
    }
  }

  // ── Teachers ───────────────────────────────────────────────────────────
  Future<List<AcademyTeacher>> getTeachers() async {
    try {
      final snap = await _db
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .where('academyId', isEqualTo: _uid)
          .get();

      final List<Future<AcademyTeacher>> futures = snap.docs.map((doc) async {
        final data = doc.data();
        final coursesSnap = await _db
            .collection('courses')
            .where('teacherId', isEqualTo: doc.id)
            .get();

        int studentCount = 0;
        for (final c in coursesSnap.docs) {
          studentCount += (c.data()['totalEnrolled'] ?? 0) as int;
        }

        final raw = data['displayName'] ?? data['name'] ?? '';
        final name = raw.contains('|') ? raw.split('|').first : raw;

        return AcademyTeacher(
          uid: doc.id,
          name: name.isNotEmpty ? name : data['email'] ?? 'Teacher',
          email: data['email'] ?? '',
          photoUrl: data['photoUrl'] as String?,
          courseCount: coursesSnap.size,
          studentCount: studentCount,
          status: data['status'] ?? 'active',
        );
      }).toList();

      return await Future.wait(futures);
    } catch (_) {
      return [];
    }
  }

  Future<void> removeTeacher(String teacherUid) async {
    await _db.collection('users').doc(teacherUid).update({
      'academyId': FieldValue.delete(),
    });
  }

  // ── Courses ────────────────────────────────────────────────────────────
  Future<List<CourseModel>> getAcademyCourses() async {
    try {
      final snap = await _db
          .collection('courses')
          .where('academyId', isEqualTo: _uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs.map((doc) {
        final data = {...doc.data(), 'id': doc.id};
        return CourseModel.fromJson(data);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> updateCourseStatus(String courseId, String status) async {
    await _db.collection('courses').doc(courseId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Invites ────────────────────────────────────────────────────────────
  Future<void> inviteTeacher(String email, String name) async {
    await _db.collection('academy_invites').add({
      'academyId': _uid,
      'email': email.trim().toLowerCase(),
      'name': name.trim(),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<AcademyInvite>> getPendingInvites() async {
    try {
      final snap = await _db
          .collection('academy_invites')
          .where('academyId', isEqualTo: _uid)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs.map((doc) {
        final d = doc.data();
        return AcademyInvite(
          id: doc.id,
          email: d['email'] ?? '',
          name: d['name'] ?? '',
          status: d['status'] ?? 'pending',
          createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> cancelInvite(String inviteId) async {
    await _db.collection('academy_invites').doc(inviteId).delete();
  }

  // ── Trend data ─────────────────────────────────────────────────────────

  /// Returns weekly enrollment counts for the last [weeks] weeks.
  /// Each TrendPoint.label = 'W1' … 'W[n]', value = enrolment count.
  Future<List<TrendPoint>> getEnrollmentTrend({int weeks = 8}) async {
    try {
      final now = DateTime.now();
      final cutoff = now.subtract(Duration(days: weeks * 7));

      // 1. Get all academy course IDs
      final coursesSnap = await _db
          .collection('courses')
          .where('academyId', isEqualTo: _uid)
          .get();

      // 2. Build weekly buckets
      final buckets = List<double>.filled(weeks, 0);

      // 3. For each course query enrollments since cutoff
      for (final courseDoc in coursesSnap.docs) {
        final enrollSnap = await _db
            .collection('courses')
            .doc(courseDoc.id)
            .collection('enrollments')
            .where('enrolledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoff))
            .get();

        for (final e in enrollSnap.docs) {
          final data = e.data();
          DateTime? dt;
          final raw = data['enrolledAt'];
          if (raw is Timestamp) dt = raw.toDate();
          if (dt != null) {
            final daysAgo = now.difference(dt).inDays;
            final weekBucket = (daysAgo / 7).floor();
            if (weekBucket < weeks) {
              // weekBucket 0 = this week, flip for chronological order
              buckets[weeks - 1 - weekBucket] += 1;
            }
          }
        }
      }

      return List.generate(weeks, (i) {
        final weeksAgo = weeks - 1 - i;
        final label = weeksAgo == 0 ? 'Now' : 'W-$weeksAgo';
        return TrendPoint(label, buckets[i]);
      });
    } catch (_) {
      return _emptyTrend(weeks);
    }
  }

  /// Returns weekly revenue for the last [weeks] weeks.
  Future<List<TrendPoint>> getRevenueTrend({int weeks = 8}) async {
    try {
      final now = DateTime.now();
      final cutoff = now.subtract(Duration(days: weeks * 7));

      final coursesSnap = await _db
          .collection('courses')
          .where('academyId', isEqualTo: _uid)
          .where('status', isEqualTo: 'published')
          .get();

      final buckets = List<double>.filled(weeks, 0);

      for (final courseDoc in coursesSnap.docs) {
        final price = ((courseDoc.data()['price'] ?? 0.0) as num).toDouble();
        if (price <= 0) continue;

        final enrollSnap = await _db
            .collection('courses')
            .doc(courseDoc.id)
            .collection('enrollments')
            .where('enrolledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoff))
            .get();

        for (final e in enrollSnap.docs) {
          final data = e.data();
          DateTime? dt;
          final raw = data['enrolledAt'];
          if (raw is Timestamp) dt = raw.toDate();
          if (dt != null) {
            final daysAgo = now.difference(dt).inDays;
            final weekBucket = (daysAgo / 7).floor();
            if (weekBucket < weeks) {
              buckets[weeks - 1 - weekBucket] += price;
            }
          }
        }
      }

      return List.generate(weeks, (i) {
        final weeksAgo = weeks - 1 - i;
        final label = weeksAgo == 0 ? 'Now' : 'W-$weeksAgo';
        return TrendPoint(label, buckets[i]);
      });
    } catch (_) {
      return _emptyTrend(weeks);
    }
  }

  List<TrendPoint> _emptyTrend(int weeks) =>
      List.generate(weeks, (i) => TrendPoint('W${i + 1}', 0));
}
