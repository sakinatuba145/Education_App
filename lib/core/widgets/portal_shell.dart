import 'package:flutter/material.dart';
import 'language_switcher_button.dart';

/// Wraps any portal screen (teacher or student) with a floating
/// language-switcher globe in the top-right corner.
/// Used for the teacher portal where we cannot modify lib/teacher/** files.
class PortalShell extends StatelessWidget {
  final Widget child;

  const PortalShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 12),
              child: const LanguageSwitcherButton(),
            ),
          ),
        ),
      ],
    );
  }
}
