import 'package:flutter/material.dart';
import 'package:education_app/courses/course_discovery_screen_premium.dart';

class CourseScreen extends StatelessWidget {
  static String id = 'course_screen';
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CourseDiscoveryScreenPremium();
  }
}
