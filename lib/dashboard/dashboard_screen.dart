import 'package:education_app/dashboard/student_activity_widget.dart';
import 'package:education_app/dashboard/top_students_widget.dart';
import 'package:flutter/material.dart';
import 'package:education_app/dashboard/course_card.dart';


import '../courses/course_model.dart';
import 'course_card.dart';

class DashboardHome extends StatelessWidget {
  static String id='dashboard_screen';
  final List<StudentModel>? topStudents;

  const DashboardHome({
    super.key, this.topStudents,

  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseCard(
            course: CourseModel(
              id: id,
              title: "Flutter",
              teacher: "Anne",
              progress: "10 Month",
              image: "assets/image/flutter.png",
            ),
          ),

          const SizedBox(height: 20),

          StudentActivityWidget(
            activities: activities,
          ),

          const SizedBox(height: 20),

          TopStudentsWidget(students: topStudents!),
        ],
      ),
    );
  }
}