import 'package:flutter/material.dart';

import '../../../student/course_player_screen.dart';
import '../../../student/enrollment_service.dart';
import '../../constants/theme.dart';
import '../glass_card.dart';


class HorizontalCourseCard extends StatelessWidget {
  const HorizontalCourseCard({super.key, required this.course});

  final EnrolledCourse course;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CoursePlayerScreen(courseId: course.courseId),
        ),
      ),
      child: Container(
        width: 220,
        height: 180,
        margin: const EdgeInsets.only(right: 14, bottom: 4),
        child: GlassCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ThemeColors.primary, Color(0xFFE65100)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: course.isCompleted
                          ? Colors.green.withValues(alpha: 0.12)
                          : ThemeColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${course.progressPercent}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: course.isCompleted
                            ? Colors.green.shade700
                            : ThemeColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                course.courseTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                course.instructorName.isNotEmpty
                    ? course.instructorName
                    : 'EduAf',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),

              const Spacer(),

              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: course.progress,
                  minHeight: 5,
                  color: course.isCompleted
                      ? Colors.green
                      : ThemeColors.primary,
                  backgroundColor: ThemeColors.primary.withValues(alpha: 0.10),
                ),
              ),

              const SizedBox(height: 6),
              Text(
                '${course.completedLessons.length}/${course.totalLessons} lessons',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
