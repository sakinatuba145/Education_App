import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:education_app/core/I18n/messages.dart';
import 'package:education_app/core/widgets/wave_header.dart';
import 'package:education_app/core/widgets/glass_card.dart';
import 'package:education_app/core/widgets/section_heading.dart';
import 'package:education_app/student/enrollment_service.dart';
import 'package:education_app/student/progress_service.dart';
import 'package:education_app/student/course_player_screen.dart';

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
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: RefreshIndicator(
        color: ThemeColors.primary,
        onRefresh: _loadStats,
        child: CustomScrollView(
          slivers: [
            // ─── Wave Header ───────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildWaveHeader()),

            // ─── Stats Row ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _buildStatsRow(),
              ),
            ),

            // ─── Continue Learning ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: SectionHeading(
                title: AppMessages.continueLearning.tr,
                actionLabel: 'See All',
                onAction: () => widget.onNavigate(1),
              ),
            ),
            SliverToBoxAdapter(child: _buildContinueLearning()),

            // ─── Quiz Performance Chart ────────────────────────────────────
            if (_quizResults.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeading(title: AppMessages.quizPerformance.tr),
              ),
              SliverToBoxAdapter(child: _buildChart()),
            ],

            // ─── Quick Actions ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: SectionHeading(title: AppMessages.quickActions.tr),
            ),
            SliverToBoxAdapter(child: _buildQuickActions()),

            // Bottom padding for floating nav
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // ── Wave Header ────────────────────────────────────────────────────────────

  Widget _buildWaveHeader() {
    return WaveHeader(
      waveHeight: 56,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 70, 70),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'EduAf',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.90),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '$_greeting 👋',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppMessages.readyToLearn.tr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => widget.onNavigate(3),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.22),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    if (_statsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(color: ThemeColors.primary)),
      );
    }
    final stats = _stats;
    return Row(
      children: [
        _premiumStatCard(
          Icons.menu_book_rounded,
          '${stats?.enrolledCourses ?? 0}',
          AppMessages.enrolled.tr,
        ),
        const SizedBox(width: 12),
        _premiumStatCard(
          Icons.quiz_rounded,
          '${stats?.quizzesTaken ?? 0}',
          AppMessages.quizzes.tr,
        ),
        const SizedBox(width: 12),
        _premiumStatCard(
          Icons.trending_up_rounded,
          '${stats?.avgProgressPercent ?? 0}%',
          AppMessages.avgProgress.tr,
        ),
      ],
    );
  }

  Widget _premiumStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ThemeColors.primary, Color(0xFFE65100)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Continue Learning ──────────────────────────────────────────────────────

  Widget _buildContinueLearning() {
    return StreamBuilder<List<EnrolledCourse>>(
      stream: _enrollment.streamMyEnrollments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator(color: ThemeColors.primary)),
          );
        }

        final courses = snapshot.data ?? [];

        if (courses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassCard(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: ThemeColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school_outlined, size: 40, color: ThemeColors.primary.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    AppMessages.noCoursesYet.tr,
                    style: const TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppMessages.exploreToStart.tr,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () => widget.onNavigate(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [ThemeColors.primary, Color(0xFFE65100)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeColors.primary.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.explore_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            AppMessages.exploreCourses.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Horizontal scroll cards
        return SizedBox(
          height: 158,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: courses.length,
            itemBuilder: (_, i) => _horizontalCourseCard(courses[i]),
          ),
        );
      },
    );
  }

  Widget _horizontalCourseCard(EnrolledCourse course) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CoursePlayerScreen(courseId: course.courseId)),
      ),
      child: Container(
        width: 220,
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
                    child: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                        color: course.isCompleted ? Colors.green.shade700 : ThemeColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                course.courseTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFF1A1A1A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                course.instructorName.isNotEmpty ? course.instructorName : 'EduAf',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: course.progress,
                  minHeight: 5,
                  color: course.isCompleted ? Colors.green : ThemeColors.primary,
                  backgroundColor: ThemeColors.primary.withValues(alpha: 0.10),
                ),
              ),
              const SizedBox(height: 5),
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

  // ── Chart ──────────────────────────────────────────────────────────────────

  Widget _buildChart() {
    final data = _chartData;
    if (data.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [ThemeColors.primary, Color(0xFFE65100)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 10),
                Text(
                  AppMessages.quizScore.tr,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 14),
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

  // ── Quick Actions ──────────────────────────────────────────────────────────

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(Icons.explore_rounded, AppMessages.exploreTab.tr, 'Browse courses', 1, const Color(0xFF6C63FF)),
      _QuickAction(Icons.quiz_rounded, AppMessages.quizzes.tr, 'Test yourself', 2, const Color(0xFF00B4D8)),
      _QuickAction(Icons.style_rounded, AppMessages.flashcards.tr, 'Review cards', 2, const Color(0xFF06D6A0)),
      _QuickAction(Icons.leaderboard_rounded, AppMessages.ranking.tr, 'Top students', 2, const Color(0xFFFFB703)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.3,
        children: actions.map(_quickActionTile).toList(),
      ),
    );
  }

  Widget _quickActionTile(_QuickAction action) {
    return GestureDetector(
      onTap: () => widget.onNavigate(action.tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: action.color.withValues(alpha: 0.20)),
          boxShadow: [
            BoxShadow(
              color: action.color.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(action.icon, color: action.color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    action.label,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF1A1A1A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    action.sublabel,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
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
