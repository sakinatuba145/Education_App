import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../I18n/messages.dart';


class NoCertificate extends StatelessWidget {
  const NoCertificate({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                width: 2,
              ),
              color: const Color(0xFFD4AF37).withValues(alpha: 0.07),
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              size: 52,
              color: Color(0xFFD4AF37),
            ),
          ),

          const SizedBox(height: 28),

          Text(
            AppMessages.noCertificate.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              AppMessages.finalProjectCertificate.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}