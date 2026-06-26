import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Encode role in displayName as "Name|role" so auth works even if Firestore fails
  String _encodeName(String name, String role) => '$name|$role';

  String _parseRole(User user) {
    final dn = user.displayName ?? '';
    if (dn.contains('|')) return dn.split('|').last;
    return 'student';
  }

  String _parseName(User user) {
    final dn = user.displayName ?? '';
    if (dn.contains('|')) return dn.split('|').first;
    return dn;
  }

  Future<Map<String, dynamic>?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) return null;

    // Try Firestore first, fall back to displayName-encoded role
    String role = _parseRole(user);
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['role'] != null) {
        role = doc.data()!['role'];
      }
    } catch (_) {
      // Firestore unavailable or rules deny — use displayName fallback
    }

    return {'user': user, 'role': role};
  }

  Future<User?> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) return null;

    // Store name AND role in displayName as "Name|role" — always works
    await user.updateDisplayName(_encodeName(name, role));

    // Also try to write to Firestore — non-critical, catch any errors
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Firestore write failed (rules may not allow it) — displayName is the fallback
    }

    return user;
  }

  Future<String> getUserRole(String uid) async {
    // Try Firestore first
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data()?['role'] != null) {
        return doc.data()!['role'];
      }
    } catch (_) {}

    // Fall back to displayName
    final user = _auth.currentUser;
    if (user != null) return _parseRole(user);
    return 'student';
  }

  String getDisplayName(User user) => _parseName(user);

  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'role': 'student',
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      } catch (_) {}
    }

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
