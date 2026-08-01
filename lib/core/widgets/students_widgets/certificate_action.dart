import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../I18n/messages.dart';

class CertificateActions extends StatelessWidget {
  const CertificateActions({
    super.key,
    required this.certificateId,
  });

  final String certificateId;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
      child: Column(
        children: [
          Text(
            'Certificate ID: $certificateId',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),

              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF0D1B3E),

                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: const Icon(
                Icons.check_circle_rounded,
              ),

              label: Text(
                AppMessages.done.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}