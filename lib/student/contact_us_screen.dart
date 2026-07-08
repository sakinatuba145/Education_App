import 'package:education_app/core/I18n/messages.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        title:  Text(AppMessages.contactUs.tr),
        centerTitle: true,
        backgroundColor: ThemeColors.background,
        foregroundColor: ThemeColors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              AppMessages.weLove.tr,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ThemeColors.black),
            ),
            const SizedBox(height: 6),
            Text(
              AppMessages.suggestion.tr,
              style: TextStyle(fontSize: 14, color: ThemeColors.black.withValues(alpha: 0.75)),
            ),
            const SizedBox(height: 24),
            _contactTile(icon: Icons.email_rounded, label: AppMessages.email.tr, value: 'support@eduaf.com'),
            const SizedBox(height: 14),
            _contactTile(icon: Icons.phone_rounded, label: AppMessages.phone.tr, value: '+93 70 000 0000'),
            const SizedBox(height: 14),
            _contactTile(icon: Icons.location_on_rounded, label: AppMessages.address.tr, value: AppMessages.kabul.tr),
            const SizedBox(height: 14),
            _contactTile(icon: Icons.schedule_rounded, label: AppMessages.supportHour.tr, value: 'Sat - Thu, 9:00 - 17:00'),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ThemeColors.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFE65100)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppMessages.courseIssue.tr,
                      style: TextStyle(fontSize: 13, color: ThemeColors.black.withValues(alpha: 0.85)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactTile({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.gradient2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ThemeColors.primary,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: ThemeColors.black.withValues(alpha: 0.6))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: ThemeColors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
