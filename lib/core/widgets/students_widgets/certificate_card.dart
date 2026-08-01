import 'package:education_app/core/widgets/students_widgets/signature_block.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../I18n/messages.dart';


class CertificateCard extends StatelessWidget {
  const CertificateCard({
    super.key,
    required this.studentName,
    required this.courseTitle,
    required this.certId,
    required this.dateStr,
  });

  final String studentName;
  final String courseTitle;
  final String certId;
  final String dateStr;


  @override
  Widget build(BuildContext context) {
    return Container(
      // تمام کد Container که قبلاً داخل
      // _buildCertificateCard()
      // قرار داشت
      child: Column(
        children: [

          /// تمام محتوای مدرک ...

          Row(
            children: [
              Expanded(
                child: SignatureBlock(
                  seed: studentName,
                  name: studentName,
                  role: AppMessages.student.tr,
                  nameColor: Colors.black,
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: SignatureBlock(
                  seed: 'EduAfAcademy',
                  name: 'EduAf Academy',
                  role: AppMessages.platformDirector.tr,
                  nameColor: const Color(0xFFFF6B35),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFD4AF37)
                      .withValues(alpha: 0.35),
                ),
              ),
            ),
            child: Text(
              '${AppMessages.certificateId.tr}: $certId   •   ${AppMessages.issuedBy.tr} EduAf   •   ${AppMessages.verifyAt.tr} eduaf.app',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8.5,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}