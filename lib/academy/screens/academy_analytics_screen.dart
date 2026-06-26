import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    ]);
    setState(() {
      _stats = results[0] as AcademyStats;
      final courses = results[1] as List<CourseModel>;
      _topCourses = courses
        ..sort((a, b) => b.totalEnrolled.compareTo(a.totalEnrolled));
      _topCourses = _topCourses.take(5).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primary = Theme.of(context).colorScheme.primary;

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
                    Text('Academy Overview', style: textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _statCard(
                          context,
                          Icons.people,
                          '${_stats?.totalTeachers ?? 0}',
                          'Teachers',
                          Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        _statCard(
                          context,
                          Icons.school,
                          '${_stats?.totalStudents ?? 0}',
                          'Students',
                          Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _statCard(
                          context,
                          Icons.menu_book,
                          '${_stats?.totalCourses ?? 0}',
                          'Courses',
                          Colors.purple,
                        ),
                        const SizedBox(width: 10),
                        _statCard(
                          context,
                          Icons.attach_money,
                          '\$${(_stats?.totalRevenue ?? 0).toStringAsFixed(0)}',
                          'Revenue',
                          Colors.teal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Top Performing Courses',
                        style: textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    if (_topCourses.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(Icons.bar_chart,
                                  size: 60, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text('No courses yet',
                                  style: textTheme.titleMedium
                                      ?.copyWith(color: Colors.grey[500])),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._topCourses.asMap().entries.map((e) {
                        final rank = e.key + 1;
                        final c = e.value;
                        final maxEnrolled = _topCourses.first.totalEnrolled;
                        final pct = maxEnrolled > 0
                            ? c.totalEnrolled / maxEnrolled
                            : 0.0;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: _rankColor(rank)
                                            .withValues(alpha: 0.15),
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
                                        style: textTheme.titleSmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '${c.totalEnrolled} students',
                                      style: textTheme.labelSmall
                                          ?.copyWith(color: primary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 6,
                                    backgroundColor:
                                        Colors.grey[200],
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _statCard(BuildContext context, IconData icon, String value,
      String label, Color color) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(value,
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: color)),
              Text(label,
                  style:
                      textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
            ],
          ),
        ),
      ),
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.grey;
    }
  }
}
