import 'package:education_app/features/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard/dashboard_screen.dart';
import 'features/login_screen.dart';
import 'teacher/screens/teacher_dashboard_screen.dart';
import 'teacher/screens/academy_dashboard_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            if (user == null) {
              return LoginScreen();
            }

            // Get user role from Firestore
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (userSnapshot.hasError || !userSnapshot.hasData) {
                  return DashboardScreen(); // Default to student dashboard
                }

                final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                final position = userData?['position'] ?? 'student';

                // Route based on user role
                if (position == 'academy') {
                  return const AcademyDashboardScreen();
                } else if (position == 'teacher' || position == 'admin') {
                  return TeacherDashboardScreen();
                } else {
                  return DashboardScreen();
                }
              },
            );
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
