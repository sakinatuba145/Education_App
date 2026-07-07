import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:education_app/student/my_courses_screen.dart';
import 'package:education_app/courses/course_discovery_screen_premium.dart';
import 'package:education_app/student/student_learn_hub_screen.dart';
import 'package:education_app/profile/profile_screen.dart';

class StudentPortalScreen extends StatefulWidget {
  static const String id = 'student_portal';
  const StudentPortalScreen({super.key});

  @override
  State<StudentPortalScreen> createState() => _StudentPortalScreenState();
}

class _StudentPortalScreenState extends State<StudentPortalScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    MyCoursesScreen(),
    CourseDiscoveryScreenPremium(),
    StudentLearnHubScreen(),
    ProfileScreen(),
  ];

  static const List<String> _titles = [
    'My Courses',
    'Explore',
    'Learn',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final isLearn = _selectedIndex == 2;

    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: isLearn
          ? null
          : AppBar(
              title: Text(_titles[_selectedIndex]),
              automaticallyImplyLeading: false,
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: ThemeColors.primary.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
