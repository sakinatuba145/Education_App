import 'package:education_app/core/constants/app_colors.dart';
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
  final bool isDarkMode;
  const TopStudentsWidget({
    super.key,
    required this.students,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = isDarkMode ? const Color(0xFF3A322A) : AppColors.studioGoldLight;
    final Color textColor = isDarkMode ? Colors.white : AppColors.studioInk;
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
              color: cardColor,
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.studioGold,
                  backgroundImage:
                    AssetImage(student.image),
                  // NetworkImage(student.image),
                ),

                SizedBox(height: 10),

                Text(
                  student.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                Text(student.grade, style: TextStyle(color: textColor.withValues(alpha: 0.7))),
                SizedBox(height: 8),
                Chip(
                  backgroundColor: AppColors.studioGold,
                  label:
                  Text("Score ${student.score}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}