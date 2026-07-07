import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  Future login(String username, String password) async {
    final response = await ApiService.dio.post(
      'auth/login',
      data: {'username': username, 'password': password},
    );

    String token = response.data['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    return response.data;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
