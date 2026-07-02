import 'package:flutter/material.dart';

import '../courses/course_model.dart';
class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate to course page
      },
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: Color(0xffFFE0B2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                'assets/images/img.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text("Teacher: ${course.teacher}"),

                  Text("Duration: ${course.progress}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}