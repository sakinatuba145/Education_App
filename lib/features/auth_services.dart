import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _encodeName(String name, String role) => '$name|$role';

  /// Returns the role stored in displayName (null if never explicitly set).
  String? _roleFromDisplayName(User user) {
    final dn = user.displayName ?? '';
    if (dn.contains('|')) return dn.split('|').last;
    return null; // never explicitly set
  }

  String _nameFromDisplayName(User user) {
    final dn = user.displayName ?? '';
    if (dn.contains('|')) return dn.split('|').first;
    return dn;
  }

  /// Login and return the stored role + whether it was explicitly stored.
  /// {role: String, roleIsExplicit: bool, user: User}
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

    String? role;
    bool roleIsExplicit = false;

    // 1. Try Firestore first (most reliable)
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['role'] != null) {
        role = doc.data()!['role'] as String;
        roleIsExplicit = true;
      }
    } catch (_) {}

    // 2. Fall back to displayName encoding
    if (role == null) {
      final dnRole = _roleFromDisplayName(user);
      if (dnRole != null) {
        role = dnRole;
        roleIsExplicit = true;
      }
    }

    // 3. No role ever stored for this account
    if (role == null) {
      roleIsExplicit = false;
      role = 'unknown';
    }

    return {
      'user': user,
      'role': role,
      'roleIsExplicit': roleIsExplicit,
    };
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

    // Store name + role in displayName — always works regardless of Firestore rules
    await user.updateDisplayName(_encodeName(name, role));

    // Also write to Firestore (non-critical)
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'role': role,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {}

    return user;
  }

  /// Save a role for the first time (only for old accounts that have no stored role).
  Future<void> saveRoleFirstTime(String role) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final name = _nameFromDisplayName(user).isNotEmpty
        ? _nameFromDisplayName(user)
        : (user.displayName ?? 'User');

    await user.updateDisplayName(_encodeName(name, role));

    try {
      await _firestore.collection('users').doc(user.uid).set(
        {'role': role, 'name': name, 'email': user.email},
        SetOptions(merge: true),
      );
    } catch (_) {}
  }

  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data()?['role'] != null) {
        return doc.data()!['role'];
      }
    } catch (_) {}

    final user = _auth.currentUser;
    if (user != null) {
      final dnRole = _roleFromDisplayName(user);
      if (dnRole != null) return dnRole;
    }
    return 'student';
  }

  String getDisplayName(User user) => _nameFromDisplayName(user);

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
