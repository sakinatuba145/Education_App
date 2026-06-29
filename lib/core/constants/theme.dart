import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ThemeColors.primary,
      selectionColor: ThemeColors.secondary,
      selectionHandleColor: ThemeColors.primary,
    ),
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: ThemeColors.background,
    primaryColor: ThemeColors.primary,
    colorScheme: const ColorScheme.light(
      primary: ThemeColors.primary,
      secondary: ThemeColors.secondary,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: ThemeColors.black,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: ThemeColors.background,
      foregroundColor: ThemeColors.black,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: ThemeColors.black,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: ThemeColors.black,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: ThemeColors.black,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ThemeColors.black,
      ),
      titleMedium: GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ThemeColors.black,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: ThemeColors.black,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF555555),
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF777777),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColors.primary,
        foregroundColor: ThemeColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      isDense: true,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),

      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ThemeColors.black,
      ),

      prefixIconColor: ThemeColors.primary,
      suffixIconColor: ThemeColors.primary,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: ThemeColors.primary,
          width: 2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(ThemeColors.primary),
      trackColor: WidgetStateProperty.all(
        ThemeColors.primary.withValues(alpha: 0.3),
      ),
    ),
    iconTheme: const IconThemeData(
      color: ThemeColors.primary,
      size: 24,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackgroundColor: AppDarkColors.background,
    primaryColor: ThemeColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: ThemeColors.primary,
      secondary: ThemeColors.secondary,
      surface: AppDarkColors.card,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppDarkColors.background,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFCCCCCC),
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF999999),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColors.button,
        foregroundColor: Colors.white,

        minimumSize: const Size(double.infinity, 56),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppDarkColors.input,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      hintStyle: GoogleFonts.poppins(color: Colors.grey),
      labelStyle: GoogleFonts.poppins(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: ThemeColors.primary,
          width: 1.5,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppDarkColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    iconTheme: const IconThemeData(
      color: ThemeColors.primary,
      size: 24,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2A2A),
      thickness: 1,
    ),
  );
}

class ThemeColors {
  static const primary = Color(0xFFFFA726);
  static const secondary = Color(0xFFFFCC80);
  static const background = Color(0xFFFFF3E0);


  static const gradient1 = Color(0xFFFFF8F0);
  static const gradient2 = Color(0xFFFFE0B2);
  static const gradient3 = Color(0xFFFFD180);
  static const button = Color(0xFFFf5b400);


  static const white = Colors.white;
  static const black = Colors.black;
}

class AppDarkColors {
  static const background = Color(0xFF121212);
  static const card = Color(0xFF1E1E1E);
  static const input = Color(0xFF2A2A2A);
}

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  static Widget _blurCircle(double size, Color color) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeColors.gradient1,
                ThemeColors.gradient2,
                ThemeColors.gradient3,
              ],
            ),
          ),
        ),

        Positioned(
          top: -80,
          right: -50,
          child: _blurCircle(220, Colors.orange),
        ),

        Positioned(
          bottom: -100,
          left: -60,
          child: _blurCircle(250, Colors.orange),
        ),

        child,
      ],
    );
  }
}