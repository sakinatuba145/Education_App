import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<UserCredential> signInWithGoogle() async {
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  if (kIsWeb) {
    return await FirebaseAuth.instance.signInWithPopup(
      googleProvider,
    );
  } else {
    return await FirebaseAuth.instance.signInWithProvider(
      googleProvider,
    );
  }
}