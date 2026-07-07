import 'package:flutter/material.dart';

// DashboardHome — content shown inside the desktop sidebar layout.
// Mobile students use StudentHomeScreen via StudentPortalScreen instead.
class DashboardHome extends StatelessWidget {
  static String id = 'dashboard_home';

  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_rounded, size: 64, color: Color(0xFFFFA726)),
          SizedBox(height: 16),
          Text(
            'EduAf Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Open the app on your device for the full learning experience.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}