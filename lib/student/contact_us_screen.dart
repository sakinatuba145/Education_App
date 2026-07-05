import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.studioCream,
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
        backgroundColor: AppColors.studioCream,
        foregroundColor: AppColors.studioInk,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We'd love to hear from you",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.studioInk),
            ),
            const SizedBox(height: 6),
            Text(
              'Questions, feedback or suggestions? Reach out through any of the channels below.',
              style: TextStyle(fontSize: 14, color: AppColors.studioInk.withValues(alpha: 0.75)),
            ),
            const SizedBox(height: 24),
            _contactTile(icon: Icons.email_rounded, label: 'Email', value: 'support@eduaf.com'),
            const SizedBox(height: 14),
            _contactTile(icon: Icons.phone_rounded, label: 'Phone', value: '+93 70 000 0000'),
            const SizedBox(height: 14),
            _contactTile(icon: Icons.location_on_rounded, label: 'Address', value: 'Kabul, Afghanistan'),
            const SizedBox(height: 14),
            _contactTile(icon: Icons.schedule_rounded, label: 'Support hours', value: 'Sat - Thu, 9:00 - 17:00'),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.studioGoldLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.studioGoldDark),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'For account or course issues, please include your registered email so our team can help faster.',
                      style: TextStyle(fontSize: 13, color: AppColors.studioInk.withValues(alpha: 0.85)),
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
        color: AppColors.studioCreamDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.studioGold,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: AppColors.studioInk.withValues(alpha: 0.6))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.studioInk)),
            ],
          ),
        ],
      ),
    );
  }
}
