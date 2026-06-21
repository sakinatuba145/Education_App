import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Favorite Courses", style: textTheme.headlineMedium),
            const SizedBox(height: 20),

            _favoriteCourse(
              context,
              icon: Icons.flutter_dash,
              title: "Flutter Basics",
              subtitle: "Learn layouts, widgets, and UI design",
              lessons: "12 Lessons",
            ),

            _favoriteCourse(
              context,
              icon: Icons.code,
              title: "Dart OOP",
              subtitle: "Classes, objects, and clean code",
              lessons: "10 Lessons",
            ),

            _favoriteCourse(
              context,
              icon: Icons.quiz,
              title: "Quiz App",
              subtitle: "Build interactive quiz screens",
              lessons: "8 Lessons",
            ),

            const SizedBox(height: 20),

            Text("Saved For Later", style: textTheme.titleLarge),
            const SizedBox(height: 12),

            _savedItem(
              context,
              title: "Stateful Widgets",
              subtitle: "Continue this topic later",
            ),

            _savedItem(
              context,
              title: "Navigation",
              subtitle: "Practice screen routing",
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteCourse(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required String lessons,
      }) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: primary.withOpacity(0.15),
              child: Icon(icon, color: primary),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(lessons, style: textTheme.bodySmall),
                ],
              ),
            ),

            Icon(Icons.favorite, color: primary),
          ],
        ),
      ),
    );
  }

  Widget _savedItem(
      BuildContext context, {
        required String title,
        required String subtitle,
      }) {
    final primary = Theme.of(context).colorScheme.primary;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        leading: Icon(Icons.bookmark, color: primary),
        title: Text(title, style: textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}