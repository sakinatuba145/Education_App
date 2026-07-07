import 'package:education_app/dashboard/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/user_models.dart';
import '../core/I18n/messages.dart';
import 'appbar_actions.dart';
import 'dashboard_screen.dart';

// DashboardContent — desktop sidebar layout (used for web/tablet view)
// Mobile student portal uses StudentPortalScreen with bottom nav instead.
class DashboardContent extends StatefulWidget {
  static String id = 'dashboard_content';
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  int selectedIndex = 0;
  UserModel? currentUser;

  bool get isDesktop => MediaQuery.of(context).size.width >= 900;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // UserModel is constructed from FirebaseAuth in production
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser ??
        UserModel(
          position: 'student',
          email: '',
          uid: '',
          name: AppMessages.unknown.tr,
          imageUrl: null,
        );

    return Scaffold(
      drawer: isDesktop
          ? null
          : Drawer(
              child: Sidebar(
                user: user,
                selectedIndex: selectedIndex,
                onItemSelected: (index) {
                  Navigator.of(context).pop();
                  setState(() => selectedIndex = index);
                },
              ),
            ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFCC80),
        title: Text(AppMessages.learningDashboard.tr),
        actions: appBarActions.map((item) {
          if (item.icon == Icons.language) {
            return PopupMenuButton<Locale>(
              tooltip: item.title,
              icon: const Icon(Icons.language, color: Color(0xFFFFA726)),
              onSelected: (locale) async {
                Get.updateLocale(locale);
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('app_language-code', locale.languageCode);
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: Locale('en'), child: Text('English')),
                PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
                PopupMenuItem(value: Locale('fa'), child: Text('فارسی')),
                PopupMenuItem(value: Locale('hi'), child: Text('हिंदी')),
                PopupMenuItem(value: Locale('tr'), child: Text('Türkçe')),
                PopupMenuItem(value: Locale('ur'), child: Text('اردو')),
                PopupMenuItem(value: Locale('ps'), child: Text('پښتو')),
              ],
            );
          }
          return IconButton(
            tooltip: item.title,
            icon: Icon(item.icon, color: const Color(0xFFFFA726)),
            onPressed: () {},
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
                    user: user,
                    selectedIndex: selectedIndex,
                    onItemSelected: (i) => setState(() => selectedIndex = i),
                  ),
                  Expanded(child: DashboardHome()),
                ],
              )
            : DashboardHome(),
      ),
    );
  }
}

void _updateLocale(String localeCode) async {
  Get.updateLocale(Locale(localeCode));
  final shared = await SharedPreferences.getInstance();
  shared.setString('app_language-code', localeCode);
}
