import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Progress"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Learning Overview", style: textTheme.headlineMedium),
            const SizedBox(height: 20),

            Row(
              children: [
                _summaryCard(context, Icons.menu_book, "3", "Courses"),
                const SizedBox(width: 10),
                _summaryCard(context, Icons.quiz, "5", "Quizzes"),
              ],
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Overall Progress", style: textTheme.titleLarge),
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: 0.7,
                      minHeight: 12,
                      color: primary,
                      backgroundColor: primary.withOpacity(0.2),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "70% completed",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text("Courses Progress", style: textTheme.titleLarge),
            const SizedBox(height: 12),

            _courseProgress(
              context,
              title: "Flutter Basics",
              subtitle: "Layout and widgets",
              value: 0.8,
              percent: "80%",
            ),

            _courseProgress(
              context,
              title: "Dart OOP",
              subtitle: "Classes and objects",
              value: 0.6,
              percent: "60%",
            ),

            _courseProgress(
              context,
              title: "Quiz App",
              subtitle: "User interaction",
              value: 0.7,
              percent: "70%",
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(
      BuildContext context,
      IconData icon,
      String number,
      String label,
      ) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, color: primary),
              const SizedBox(height: 8),
              Text(number, style: textTheme.headlineMedium),
              Text(label, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _courseProgress(
      BuildContext context, {
        required String title,
        required String subtitle,
        required double value,
        required String percent,
      }) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.school, color: primary),
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: Text(percent, style: textTheme.bodyLarge),
            ),
            LinearProgressIndicator(
              value: value,
              minHeight: 8,
              color: primary,
              backgroundColor: primary.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}