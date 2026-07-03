import 'package:flutter/material.dart';
import 'course_model.dart';

class CourseList extends StatelessWidget {
  final List<CourseModel> courses;
  final Function(String id) onDelete;
  final Function(CourseModel course) onTap;

  const CourseList({
    super.key,
    required this.courses,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(course.title),
            subtitle: Text("Teacher: ${course.teacher}"),

            onTap: () => onTap(course), // ✔️ این مهم‌ترین خط

            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(course.id),
            ),
          ),
        );
      },
    );
  }
}