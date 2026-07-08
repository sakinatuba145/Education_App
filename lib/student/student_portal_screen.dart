import 'package:flutter/material.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:education_app/core/widgets/language_switcher_button.dart';
import 'package:education_app/student/student_home_screen.dart';
import 'package:education_app/courses/course_discovery_screen_premium.dart';
import 'package:education_app/student/student_learn_hub_screen.dart';
import 'package:education_app/profile/profile_screen.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../core/I18n/messages.dart';

class StudentPortalScreen extends StatefulWidget {
  static const String id = 'student_portal';
  const StudentPortalScreen({super.key});

  @override
  State<StudentPortalScreen> createState() => _StudentPortalScreenState();
}

class _StudentPortalScreenState extends State<StudentPortalScreen> {
  int _selectedIndex = 0;

  void _navigateTo(int index) {
    setState(() => _selectedIndex = index);
  }

  List<Widget> get _pages => [
    StudentHomeScreen(onNavigate: _navigateTo),
    const CourseDiscoveryScreenPremium(),
    const StudentLearnHubScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_selectedIndex != 0) setState(() => _selectedIndex = 0);
      },
      child: Scaffold(
        backgroundColor: ThemeColors.background,
        body: Stack(
          children: [
            // ─── Page content ───
            IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),

            // ─── Language switcher (top-right) ───
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 12),
                  child: const LanguageSwitcherButton(),
                ),
              ),
            ),

            // ─── Floating premium bottom nav ───
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: _PremiumBottomNav(
                selectedIndex: _selectedIndex,
                onTap: (i) => setState(() => _selectedIndex = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Premium Floating Navigation Bar ──────────────────────────────────────────

class _PremiumBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _PremiumBottomNav({
    required this.selectedIndex,
    required this.onTap,
  });

  static  final _items = [
    (Icons.home_outlined, Icons.home_rounded, AppMessages.home.tr),
    (Icons.explore_outlined, Icons.explore_rounded, AppMessages.explore.tr),
    (Icons.school_outlined, Icons.school_rounded, AppMessages.learn.tr),
    (Icons.person_outline_rounded, Icons.person_rounded, AppMessages.profile.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primary.withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final (outIcon, fillIcon, label) = _items[i];
          final active = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? ThemeColors.primary.withValues(alpha: 0.13)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      active ? fillIcon : outIcon,
                      key: ValueKey(active),
                      color: active ? ThemeColors.primary : Colors.grey.shade400,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      color: active ? ThemeColors.primary : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
