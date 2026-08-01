import 'package:flutter/material.dart';
import 'language_switcher_button.dart';

/// Wraps any portal screen (teacher or student) with a floating
/// language-switcher globe in the top-right corner.
/// Used for the teacher portal where we cannot modify lib/teacher/** files.
class PortalShell extends StatelessWidget {
  final Widget child;
  final bool showLanguage;

  const PortalShell({
    super.key,
    required this.child,
    this.showLanguage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        if (showLanguage)
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
