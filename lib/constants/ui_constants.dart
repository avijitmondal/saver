import 'package:flutter/material.dart';

/// App-wide UI constants to maintain consistent design across all screens
class UIConstants {
  // Colors
  static const Color primaryColor = Colors.green;
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF8BC34A);
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  static const Color successColor = Colors.green;
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF5F5F5);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFEEEEEE);

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.2,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.3,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textPrimaryColor,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: textSecondaryColor,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: textSecondaryColor,
    height: 1.3,
  );

  // Spacing
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircular = 50.0;

  // Elevation
  static const double elevationSmall = 1.0;
  static const double elevationMedium = 2.0;
  static const double elevationLarge = 4.0;
  static const double elevationXLarge = 8.0;

  // Animation durations
  static const Duration animationShort = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);

  // Layout constraints
  static const double maxContentWidth = 1000.0;
  static const double minButtonWidth = 120.0;
  static const double minButtonHeight = 48.0;
  static const double standardIconSize = 24.0;
  static const double largeIconSize = 36.0;
  static const double avatarSizeSmall = 36.0;
  static const double avatarSizeMedium = 50.0;
  static const double avatarSizeLarge = 80.0;

  // Common paddings
  static const EdgeInsets paddingAll8 = EdgeInsets.all(spacing8);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(spacing16);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(spacing24);

  static const EdgeInsets paddingHorizontal16 =
      EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets paddingVertical16 =
      EdgeInsets.symmetric(vertical: spacing16);

  static const EdgeInsets paddingStandard = EdgeInsets.symmetric(
    horizontal: spacing16,
    vertical: spacing16,
  );

  static const EdgeInsets paddingListItem = EdgeInsets.symmetric(
    horizontal: spacing16,
    vertical: spacing12,
  );

  static const EdgeInsets paddingPage = EdgeInsets.all(spacing16);

  // Screen content padding
  static EdgeInsets screenPadding = const EdgeInsets.all(spacing16);

  // Card styling
  static BorderRadius cardBorderRadius = BorderRadius.circular(radiusMedium);
  static EdgeInsets cardPadding = const EdgeInsets.all(spacing16);
  static double cardElevation = elevationMedium;
}
