import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_model.dart';

class CourseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String collection = "courses";

  // 📥 گرفتن همه کورس‌ها
  Future<List<CourseModel>> getCourses() async {
    final snapshot = await _db.collection(collection).get();

    return snapshot.docs
        .map((doc) => CourseModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // ➕ افزودن کورس
  Future<void> addCourse(CourseModel course) async {
    await _db.collection(collection).add(course.toMap());
  }

  // ✏️ آپدیت کورس
  Future<void> updateCourse(CourseModel course) async {
    await _db.collection(collection).doc(course.id).update(course.toMap());
  }

  // ❌ حذف کورس
  Future<void> deleteCourse(String id) async {
    await _db.collection(collection).doc(id).delete();
  }
}