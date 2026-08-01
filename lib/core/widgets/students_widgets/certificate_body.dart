import 'package:flutter/material.dart';
import 'certificate_action.dart';
import 'certificate_card.dart';

class CertificateBody extends StatelessWidget {
  const CertificateBody({
    super.key,
    required this.animation,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.studentName,
    required this.courseTitle,
    required this.certId,
    required this.dateStr,
    required this.certificateId,
  });

  final Animation<double> animation;
  final Animation<double> fadeAnimation;
  final Animation<double> slideAnimation;

  final String studentName;
  final String courseTitle;
  final String certId;
  final String dateStr;
  final String certificateId;



  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, slideAnimation.value),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: CertificateCard(
                  studentName: studentName,
                  courseTitle: courseTitle,
                  certId: certId,
                  dateStr: dateStr,

                ),
              ),
            ),
          ),
          CertificateActions(
            certificateId: certificateId,
          ),
        ],
      ),
    );
  }
}