import 'package:firebase_auth/firebase_auth.dart';

class DashboardService {


  Future<int> getCoursesCount(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 12;
  }

  final User? user = FirebaseAuth.instance.currentUser;

  Future<int> getAssignmentsCount(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 5;
  }


  Future<int> getMessagesCount(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 3;
  }

  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      "name": "Sakina",
      "role": "Student",
    };
  }
}