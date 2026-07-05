import 'package:flutter/material.dart';

class StudentModel {
  final String name;
  final String grade;
  final int score;
  final String image;

  StudentModel({
    required this.name,
    required this.grade,
    required this.score,
    required this.image,
  });
}
class TopStudentsWidget extends StatelessWidget {
  final List<StudentModel> students;
  const TopStudentsWidget({
    super.key,
    required this.students,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];

          return Container(
            width: 200,
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xffFFE0B2),
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage:
                  AssetImage(student.image),
                  // NetworkImage(student.image),
                ),

                SizedBox(height: 10),

                Text(
                  student.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(student.grade),
                SizedBox(height: 8),
                Chip(
                  label:
                  Text("Score ${student.score}"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}