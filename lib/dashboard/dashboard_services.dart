import 'package:firebase_auth/firebase_auth.dart';

class DashboardService {

  // گرفتن تعداد کورس‌ها (فعلاً dummy)
  Future<int> getCoursesCount(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 12;
  }
  //get Profile Information of user----1
  final User? user = FirebaseAuth.instance.currentUser;

  // گرفتن تعداد assignment ها
  Future<int> getAssignmentsCount(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 5;
  }

  // گرفتن پیام‌ها
  Future<int> getMessagesCount(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return 3;
  }

  // اطلاعات کاربر (بعداً Firebase می‌شود)
  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      "name": "Sakina",
      "role": "Student",
    };
  }
}