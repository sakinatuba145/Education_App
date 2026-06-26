import 'dart:math';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/academy/services/academy_service.dart';
import 'package:education_app/teacher/models/course_model.dart';

class AcademyAnalyticsScreen extends StatefulWidget {
  const AcademyAnalyticsScreen({super.key});

  @override
  State<AcademyAnalyticsScreen> createState() =>
      _AcademyAnalyticsScreenState();
}

class _AcademyAnalyticsScreenState extends State<AcademyAnalyticsScreen> {
  final AcademyService _service = AcademyService();
  AcademyStats? _stats;
  List<CourseModel> _topCourses = [];
  List<TrendPoint> _enrollTrend = [];
  List<TrendPoint> _revenueTrend = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _service.getAcademyStats(),
      _service.getAcademyCourses(),
      _service.getEnrollmentTrend(weeks: 8),
      _service.getRevenueTrend(weeks: 8),
    ]);

    if (mounted) {
      setState(() {
        _stats = results[0] as AcademyStats;
        final courses = results[1] as List<CourseModel>;
        final sorted = [...courses]
          ..sort((a, b) => b.totalEnrolled.compareTo(a.totalEnrolled));
        _topCourses = sorted.take(5).toList();
        _enrollTrend = results[2] as List<TrendPoint>;
        _revenueTrend = results[3] as List<TrendPoint>;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Summary stat cards ──────────────────────────────
                    Text('Overview',
                        style: textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _statCard(Icons.people, '${_stats?.totalTeachers ?? 0}',
                            'Teachers', Colors.blue),
                        const SizedBox(width: 10),
                        _statCard(Icons.school, '${_stats?.totalStudents ?? 0}',
                            'Students', Colors.green),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _statCard(Icons.menu_book,
                            '${_stats?.totalCourses ?? 0}', 'Courses',
                            Colors.purple),
                        const SizedBox(width: 10),
                        _statCard(
                          Icons.attach_money,
                          '\$${(_stats?.totalRevenue ?? 0).toStringAsFixed(0)}',
                          'Revenue',
                          Colors.teal,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Enrollment trend chart ──────────────────────────
                    _sectionHeader(
                      'New Enrollments',
                      'Last 8 weeks',
                      Icons.trending_up,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildBarChart(
                      points: _enrollTrend,
                      color: Colors.blue,
                      valueFormatter: (v) => v.toInt().toString(),
                      emptyLabel: 'No enrollment data yet',
                    ),

                    const SizedBox(height: 28),

                    // ── Revenue trend chart ─────────────────────────────
                    _sectionHeader(
                      'Revenue',
                      'Last 8 weeks (paid courses only)',
                      Icons.payments_outlined,
                      Colors.teal,
                    ),
                    const SizedBox(height: 12),
                    _buildBarChart(
                      points: _revenueTrend,
                      color: Colors.teal,
                      valueFormatter: (v) => '\$${v.toInt()}',
                      emptyLabel: 'No revenue data yet',
                    ),

                    const SizedBox(height: 28),

                    // ── Top courses ─────────────────────────────────────
                    _sectionHeader(
                      'Top Courses',
                      'By student enrollment',
                      Icons.emoji_events_outlined,
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    if (_topCourses.isEmpty)
                      _emptyState(Icons.bar_chart, 'No courses yet')
                    else
                      ..._topCourses.asMap().entries.map((e) {
                        final rank = e.key + 1;
                        final c = e.value;
                        final maxE = _topCourses.first.totalEnrolled;
                        final pct =
                            maxE > 0 ? c.totalEnrolled / maxE : 0.0;
                        return _topCourseCard(rank, c, pct);
                      }),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Section header ────────────────────────────────────────────────────
  Widget _sectionHeader(
      String title, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[500])),
          ],
        ),
      ],
    );
  }

  // ── Bar chart ─────────────────────────────────────────────────────────
  Widget _buildBarChart({
    required List<TrendPoint> points,
    required Color color,
    required String Function(double) valueFormatter,
    required String emptyLabel,
  }) {
    final hasData = points.any((p) => p.value > 0);

    if (!hasData) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 36, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text(emptyLabel,
                style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          ],
        ),
      );
    }

    final maxVal = points.map((p) => p.value).reduce(max);
    final total = points.fold(0.0, (s, p) => s + p.value);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${valueFormatter(total)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 13,
                ),
              ),
              Text(
                'Peak: ${valueFormatter(maxVal)}',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bar chart
          SizedBox(
            height: 110,
            child: CustomPaint(
              painter: _BarChartPainter(
                points: points,
                color: color,
                maxValue: maxVal,
              ),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 6),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(points.first.label,
                  style: const TextStyle(fontSize: 9, color: Colors.grey)),
              Text(points.last.label,
                  style: const TextStyle(fontSize: 9, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Top course card ────────────────────────────────────────────────────
  Widget _topCourseCard(int rank, CourseModel c, double pct) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _rankColor(rank).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#$rank',
                      style: TextStyle(
                        color: _rankColor(rank),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    c.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.people_outline,
                        size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      '${c.totalEnrolled}',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: Colors.grey[100],
                color: _rankColor(rank),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stat card ──────────────────────────────────────────────────────────
  Widget _statCard(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(IconData icon, String label) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(icon, size: 52, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text(label,
                style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFF9E9E9E);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return const Color(0xFF78909C);
    }
  }
}

// ── Custom bar chart painter ────────────────────────────────────────────────

class _BarChartPainter extends CustomPainter {
  final List<TrendPoint> points;
  final Color color;
  final double maxValue;

  const _BarChartPainter({
    required this.points,
    required this.color,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || maxValue == 0) return;

    final n = points.length;
    final slotW = size.width / n;
    final bW = slotW * 0.55;
    final bGap = slotW * 0.45;

    final basePaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    // Find the peak index
    final peakIdx =
        points.indexWhere((p) => p.value == maxValue);

    for (int i = 0; i < n; i++) {
      final x = i * slotW + bGap / 2;
      final fullH = size.height;
      final barH =
          (points[i].value / maxValue) * (fullH * 0.88);
      final y = fullH - barH;

      // Background track
      final bgRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 0, bW, fullH),
        const Radius.circular(4),
      );
      canvas.drawRRect(bgRRect, basePaint);

      // Filled bar
      if (barH > 0) {
        final paint = i == peakIdx ? highlightPaint : fillPaint;
        final barRRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, bW, barH),
          const Radius.circular(4),
        );
        canvas.drawRRect(barRRect, paint);

        // Value label on peak bar
        if (i == peakIdx && points[i].value > 0) {
          final textSpan = TextSpan(
            text: points[i].value % 1 == 0
                ? points[i].value.toInt().toString()
                : points[i].value.toStringAsFixed(0),
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          );
          final tp = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(
            canvas,
            Offset(
              x + bW / 2 - tp.width / 2,
              max(0, y - tp.height - 2),
            ),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.points != points || old.maxValue != maxValue;
}
