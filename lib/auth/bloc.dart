import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN

  Future<bool> login({
    required String username,
    required String password,
    required String email,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (username == "admin" && password == "1234") {
      return true;
    }

    return false;
  }

  // REGISTER (FIXED)

  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required String position,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
