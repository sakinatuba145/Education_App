import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../core/I18n/messages.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        title:  Text(AppMessages.aboutUs.tr),
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
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: ThemeColors.primary,
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 44),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'EduAf',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: ThemeColors.black),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                AppMessages.start.tr,
                style: TextStyle(fontSize: 14, color: ThemeColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 28),
            _sectionCard(
              title: AppMessages.whoWeAre.tr,
              body:
               AppMessages.weAre.tr,
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: AppMessages.whatWe.tr,
              body: AppMessages.whatWeBody1.tr
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: AppMessages.ourMission.tr,
              body: AppMessages.whatWeBody.tr
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.gradient2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ThemeColors.black)),
          const SizedBox(height: 10),
          Text(body, style: TextStyle(fontSize: 14, height: 1.5, color: ThemeColors.black.withValues(alpha: 0.85))),
        ],
      ),
    );
  }
}
