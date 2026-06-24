import 'package:flutter/material.dart';

/// Unified dimension system for consistent spacing and sizing
/// All measurements follow Material Design 3 patterns
class AppDimensions {
  // =============== SPACING / PADDING ===============
  // Use these constants for all margins and padding
  static const double spacing_2 = 2.0;
  static const double spacing_4 = 4.0;
  static const double spacing_6 = 6.0;
  static const double spacing_8 = 8.0;
  static const double spacing_12 = 12.0;
  static const double spacing_16 = 16.0;
  static const double spacing_20 = 20.0;
  static const double spacing_24 = 24.0;
  static const double spacing_32 = 32.0;
  static const double spacing_48 = 48.0;

  // =============== SEMANTIC SPACING ===============
  static const double screenPaddingMobile = spacing_16;
  static const double screenPaddingTablet = spacing_24;
  static const double screenPaddingDesktop = spacing_32;

  static const double elementGapSmall = spacing_8;
  static const double elementGapMedium = spacing_16;
  static const double elementGapLarge = spacing_24;

  static const double cardPadding = spacing_16;
  static const double listItemPadding = spacing_12;

  // =============== BORDER RADIUS ===============
  // Semantic border radius for consistent shapes
  static const double radius_small = 6.0;
  static const double radius_medium = 12.0;
  static const double radius_large = 16.0;
  static const double radius_xl = 24.0;
  static const double radius_2xl = 32.0;

  // Semantic usage
  static const double radiusButton = radius_medium;
  static const double radiusCard = radius_large;
  static const double radiusTextField = radius_medium;
  static const double radiusBadge = radius_small;
  static const double radiusDialog = radius_xl;
  static const double radiusBottomSheet = 24.0;

  // =============== ELEVATION / SHADOW ===============
  static const double elevation_0 = 0;
  static const double elevation_1 = 1;
  static const double elevation_2 = 2;
  static const double elevation_4 = 4;
  static const double elevation_6 = 6;
  static const double elevation_8 = 8;
  static const double elevation_12 = 12;
  static const double elevation_16 = 16;

  // =============== COMPONENT HEIGHTS ===============
  static const double button_height = 48.0;
  static const double small_button_height = 40.0;
  static const double tiny_button_height = 36.0;

  static const double textFieldHeight = 56.0;
  static const double searchBarHeight = 48.0;

  static const double appBarHeight = 56.0;
  static const double collapsedAppBarHeight = 56.0;
  static const double expandedAppBarHeight = 200.0;

  static const double bottomNavHeight = 80.0;
  static const double bottomSheetRadius = 24.0;

  // =============== COMPONENT WIDTHS ===============
  static const double fabSize = 56.0;
  static const double smallFabSize = 40.0;
  static const double miniCardWidth = 120.0;

  // =============== IMAGE SIZES ===============
  static const double avatar_tiny = 24.0;
  static const double avatar_small = 32.0;
  static const double avatar_medium = 48.0;
  static const double avatar_large = 64.0;
  static const double avatar_xlarge = 96.0;

  static const double iconTiny = 16.0;
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXlarge = 48.0;

  static const double thumbnailSmall = 80.0;
  static const double thumbnailMedium = 120.0;
  static const double thumbnailLarge = 160.0;

  // =============== PROGRESS INDICATORS ===============
  static const double progressBarHeight = 8.0;
  static const double progressBarHeightThick = 12.0;
  static const double circularProgressSize = 48.0;
  static const double circularProgressSizeSmall = 32.0;

  // =============== BORDERS ===============
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  // =============== SPACER WIDGETS ===============
  static SizedBox get vSpaceXSmall => SizedBox(height: spacing_4);
  static SizedBox get vSpaceSmall => SizedBox(height: spacing_8);
  static SizedBox get vSpaceMedium => SizedBox(height: spacing_16);
  static SizedBox get vSpaceLarge => SizedBox(height: spacing_24);
  static SizedBox get vSpaceXLarge => SizedBox(height: spacing_32);

  static SizedBox get hSpaceXSmall => SizedBox(width: spacing_4);
  static SizedBox get hSpaceSmall => SizedBox(width: spacing_8);
  static SizedBox get hSpaceMedium => SizedBox(width: spacing_16);
  static SizedBox get hSpaceLarge => SizedBox(width: spacing_24);
  static SizedBox get hSpaceXLarge => SizedBox(width: spacing_32);

  // =============== EDGE INSETS ===============
  static const EdgeInsets paddingNone = EdgeInsets.zero;
  static const EdgeInsets paddingXSmall = EdgeInsets.all(spacing_4);
  static const EdgeInsets paddingSmall = EdgeInsets.all(spacing_8);
  static const EdgeInsets paddingMedium = EdgeInsets.all(spacing_12);
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacing_16);
  static const EdgeInsets paddingXLarge = EdgeInsets.all(spacing_24);
  static const EdgeInsets paddingXXLarge = EdgeInsets.all(spacing_32);

  // Directional padding
  static const EdgeInsets paddingHorizontalSmall =
      EdgeInsets.symmetric(horizontal: spacing_8);
  static const EdgeInsets paddingHorizontalMedium =
      EdgeInsets.symmetric(horizontal: spacing_16);
  static const EdgeInsets paddingHorizontalLarge =
      EdgeInsets.symmetric(horizontal: spacing_24);

  static const EdgeInsets paddingVerticalSmall =
      EdgeInsets.symmetric(vertical: spacing_8);
  static const EdgeInsets paddingVerticalMedium =
      EdgeInsets.symmetric(vertical: spacing_12);
  static const EdgeInsets paddingVerticalLarge =
      EdgeInsets.symmetric(vertical: spacing_16);

  // Content padding
  static const EdgeInsets contentPaddingSmall =
      EdgeInsets.symmetric(horizontal: spacing_8, vertical: spacing_6);
  static const EdgeInsets contentPaddingMedium =
      EdgeInsets.symmetric(horizontal: spacing_12, vertical: spacing_8);
  static const EdgeInsets contentPaddingLarge =
      EdgeInsets.symmetric(horizontal: spacing_16, vertical: spacing_12);

  // =============== BORDER RADIUS EDGE INSETS ===============
  static BorderRadius radiusSmallAll = BorderRadius.circular(radius_small);
  static BorderRadius radiusMediumAll = BorderRadius.circular(radius_medium);
  static BorderRadius radiusLargeAll = BorderRadius.circular(radius_large);
  static BorderRadius radiusXlAll = BorderRadius.circular(radius_xl);
}
