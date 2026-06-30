import 'package:flutter/material.dart';

/// Responsive design framework for mobile-first development
/// Provides breakpoints, helper methods, and responsive values
class AppResponsive {
  // =============== SCREEN SIZE BREAKPOINTS ===============
  // Following Material Design breakpoints

  /// Maximum width for mobile layouts (phones)
  static const double mobile_max = 599.0;

  /// Minimum width for tablet layouts
  static const double tablet_min = 600.0;

  /// Maximum width for tablet layouts
  static const double tablet_max = 839.0;

  /// Minimum width for desktop layouts
  static const double desktop_min = 840.0;

  // =============== COMMON DEVICE SIZES ===============
  static const double iPhone_SE_width = 375.0;
  static const double iPhone_12_width = 390.0;
  static const double iPhone_14Pro_width = 430.0;
  static const double iPad_mini_width = 768.0;
  static const double iPad_width = 810.0;
  static const double iPad_Pro_11_width = 834.0;
  static const double iPad_Pro_12_width = 1024.0;

  // =============== DEVICE TYPE DETECTION ===============

  /// Check if screen is mobile (< 600px)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet_min;

  /// Check if screen is tablet (600px - 839px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tablet_min && width < desktop_min;
  }

  /// Check if screen is desktop (>= 840px)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop_min;

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  /// Get detailed device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < tablet_min) {
      return DeviceType.mobile;
    } else if (width < desktop_min) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // =============== RESPONSIVE LAYOUT VALUES ===============

  /// Get optimal grid columns based on device type
  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2; // mobile
  }

  /// Get optimal grid columns for course cards
  static int courseGridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 2;
    return 1; // mobile
  }

  /// Get responsive padding based on device
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isDesktop(context)) return EdgeInsets.all(32);
    if (isTablet(context)) return EdgeInsets.all(24);
    return EdgeInsets.all(16); // mobile
  }

  /// Get responsive horizontal padding
  static EdgeInsets responsiveHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return EdgeInsets.symmetric(horizontal: 32);
    if (isTablet(context)) return EdgeInsets.symmetric(horizontal: 24);
    return EdgeInsets.symmetric(horizontal: 16);
  }

  /// Get responsive vertical padding
  static EdgeInsets responsiveVerticalPadding(BuildContext context) {
    if (isDesktop(context)) return EdgeInsets.symmetric(vertical: 24);
    if (isTablet(context)) return EdgeInsets.symmetric(vertical: 20);
    return EdgeInsets.symmetric(vertical: 16);
  }

  /// Get responsive margin between elements
  static double responsiveMargin(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 24;
    return 16; // mobile
  }

  /// Get responsive gap in lists
  static double responsiveGap(BuildContext context) {
    if (isDesktop(context)) return 24;
    if (isTablet(context)) return 16;
    return 12; // mobile
  }

  /// Get responsive font scale
  static double responsiveFontScale(BuildContext context) {
    if (isDesktop(context)) return 1.1;
    if (isTablet(context)) return 1.05;
    return 1.0; // mobile
  }

  /// Get responsive icon size
  static double responsiveIconSize(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 28;
    return 24; // mobile
  }

  /// Get responsive card width
  static double responsiveCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = responsivePadding(context).horizontal;
    return width - padding;
  }

  /// Get responsive max width for content (for readability on desktop)
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 800;
    return MediaQuery.of(context).size.width;
  }

  /// Get safe area aware padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscapeView = isLandscape(context);

    if (isDesktop(context)) {
      return EdgeInsets.only(
        left: mediaQuery.padding.left + 32,
        right: mediaQuery.padding.right + 32,
        top: mediaQuery.padding.top + 16,
        bottom: mediaQuery.padding.bottom + 16,
      );
    }

    final horizontalPadding = isLandscapeView ? 16.0 : 16.0;

    return EdgeInsets.only(
      left: mediaQuery.padding.left + horizontalPadding,
      right: mediaQuery.padding.right + horizontalPadding,
      top: mediaQuery.padding.top + 8,
      bottom: mediaQuery.padding.bottom + 8,
    );
  }

  // =============== ASPECT RATIOS ===============

  /// Aspect ratio for thumbnails
  static double thumbnailAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 16 / 9;
    if (isTablet(context)) return 4 / 3;
    return 3 / 2; // mobile
  }

  /// Aspect ratio for hero images
  static double heroImageAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 21 / 9;
    if (isTablet(context)) return 16 / 9;
    return 9 / 6; // mobile
  }

  // =============== SIZE UTILITIES ===============

  /// Get screen safe width (excluding safe areas)
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.horizontal;
  }

  /// Get screen safe height (excluding safe areas)
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.vertical;
  }

  /// Get viewport width percentage
  static double percentageWidth(BuildContext context, double percentage) {
    return screenWidth(context) * (percentage / 100);
  }

  /// Get viewport height percentage
  static double percentageHeight(BuildContext context, double percentage) {
    return screenHeight(context) * (percentage / 100);
  }

  // =============== DEVICE CHECKING UTILITIES ===============

  /// Check if device is small phone (< 380px)
  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 380;

  /// Check if device supports one-handed use
  static bool supportsOneHandedUse(BuildContext context) =>
      MediaQuery.of(context).size.width <= 480;

  /// Get keyboard height
  static double keyboardHeight(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom;

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom > 0;
}

/// Enumeration of device types
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Helper extension for easier responsive checks
extension ResponsiveContext on BuildContext {
  bool get isMobile => AppResponsive.isMobile(this);
  bool get isTablet => AppResponsive.isTablet(this);
  bool get isDesktop => AppResponsive.isDesktop(this);
  bool get isLandscape => AppResponsive.isLandscape(this);
  bool get isPortrait => AppResponsive.isPortrait(this);

  DeviceType get deviceType => AppResponsive.getDeviceType(this);

  double get screenWidth => AppResponsive.screenWidth(this);
  double get screenHeight => AppResponsive.screenHeight(this);

  int get gridColumns => AppResponsive.gridColumns(this);

  EdgeInsets get responsivePadding => AppResponsive.responsivePadding(this);

  double get responsiveMargin => AppResponsive.responsiveMargin(this);
}
