import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'student_controller.dart';
import 'student_activity_widget.dart';

class StudentActivityScreen extends StatelessWidget {
  static String id = 'student_activity_screen';
  final String studentId;

  StudentActivityScreen({
    super.key,
    required this.studentId,
  });

  final StudentController controller = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    controller.loadStudent(studentId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Activity"),
        backgroundColor: const Color(0xFFFFCC80),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFFF8F0),
              Color(0xffFFE0B2),
              Color(0xffFFD180),
            ],
          ),
        ),

        child: Center(
          child: Obx(() {

            if (controller.chartData.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("No subjects yet..."),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: StudentActivityChartWidget(
                chartData: controller.chartData,
              ),
            );
          }),
        ),
      ),
    );
  }
}