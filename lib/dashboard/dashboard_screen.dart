import 'package:flutter/material.dart';
import 'package:education_app/dashboard/student_activity_widget.dart';
import 'package:education_app/dashboard/top_students_widget.dart';
import 'package:education_app/dashboard/course_card.dart';
import '../courses/course_model.dart';
import 'chartdata.dart';
import 'package:education_app/core/constants/theme.dart';

class DashboardHome extends StatelessWidget {
  static String id = 'dashboard_home';
  final List<StudentModel>? topStudents;

  const DashboardHome({
    super.key,
    this.topStudents,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: ThemeColors.primary,
              child: const Text("M"),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Welcome back 👋",
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              "Let’s continue learning today",
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            // 📊 QUICK STATS ROW (PRO STYLE)
            Row(
              children: [
                _miniCard(
                  context,
                  icon: Icons.play_circle_fill,
                  title: "Courses",
                  value: "12",
                ),
                const SizedBox(width: 10),
                _miniCard(
                  context,
                  icon: Icons.access_time,
                  title: "Hours",
                  value: "48h",
                ),
                const SizedBox(width: 10),
                _miniCard(
                  context,
                  icon: Icons.emoji_events,
                  title: "Score",
                  value: "89%",
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text("Featured Course", style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),

            CourseCard(
              course: CourseModel(
                id: 'flutter_course',
                title: "Flutter Development",
                teacher: "Anne",
                progress: "60% Complete",
                image: "assets/image/flutter.png",
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Activity Overview",
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  StudentActivityChartWidget(
                    chartData: chartData,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),


            Text("Top Students", style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),

            TopStudentsWidget(
              students: topStudents ?? [],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _miniCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: ThemeColors.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}