import 'package:flutter/material.dart';

class ResponsiveLayout {
  static const double _smallScreenWidth = 576;
  static const double _mediumScreenWidth = 768;
  static const double _largeScreenWidth = 992;
  static const double _extraLargeScreenWidth = 1200;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < _smallScreenWidth;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= _smallScreenWidth &&
        MediaQuery.of(context).size.width < _mediumScreenWidth;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= _mediumScreenWidth &&
        MediaQuery.of(context).size.width < _largeScreenWidth;
  }

  static bool isExtraLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= _largeScreenWidth;
  }

  static T getValueForScreenType<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final double width = MediaQuery.of(context).size.width;

    // Large desktop
    if (width >= _extraLargeScreenWidth) {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
    // Desktop
    if (width >= _largeScreenWidth) {
      return desktop ?? tablet ?? mobile;
    }
    // Tablet
    if (width >= _smallScreenWidth) {
      return tablet ?? mobile;
    }
    // Mobile
    return mobile;
  }

  static double getHorizontalPadding(BuildContext context) {
    return getValueForScreenType(
      context: context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
      largeDesktop: 48.0,
    );
  }

  static double getVerticalPadding(BuildContext context) {
    return getValueForScreenType(
      context: context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
      largeDesktop: 40.0,
    );
  }
}
