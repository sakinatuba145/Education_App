import 'package:education_app/student/student_portal_screen.dart';
import 'package:education_app/features/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'teacher/screens/teacher_dashboard_screen.dart';

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
                  return const StudentPortalScreen();
                }

                final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                // Check both 'role' and 'position' fields — seed accounts use 'position',
                // registered accounts use 'role'
                final position =
                    userData?['role'] ?? userData?['position'] ?? 'student';

                // Route based on user role
                if (position == 'teacher' || position == 'admin') {
                  return TeacherDashboardScreen();
                } else {
                  return const StudentPortalScreen();
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
