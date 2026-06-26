import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

 /// 3.21 AUTH SERVICE
/// This class handles all authentication
///  Email/Password Login
///  User Registration
/// Google Sign-In
///  Logout
/// It also stores user data in Firestore (role based system)


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// LOGIN WITH EMAIL & PASSWORD
  /// Returns user role from Firestore after login
  Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    final credential =
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final doc = await _firestore
        .collection("users")
        .doc(uid)
        .get();

    return doc.data() ?? {"role": "student"};
  }

  /// REGISTER NEW USER
  /// 1. Creates Firebase Auth account
  /// 2. Saves user info in Firestore (name, role, email)
  Future<User?> register(
      String name,
      String email,
      String password,
      String role,
      ) async {
    final credential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    await user?.updateDisplayName(name);

    await _firestore
        .collection('users')
        .doc(user!.uid)
        .set({
      'name': name,
      'email': email,
      'role': role,
      'uid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  /// GOOGLE SIGN IN (FIXED + ROLE SAFE)
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser =
      await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) return null;

      final docRef =
      _firestore.collection("users").doc(user.uid);

      final doc = await docRef.get();

      /// If first time login → create user in Firestore
      if (!doc.exists) {
        await docRef.set({
          'name': user.displayName ?? "",
          'email': user.email,
          'role': "student",
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      throw Exception("Google Sign-In Failed: $e");
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}