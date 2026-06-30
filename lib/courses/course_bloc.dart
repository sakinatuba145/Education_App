import 'package:flutter/material.dart';
import 'course_model.dart';
import 'course_service.dart';

class CourseBloc extends ChangeNotifier {
  final CourseService _service = CourseService();

  List<CourseModel> courses = [];
  bool isLoading = false;

  Future<void> fetchCourses() async {
    isLoading = true;
    notifyListeners();

    courses = await _service.getCourses();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addCourse(CourseModel course) async {
    await _service.addCourse(course);
    await fetchCourses();
  }

  Future<void> deleteCourse(String id) async {
    await _service.deleteCourse(id);
    await fetchCourses();
  }
}