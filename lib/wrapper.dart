import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:education_app/dashboard/dashboard_screen.dart';
import 'features/login_screen.dart';
import 'teacher/screens/teacher_dashboard_screen.dart';
class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final user = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, roleSnap) {

            if (roleSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!roleSnap.hasData || !roleSnap.data!.exists) {
              return DashboardHome();
            }

            final data =
            roleSnap.data!.data() as Map<String, dynamic>;

            final role = data['role'] ?? 'student';

            if (role == 'teacher' || role == 'admin') {
              return TeacherDashboardScreen();
            }

            return DashboardHome();
          },
        );
      },
    );
  }
}