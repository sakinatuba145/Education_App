import 'package:education_app/dashboard/sidebar.dart';
import 'package:education_app/dashboard/top_students_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/user_models.dart';
import '../core/I18n/messages.dart';
import 'appbar_actions.dart';
import 'dashboard_screen.dart';

class DashboardContent extends StatefulWidget {
  static String id='dashboard_content';
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

  List<Widget> get pages => [
     Center(child: Text(AppMessages.dashboard.tr)),
     Center(child: Text(AppMessages.myLearning.tr)),
     Center(child: Text(AppMessages.courseCatalog.tr)),
     Center(child: Text(AppMessages.trophies.tr)),
     Center(child: Text(AppMessages.setting.tr)),
     Center(child: Text(AppMessages.aboutUs.tr)),
     Center(child: Text(AppMessages.contactUs.tr)),
     Center(child: Text(AppMessages.signOut.tr)),
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
        backgroundColor: Color(0xFFFFCC80),
        title: Text(AppMessages.learningDashboard.tr),
        actions: appBarActions.map((item) {
          if (item.icon == Icons.language) {
            return PopupMenuButton<Locale>(
              tooltip: item.title,
              icon: Icon(Icons.language, color: Color(0xFFFFA726),),
              onSelected: (locale) {
                Get.updateLocale(locale);
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: Locale('en', 'US'),
                  child: Text('English'),
                ),
                PopupMenuItem(
                  value: Locale('fa', 'IR'),
                  child: Text('فارسی'),
                ),
              ],
            );
          }

          return IconButton(
            tooltip: item.title,
            icon: Icon(item.icon, color: Color(0xFFFFA726),),
            onPressed: () {
              // عملیات مربوط به نوتیفیکیشن
            },
          );
        }).toList(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFFF8F0), Color(0xffFFE0B2), Color(0xffFFD180)],
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

void _updateLocale(String localeCode) async {
  Get.updateLocale(Locale(localeCode));
  final shared = await SharedPreferences.getInstance();
  shared.setString('app_language-code', localeCode);
}