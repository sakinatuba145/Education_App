import 'package:flutter/material.dart';
import '../../../student/enrollment_service.dart';
import '../../constants/theme.dart';
import 'empty_state.dart';


class FlashcardCourseList extends StatelessWidget {
  const FlashcardCourseList({
    super.key,
    required this.loadingCourses,
    required this.courses,
    required this.onSelectCourse,
  });

  final bool loadingCourses;
  final List<EnrolledCourse> courses;

  final void Function(EnrolledCourse course) onSelectCourse;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: loadingCourses
              ? const Center(
            child: CircularProgressIndicator(
              color: ThemeColors.primary,
            ),
          )
              : courses.isEmpty
              ? const EmptyState(
            title: 'No courses enrolled',
            subtitle:
            'Enroll in a course to start studying with flashcards',
            icon: Icons.style_outlined,
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (_, i) {
              final c = courses[i];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text(c.courseTitle),
                  subtitle: Text(
                    '${c.progressPercent}% complete · tap to study',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: ThemeColors.primary,
                  ),

                  onTap: () {
                    onSelectCourse(c);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}