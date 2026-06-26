import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/quiz/quiz_player_screen_premium.dart';

class StudentQuizBrowserScreen extends StatelessWidget {
  const StudentQuizBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final enrollmentService = EnrollmentService();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Quizzes',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap a course to see its lesson quizzes',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<EnrolledCourse>>(
                stream: enrollmentService.streamMyEnrollments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final courses = snapshot.data ?? [];
                  if (courses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.quiz_outlined,
                              size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            'No Quizzes Yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enroll in a course to access its quizzes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: courses.length,
                    itemBuilder: (context, i) =>
                        _CourseQuizCard(course: courses[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseQuizCard extends StatefulWidget {
  final EnrolledCourse course;
  const _CourseQuizCard({required this.course});

  @override
  State<_CourseQuizCard> createState() => _CourseQuizCardState();
}

class _CourseQuizCardState extends State<_CourseQuizCard> {
  final _firestore = FirebaseFirestore.instance;
  bool _expanded = false;
  bool _loading = false;
  List<Map<String, dynamic>> _lessons = [];

  Future<void> _toggle() async {
    if (_expanded) {
      setState(() => _expanded = false);
      return;
    }
    if (_lessons.isNotEmpty) {
      setState(() => _expanded = true);
      return;
    }
    setState(() {
      _loading = true;
      _expanded = true;
    });
    try {
      final snap = await _firestore
          .collection('courses')
          .doc(widget.course.courseId)
          .collection('lessons')
          .orderBy('sequenceNumber')
          .get();
      setState(() {
        _lessons = snap.docs
            .map((d) => {'id': d.id, ...d.data()})
            .toList();
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book_rounded,
                  color: AppColors.primary),
            ),
            title: Text(
              widget.course.courseTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                '${widget.course.progressPercent}% complete · tap to view quizzes'),
            trailing: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more),
            onTap: _toggle,
          ),
          if (_expanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              )
            else if (_lessons.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No lessons found for this course.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                itemCount: _lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, i) {
                  final lesson = _lessons[i];
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          AppColors.primary.withOpacity(0.15),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(lesson['title'] ?? 'Lesson ${i + 1}'),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Take Quiz',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        SizedBox(width: 4),
                        Icon(Icons.play_circle_fill_rounded,
                            color: AppColors.primary, size: 20),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizPlayerScreenPremium(
                          courseId: widget.course.courseId,
                          lessonId: lesson['id'] as String,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}
