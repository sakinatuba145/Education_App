import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../core/I18n/messages.dart';

class StudentActivity extends StatelessWidget {
  static String id = 'student_activity';
  const StudentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffFFE0B2).withValues(alpha: 0.15),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(

        ),
      ),
    );
  }
}
