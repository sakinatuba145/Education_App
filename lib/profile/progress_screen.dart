import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/student/services/enrollment_service.dart';
import 'package:education_app/student/services/progress_service.dart';
import 'package:education_app/student/screens/course_player_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  final ProgressService _progressService = ProgressService();

  List<EnrolledCourse> _enrollments = [];
  List<QuizResult> _quizResults = [];
  StudentStats? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _enrollmentService.getMyEnrollments(),
        _progressService.getMyQuizResults(),
        _progressService.getStudentStats(),
      ]);
      setState(() {
        _enrollments = results[0] as List<EnrolledCourse>;
        _quizResults = results[1] as List<QuizResult>;
        _stats = results[2] as StudentStats;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loading = true);
              _loadData();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Learning Overview', style: textTheme.headlineMedium),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        _summaryCard(context, Icons.menu_book,
                            '${_stats?.enrolledCourses ?? 0}', 'Enrolled'),
                        const SizedBox(width: 10),
                        _summaryCard(context, Icons.check_circle_outline,
                            '${_stats?.completedCourses ?? 0}', 'Completed'),
                        const SizedBox(width: 10),
                        _summaryCard(context, Icons.quiz,
                            '${_stats?.quizzesTaken ?? 0}', 'Quizzes'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (_stats != null && _enrollments.isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Overall Progress',
                                  style: textTheme.titleLarge),
                              const SizedBox(height: 15),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _stats!.avgProgress,
                                  minHeight: 12,
                                  color: primary,
                                  backgroundColor:
                                      primary.withValues(alpha: 0.2),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_stats!.avgProgressPercent}% avg completion',
                                    style: textTheme.bodyMedium,
                                  ),
                                  if (_stats!.quizzesTaken > 0)
                                    Text(
                                      '${_stats!.avgScorePercent}% avg quiz score',
                                      style: textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600]),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    if (_enrollments.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(Icons.school_outlined,
                                  size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text('No courses enrolled yet',
                                  style: textTheme.titleLarge?.copyWith(
                                      color: Colors.grey[600])),
                              const SizedBox(height: 8),
                              Text(
                                'Enroll in courses from the Explore tab\nto track your progress here.',
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      Text('Courses Progress', style: textTheme.titleLarge),
                      const SizedBox(height: 12),
                      ..._enrollments.map((enrollment) =>
                          _courseProgressCard(context, enrollment)),
                    ],

                    if (_quizResults.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Recent Quiz Results',
                          style: textTheme.titleLarge),
                      const SizedBox(height: 12),
                      ..._quizResults.take(5).map((result) =>
                          _quizResultCard(context, result)),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _summaryCard(
      BuildContext context, IconData icon, String number, String label) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: primary),
              const SizedBox(height: 8),
              Text(number,
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(label,
                  style:
                      textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _courseProgressCard(BuildContext context, EnrolledCourse enrollment) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CoursePlayerScreen(courseId: enrollment.courseId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      enrollment.isCompleted
                          ? Icons.check_circle
                          : Icons.school,
                      color: enrollment.isCompleted
                          ? AppColors.success
                          : primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(enrollment.courseTitle,
                            style: textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(
                          enrollment.isCompleted
                              ? 'Completed ✓'
                              : '${enrollment.completedLessons.length} / ${enrollment.totalLessons} lessons',
                          style: textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${enrollment.progressPercent}%',
                    style: textTheme.titleMedium?.copyWith(
                      color: enrollment.isCompleted
                          ? AppColors.success
                          : primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: enrollment.progress,
                  minHeight: 8,
                  color: enrollment.isCompleted ? AppColors.success : primary,
                  backgroundColor: primary.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quizResultCard(BuildContext context, QuizResult result) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: result.passed
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${result.percentageInt}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: result.passed ? AppColors.success : AppColors.error,
                fontSize: 13,
              ),
            ),
          ),
        ),
        title: Text(result.quizTitle, style: textTheme.titleSmall),
        subtitle: Text(
          '${result.score} / ${result.totalQuestions} correct • ${_formatDate(result.takenAt)}',
          style: textTheme.bodySmall,
        ),
        trailing: Icon(
          result.passed ? Icons.check_circle : Icons.cancel,
          color: result.passed ? AppColors.success : AppColors.error,
          size: 20,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
