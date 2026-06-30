import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:education_app/teacher/models/course_model.dart';

class EnrolledCourse {
  final String courseId;
  final String courseTitle;
  final String courseSubtitle;
  final String? thumbnailUrl;
  final String instructorName;
  final DateTime enrolledAt;
  final double progress;
  final String status;
  final List<String> completedLessons;
  final int totalLessons;
  final DateTime lastAccessedAt;

  EnrolledCourse({
    required this.courseId,
    required this.courseTitle,
    required this.courseSubtitle,
    this.thumbnailUrl,
    required this.instructorName,
    required this.enrolledAt,
    required this.progress,
    required this.status,
    required this.completedLessons,
    required this.totalLessons,
    required this.lastAccessedAt,
  });

  factory EnrolledCourse.fromMap(String courseId, Map<String, dynamic> map) {
    return EnrolledCourse(
      courseId: courseId,
      courseTitle: map['courseTitle'] ?? '',
      courseSubtitle: map['courseSubtitle'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      instructorName: map['instructorName'] ?? '',
      enrolledAt: (map['enrolledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      progress: (map['progress'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'active',
      completedLessons: List<String>.from(map['completedLessons'] ?? []),
      totalLessons: map['totalLessons'] ?? 0,
      lastAccessedAt: (map['lastAccessedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'courseId': courseId,
    'courseTitle': courseTitle,
    'courseSubtitle': courseSubtitle,
    'thumbnailUrl': thumbnailUrl,
    'instructorName': instructorName,
    'enrolledAt': Timestamp.fromDate(enrolledAt),
    'progress': progress,
    'status': status,
    'completedLessons': completedLessons,
    'totalLessons': totalLessons,
    'lastAccessedAt': Timestamp.fromDate(lastAccessedAt),
  };

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'active' && progress > 0;
  int get progressPercent => (progress * 100).round();
}

class EnrollmentService {
  static final EnrollmentService _instance = EnrollmentService._internal();
  factory EnrollmentService() => _instance;
  EnrollmentService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference get _userEnrollments => _firestore
      .collection('users')
      .doc(_uid)
      .collection('enrollments');

  Future<void> enrollInCourse({required CourseModel course}) async {
    if (_uid == null) throw Exception('Not logged in');
    final alreadyEnrolled = await isEnrolled(course.id);
    if (alreadyEnrolled) return;

    final user = _auth.currentUser!;
    final batch = _firestore.batch();
    final now = Timestamp.now();

    final userEnrollmentRef = _userEnrollments.doc(course.id);
    batch.set(userEnrollmentRef, {
      'courseId': course.id,
      'courseTitle': course.title,
      'courseSubtitle': course.subtitle,
      'thumbnailUrl': course.thumbnailUrl,
      'instructorName': course.instructorName.isNotEmpty
          ? course.instructorName
          : course.teacherId,
      'enrolledAt': now,
      'progress': 0.0,
      'status': 'active',
      'completedLessons': [],
      'totalLessons': course.totalLessons,
      'lastAccessedAt': now,
    });

    final courseEnrollmentRef = _firestore
        .collection('courses')
        .doc(course.id)
        .collection('enrollments')
        .doc(_uid);
    batch.set(courseEnrollmentRef, {
      'userId': _uid,
      'userName': user.displayName?.split('|').first ?? user.email ?? '',
      'userEmail': user.email ?? '',
      'enrolledAt': now,
      'progress': 0.0,
      'status': 'active',
    });

    await batch.commit();

    await _firestore.collection('courses').doc(course.id).update({
      'totalEnrolled': FieldValue.increment(1),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<bool> isEnrolled(String courseId) async {
    if (_uid == null) return false;
    final doc = await _userEnrollments.doc(courseId).get();
    return doc.exists;
  }

  Stream<List<EnrolledCourse>> streamMyEnrollments() {
    if (_uid == null) return const Stream.empty();
    return _userEnrollments
        .orderBy('lastAccessedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EnrolledCourse.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<EnrolledCourse>> getMyEnrollments() async {
    if (_uid == null) return [];
    final snapshot = await _userEnrollments
        .orderBy('lastAccessedAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) =>
            EnrolledCourse.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<EnrolledCourse?> getEnrollment(String courseId) async {
    if (_uid == null) return null;
    final doc = await _userEnrollments.doc(courseId).get();
    if (!doc.exists) return null;
    return EnrolledCourse.fromMap(courseId, doc.data() as Map<String, dynamic>);
  }

  Future<void> markLessonComplete({
    required String courseId,
    required String lessonId,
    required int totalLessons,
  }) async {
    if (_uid == null) return;
    final enrollmentRef = _userEnrollments.doc(courseId);
    final doc = await enrollmentRef.get();
    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    final completedLessons = List<String>.from(data['completedLessons'] ?? []);
    if (!completedLessons.contains(lessonId)) {
      completedLessons.add(lessonId);
    }

    final total = totalLessons > 0 ? totalLessons : 1;
    final newProgress = completedLessons.length / total;
    final newStatus = newProgress >= 1.0 ? 'completed' : 'active';

    final batch = _firestore.batch();
    batch.update(enrollmentRef, {
      'completedLessons': completedLessons,
      'progress': newProgress,
      'status': newStatus,
      'lastAccessedAt': Timestamp.now(),
    });

    final courseEnrollRef = _firestore
        .collection('courses')
        .doc(courseId)
        .collection('enrollments')
        .doc(_uid);
    batch.update(courseEnrollRef, {
      'progress': newProgress,
      'status': newStatus,
    });

    await batch.commit();

    if (newStatus == 'completed') {
      await _firestore.collection('courses').doc(courseId).update({
        'totalCompleted': FieldValue.increment(1),
      });
    }
  }

  Future<void> updateLastAccessed(String courseId) async {
    if (_uid == null) return;
    await _userEnrollments.doc(courseId).update({
      'lastAccessedAt': Timestamp.now(),
    });
  }

  Future<void> toggleFavorite(String courseId) async {
    if (_uid == null) return;
    final userRef = _firestore.collection('users').doc(_uid);
    final doc = await userRef.get();
    final favorites = List<String>.from(
        (doc.data() as Map<String, dynamic>?)?['favorites'] ?? []);

    if (favorites.contains(courseId)) {
      favorites.remove(courseId);
    } else {
      favorites.add(courseId);
    }
    await userRef.set({'favorites': favorites}, SetOptions(merge: true));
  }

  Future<bool> isFavorite(String courseId) async {
    if (_uid == null) return false;
    final doc = await _firestore.collection('users').doc(_uid).get();
    final favorites = List<String>.from(
        (doc.data() as Map<String, dynamic>?)?['favorites'] ?? []);
    return favorites.contains(courseId);
  }

  Stream<List<String>> streamFavoriteIds() {
    if (_uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(_uid)
        .snapshots()
        .map((doc) =>
            List<String>.from((doc.data() ?? {})['favorites'] ?? []));
  }

  Future<List<String>> getFavoriteIds() async {
    if (_uid == null) return [];
    final doc = await _firestore.collection('users').doc(_uid).get();
    return List<String>.from((doc.data() ?? {})['favorites'] ?? []);
  }
}
