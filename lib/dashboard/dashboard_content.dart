import 'package:education_app/dashboard/sidebar.dart';
import 'package:education_app/dashboard/top_students_widget.dart';
import 'package:flutter/material.dart';
import '../auth/user_models.dart';
import '../core/constants/theme.dart';
import 'appbar_actions.dart';
import 'dashboard_screen.dart';

class DashboardContent extends StatefulWidget {
  static String id = 'dashboard_content';
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final currentUser = UserModel(
    position: "teacher/student",
    email: "email",
    uid: "uid",
    name: "Sakina",
    role: "Student",
    imageUrl: null,
  );

  int selectedIndex = 0;

  bool get isDesktop => MediaQuery.of(context).size.width >= 900;

  final List<StudentModel> allStudents = [
    StudentModel(
      name: "Ali",
      grade: "A",
      score: 95,
      image: "assets/images/flutter.png",
    ),
    StudentModel(
      name: "Sara",
      grade: "A+",
      score: 88,
      image: "assets/images/flutter.png",
    ),
  ];

  List<StudentModel> get topStudents =>
      allStudents.where((s) => s.score >= 90).toList();

  final List<Widget> pages = [
    const Center(child: Text("Dashboard")),
    const Center(child: Text("My Learning")),
    const Center(child: Text("Course Catalog")),
    const Center(child: Text("Trophies")),
    const Center(child: Text("Settings")),
    const Center(child: Text("About Us")),
    const Center(child: Text("Contact Us")),
    const Center(child: Text("Sign Out")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: isDesktop
          ? null
          : Drawer(
        child: Sidebar(
          user: currentUser,
          selectedIndex: selectedIndex,
          onItemSelected: (index) {
            setState(() => selectedIndex = index);
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5b400),
        title: const Text("Learning Dashboard"),
        actions: appBarActions.map((item) {
          return IconButton(
            tooltip: item.title,
            icon: Icon(item.icon),
            onPressed: () {},
          );
        }).toList(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeColors.gradient1,
              ThemeColors.gradient2,
              ThemeColors.gradient3,
              ThemeColors.gradient2,
            ],
          ),
        ),
        child: isDesktop
            ? Row(
          children: [
            Sidebar(
              user: currentUser,
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                setState(() => selectedIndex = index);
              },
            ),
            Expanded(
              child: selectedIndex == 0
                  ? DashboardHome(
                topStudents: topStudents,
              )
                  : pages[selectedIndex - 1],
            ),
          ],
        )
            : selectedIndex == 0
            ? DashboardHome(topStudents: topStudents)
            : pages[selectedIndex - 1],
      ),

    );
  }
}