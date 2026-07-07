import 'package:education_app/chartbar/student_services.dart';
import 'package:get/get.dart';
import 'chartdata.dart';

class StudentController extends GetxController {
  final StudentService _service = StudentService();
  String studentId = 'alpha';
  var chartData = <ChartColumnData>[].obs;

  void loadStudent(String studentId) {
    _service.getStudentSubjects(studentId).listen((data) {
      chartData.value = data;
    });
  }
}