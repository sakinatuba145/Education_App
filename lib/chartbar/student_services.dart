import 'package:cloud_firestore/cloud_firestore.dart';
import 'chartdata.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChartColumnData>> getStudentSubjects(String studentId) {
    return _firestore
        .collection('students')
        .doc(studentId)
        .collection('subjects')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChartColumnData.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }
}