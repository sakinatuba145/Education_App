import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  // SAVE USER DATA

  Future<void> saveUser({

    required String uid,
    required String name,
    required String email,
    required String position,

  }) async {

    await firestore
        .collection('users')
        .doc(uid)
        .set({

      "uid": uid,
      "name": name,
      "email": email,
      "position": position,

      "createdAt":
      DateTime.now().toString(),
    });
  }

  // GET USER DATA

  Future<DocumentSnapshot> getUser(
      String uid) async {

    return await firestore
        .collection('users')
        .doc(uid)
        .get();
  }
}