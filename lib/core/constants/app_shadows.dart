import 'package:flutter/material.dart';

/// Premium shadow system following Material Design 3 elevation principles
/// Use these shadows for consistent depth throughout the app
class AppShadows {
  // =============== ELEVATION SHADOWS ===============
  // Material Design 3 elevation-based shadows

  // No shadow - flat surface
  static const List<BoxShadow> shadow0 = [];

  // Elevation 1 - Subtle depth for light layers
  static const List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Color(0x1F000000), // 12% opacity black
      blurRadius: 1,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  // Elevation 2 - Cards and smaller components
  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color(0x14000000), // 8% opacity black
      blurRadius: 3,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x12000000), // 7% opacity black
      blurRadius: 2,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  // Elevation 4 - Elevated cards and buttons
  static const List<BoxShadow> shadow4 = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      blurRadius: 6,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity black
      blurRadius: 3,
      offset: Offset(0, 3),
      spreadRadius: 0,
    ),
  ];

  // Elevation 6 - Floating action buttons and menus
  static const List<BoxShadow> shadow6 = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      blurRadius: 8,
      offset: Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity black
      blurRadius: 5,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // Elevation 8 - Dialogs and important floating surfaces
  static const List<BoxShadow> shadow8 = [
    BoxShadow(
      color: Color(0x15000000), // 8% opacity black
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity black
      blurRadius: 4,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // Elevation 12 - Bottom sheets and prominent surfaces
  static const List<BoxShadow> shadow12 = [
    BoxShadow(
      color: Color(0x1F000000), // 12% opacity black
      blurRadius: 17,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x14000000), // 8% opacity black
      blurRadius: 8,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // Elevation 16 - Top-level surfaces like navigation drawers
  static const List<BoxShadow> shadow16 = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity black
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity black
      blurRadius: 10,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  // =============== COLORED SHADOWS (for brand highlights) ===============
  /// Creates a colored shadow effect for emphasis
  static List<BoxShadow> shadowPrimary({
    Color color = const Color(0xFFFF6B35),
    double opacity = 0.2,
  }) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Success colored shadow
  static List<BoxShadow> shadowSuccess({double opacity = 0.2}) => [
    BoxShadow(
      color: Color(0xFF4CAF50).withValues(alpha: opacity),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Error colored shadow
  static List<BoxShadow> shadowError({double opacity = 0.2}) => [
    BoxShadow(
      color: Color(0xFFF44336).withValues(alpha: opacity),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Warning colored shadow
  static List<BoxShadow> shadowWarning({double opacity = 0.2}) => [
    BoxShadow(
      color: Color(0xFFFFC107).withValues(alpha: opacity),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Info colored shadow
  static List<BoxShadow> shadowInfo({double opacity = 0.2}) => [
    BoxShadow(
      color: Color(0xFF2196F3).withValues(alpha: opacity),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  // =============== SPECIAL EFFECTS ===============

  /// Glow effect - for active/selected states
  static List<BoxShadow> shadowGlow({double opacity = 0.3}) => [
    BoxShadow(
      color: Color(0xFFFF6B35).withValues(alpha: opacity),
      blurRadius: 12,
      offset: const Offset(0, 0),
      spreadRadius: 2,
    ),
  ];

  /// Inset shadow - for pressed states
  static List<BoxShadow> shadowInset = [
    const BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Hover shadow - elevated state
  static List<BoxShadow> shadowHover = [
    const BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  /// Drag shadow - being dragged
  static List<BoxShadow> shadowDrag = [
    const BoxShadow(
      color: Color(0x26000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  /// Focus shadow - keyboard focus indicator
  static List<BoxShadow> shadowFocus = [
    BoxShadow(
      color: Color(0xFFFF6B35).withValues(alpha: 0.4),
      blurRadius: 8,
      offset: const Offset(0, 0),
      spreadRadius: 1,
    ),
  ];

  // =============== UTILS ===============

  /// Get shadow based on elevation value
  static List<BoxShadow> get(int elevation) {
    switch (elevation) {
      case 0:
        return shadow0;
      case 1:
        return shadow1;
      case 2:
        return shadow2;
      case 4:
        return shadow4;
      case 6:
        return shadow6;
      case 8:
        return shadow8;
      case 12:
        return shadow12;
      case 16:
        return shadow16;
      default:
        return shadow0;
    }
  }
}
