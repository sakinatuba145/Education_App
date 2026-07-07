import 'package:flutter/material.dart';

/// Premium color system for Education App
/// Supports both light and dark themes with semantic color usage
class AppColors {
  // =============== PRIMARY PALETTE ===============
  // Vibrant orange - energetic and engaging
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8C42);
  static const Color primaryDark = Color(0xFFD84315);
  static const Color primarySubtle = Color(0xFFFFF4E6);

  // =============== SECONDARY PALETTE (ACCENTS) ===============
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFE082);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // =============== NEUTRAL PALETTE ===============
  static const Color dark = Color(0xFF1A1A1A);
  static const Color gray900 = Color(0xFF212121);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray200 = Color(0xFFF5F5F5);
  static const Color gray100 = Color(0xFFFAFAFA);
  static const Color light = Color(0xFFFFFFFF);

  // =============== SEMANTIC COLORS ===============
  // Light theme
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF1A1A1A);

  // Dark theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);

  // =============== UTILITY COLORS ===============
  static Color overlay(Color color, double opacity) =>
      color.withValues(alpha: opacity);

  static const Color overlay32 = Color(0x52000000); // 32% opacity black
  static const Color overlay20 = Color(0x33000000); // 20% opacity black
  static const Color overlay12 = Color(0x1F000000); // 12% opacity black
  static const Color overlay8 = Color(0x14000000);  // 8% opacity black

  // =============== STATUS SPECIFIC COLORS ===============
  static const Color completedGreen = Color(0xFF4CAF50);
  static const Color inProgressBlue = Color(0xFF2196F3);
  static const Color draftOrange = Color(0xFFFF9800);
  static const Color archivedGray = Color(0xFF9E9E9E);
  static const Color rejectedRed = Color(0xFFF44336);

  // =============== GRADIENT COLORS (as lists for LinearGradient) ===============
  static const List<Color> primaryGradient = [
    Color(0xFFFF6B35),
    Color(0xFFFF8C42),
  ];

  static const List<Color> successGradient = [
    Color(0xFF4CAF50),
    Color(0xFF81C784),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFFFC107),
    Color(0xFFFFE082),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFF44336),
    Color(0xFFEF5350),
  ];

  static const List<Color> infoGradient = [
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
  ];

  // =============== SHIMMER EFFECT COLORS ===============
  static const Color shimmerBase = Color(0xFFEBEBEB);
  static const Color shimmerHighlight = Color(0xFFFAFAFA);

  // =============== HELPER METHODS ===============

  /// Get text color based on background - for good contrast
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance
    final luminance = backgroundColor.computeLuminance();

    // Return black text for light backgrounds, white for dark
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// Get primary color variant based on theme brightness
  static Color getPrimaryForTheme(Brightness brightness) {
    return brightness == Brightness.light ? primary : primaryLight;
  }

  /// Get status color based on string status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'published':
        return completedGreen;
      case 'in-progress':
      case 'in_progress':
        return inProgressBlue;
      case 'draft':
      case 'pending':
        return draftOrange;
      case 'archived':
      case 'inactive':
        return archivedGray;
      case 'rejected':
      case 'failed':
        return rejectedRed;
      default:
        return gray500;
    }
  }

  /// Get status gradient based on string status
  static List<Color> getStatusGradient(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'published':
        return successGradient;
      case 'in-progress':
      case 'in_progress':
        return infoGradient;
      case 'draft':
      case 'pending':
        return warningGradient;
      case 'archived':
      case 'inactive':
        return [archivedGray, gray400];
      case 'rejected':
      case 'failed':
        return errorGradient;
      default:
        return [gray500, gray400];
    }
  }
}
