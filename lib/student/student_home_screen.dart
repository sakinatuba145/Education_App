import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:education_app/core/I18n/messages.dart';
import 'package:education_app/student/enrollment_service.dart';
import 'package:education_app/student/progress_service.dart';
import 'package:education_app/student/course_player_screen.dart';
import 'package:education_app/courses/course_discovery_screen_premium.dart';

class StudentHomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const StudentHomeScreen({super.key, required this.onNavigate});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final _enrollment = EnrollmentService();
  final _progress = ProgressService();

  StudentStats? _stats;
  List<QuizResult> _quizResults = [];
  bool _statsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final results = await Future.wait([
        _progress.getStudentStats(),
        _progress.getMyQuizResults(),
      ]);
      if (mounted) {
        setState(() {
          _stats = results[0] as StudentStats;
          _quizResults = (results[1] as List<QuizResult>).take(10).toList();
          _statsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _statsLoading = false);
    }
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppMessages.goodMorning.tr;
    if (hour < 17) return AppMessages.goodAfternoon.tr;
    return AppMessages.goodEvening.tr;
  }

  String get _userName {
    final user = FirebaseAuth.instance.currentUser;
    final raw = user?.displayName ?? user?.email ?? '';
    final name = raw.split('|').first.split('@').first.trim();
    return name.isNotEmpty ? name : 'Student';
  }

  // Build chart data from quiz results grouped by course title (first word)
  List<_ChartEntry> get _chartData {
    final Map<String, List<double>> byCourse = {};
    for (final r in _quizResults) {
      final label = r.quizTitle.length > 12
          ? '${r.quizTitle.substring(0, 10)}…'
          : r.quizTitle;
      byCourse.putIfAbsent(label, () => []).add(r.percentage * 100);
    }
    return byCourse.entries.map((e) {
      final avg = e.value.reduce((a, b) => a + b) / e.value.length;
      return _ChartEntry(label: e.key, score: avg);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: RefreshIndicator(
        color: ThemeColors.primary,
        onRefresh: _loadStats,
        child: CustomScrollView(
          slivers: [
            // ─── Branded Header ───
            SliverToBoxAdapter(child: _buildHeader(textTheme)),

            // ─── Stats Row ───
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: _buildStatsRow(textTheme),
              ),
            ),

            // ─── Continue Learning ───
            SliverToBoxAdapter(
              child: _buildSectionHeader(AppMessages.continueLearning.tr, Icons.play_circle_outline_rounded, textTheme),
            ),
            SliverToBoxAdapter(
              child: _buildContinueLearning(textTheme),
            ),

            // ─── Quiz Activity Chart ───
            if (_quizResults.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _buildSectionHeader(AppMessages.quizPerformance.tr, Icons.bar_chart_rounded, textTheme),
              ),
              SliverToBoxAdapter(
                child: _buildChart(textTheme),
              ),
            ],

            // ─── Quick Actions ───
            SliverToBoxAdapter(
              child: _buildSectionHeader(AppMessages.quickActions.tr, Icons.flash_on_rounded, textTheme),
            ),
            SliverToBoxAdapter(
              child: _buildQuickActions(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.primary, Color(0xFFE65100)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.school_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'EduAf',
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '$_greeting, $_userName! 👋',
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppMessages.readyToLearn.tr,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => widget.onNavigate(3),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(TextTheme textTheme) {
    if (_statsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(color: ThemeColors.primary)),
      );
    }
    final stats = _stats;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          _statCard(Icons.menu_book_rounded, '${stats?.enrolledCourses ?? 0}', AppMessages.enrolled.tr, textTheme),
          const SizedBox(width: 10),
          _statCard(Icons.quiz_rounded, '${stats?.quizzesTaken ?? 0}', AppMessages.quizzes.tr, textTheme),
          const SizedBox(width: 10),
          _statCard(Icons.trending_up_rounded, '${stats?.avgProgressPercent ?? 0}%', AppMessages.avgProgress.tr, textTheme),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, TextTheme textTheme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.primary.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: ThemeColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(value, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: ThemeColors.black)),
            Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Icon(icon, color: ThemeColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: ThemeColors.black)),
        ],
      ),
    );
  }

  Widget _buildContinueLearning(TextTheme textTheme) {
    return StreamBuilder<List<EnrolledCourse>>(
      stream: _enrollment.streamMyEnrollments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(color: ThemeColors.primary)),
          );
        }

        final courses = snapshot.data ?? [];

        if (courses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ThemeColors.secondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.school_outlined, size: 48, color: ThemeColors.primary.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text(AppMessages.noCoursesYet.tr, style: textTheme.titleMedium?.copyWith(color: ThemeColors.black)),
                  const SizedBox(height: 6),
                  Text(AppMessages.exploreToStart.tr, style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () => widget.onNavigate(1),
                    icon: const Icon(Icons.explore_rounded, size: 18),
                    label: Text(AppMessages.exploreCourses.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final display = courses.take(3).toList();
        return Column(
          children: [
            ...display.map((c) => _enrolledCourseCard(c, textTheme)),
            if (courses.length > 3)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: Text('See all ${courses.length} courses'),
                  style: TextButton.styleFrom(foregroundColor: ThemeColors.primary),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _enrolledCourseCard(EnrolledCourse course, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CoursePlayerScreen(courseId: course.courseId)),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ThemeColors.primary, Color(0xFFE65100)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.courseTitle,
                            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(course.instructorName.isNotEmpty ? course.instructorName : 'EduAf',
                            style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: course.isCompleted
                          ? Colors.green.shade50
                          : ThemeColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${course.progressPercent}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: course.isCompleted ? Colors.green : ThemeColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: course.progress,
                  minHeight: 6,
                  color: course.isCompleted ? Colors.green : ThemeColors.primary,
                  backgroundColor: ThemeColors.primary.withValues(alpha: 0.12),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${course.completedLessons.length} / ${course.totalLessons} lessons',
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                  ),
                  Text(
                    course.isCompleted ? AppMessages.completedCheck.tr : AppMessages.continueBtn.tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: course.isCompleted ? Colors.green : ThemeColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(TextTheme textTheme) {
    final data = _chartData;
    if (data.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your average quiz score per topic', style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade500)),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: SfCartesianChart(
                margin: EdgeInsets.zero,
                plotAreaBorderWidth: 0,
                primaryXAxis: const CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0),
                  labelStyle: TextStyle(fontSize: 10),
                ),
                primaryYAxis: const NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 25,
                  labelFormat: '{value}%',
                  labelStyle: TextStyle(fontSize: 10),
                  majorGridLines: MajorGridLines(width: 0.5, dashArray: [4, 4]),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<_ChartEntry, String>(
                    dataSource: data,
                    xValueMapper: (d, _) => d.label,
                    yValueMapper: (d, _) => d.score,
                    color: ThemeColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(Icons.explore_rounded, AppMessages.exploreTab.tr, 'Browse courses', 1, const Color(0xFF6C63FF)),
      _QuickAction(Icons.quiz_rounded, AppMessages.quizzes.tr, 'Test yourself', 2, const Color(0xFF00B4D8)),
      _QuickAction(Icons.style_rounded, AppMessages.flashcards.tr, 'Review notes', 2, const Color(0xFF06D6A0)),
      _QuickAction(Icons.leaderboard_rounded, AppMessages.ranking.tr, 'Top students', 2, const Color(0xFFFFB703)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.4,
        children: actions.map((a) => _quickActionTile(a)).toList(),
      ),
    );
  }

  Widget _quickActionTile(_QuickAction action) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => widget.onNavigate(action.tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: action.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: action.color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(action.icon, color: action.color, size: 22),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(action.label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ThemeColors.black)),
                Text(action.sublabel, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartEntry {
  final String label;
  final double score;
  const _ChartEntry({required this.label, required this.score});
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String sublabel;
  final int tabIndex;
  final Color color;
  const _QuickAction(this.icon, this.label, this.sublabel, this.tabIndex, this.color);
}
