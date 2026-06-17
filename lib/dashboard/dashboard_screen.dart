import 'package:education_app/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../quiz/quiz_screen.dart';
import 'dashboard_services.dart';

class DashboardScreen extends StatefulWidget {
  static String id = 'dashboard_screen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService service = DashboardService();
  int selectedIndex = 0;
  int courses = 0;
  int assignments = 0;
  int messages = 0;
  int quiz = 0;

  bool isLoading = true;

  String name = "";
  String role = "";

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final userId = "userId123";
    // یا از FirebaseAuth
    final c = await service.getCoursesCount(userId);
    final a = await service.getAssignmentsCount(userId);
    final m = await service.getMessagesCount(userId);
    final user = await service.getUserInfo(userId);
    setState(() {
      courses = c;
      assignments = a;
      messages = m;

      name = user['name'];
      role = user['role'];

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9E9E9E),
        title: Text("Dashboard"),
        centerTitle: true,
        actions: [
          Switch(
            value: themeProvider.isDark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("User@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              decoration: BoxDecoration(color: Color(0xFF9E9E9E)),
            ),
            ListTile(),
          ],
        ),
      ),
      body: Row(
        children: [
          // ================= SIDEBAR =================
          Container(
            width: 260,
            color: Color(0xFF9E9E9E),
            child: Column(
              children: [
                 SizedBox(height: 50),
                // 👤 Profile
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40),
                ),

                const SizedBox(height: 10),
                const Text(
                  "User Name",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 30),
                // 📚 Menu Items
                sidebarItem(
                  icon: Icons.dashboard,
                  title: "Dashboard",
                  index: 0,
                ),

                sidebarItem(icon: Icons.quiz, title: "Quiz", index: 1),
                sidebarItem(icon: Icons.settings, title: "Settings", index: 2),
                sidebarItem(icon: Icons.logout, title: "Logout", index: 3),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: getPage(),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Sidebar item
  Widget sidebarItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, QuizScreen.id);
          },
          child: const Text("Register"),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // 🔹 صفحات داخلی
  Widget getPage() {
    switch (selectedIndex) {
      case 0:
        return const Center(child: Text("Dashboard Home"));

      case 2:
        return const Center(child: Text("Settings Page"));

      case 3:
        return const Center(child: Text("Logout"));

      default:
        return const Center(child: Text("Page"));
    }
  }
}
