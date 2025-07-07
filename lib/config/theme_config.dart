import 'package:flutter/material.dart';
import '../constants/ui_constants.dart';

class ThemeConfig {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: UIConstants.primaryColor,
          primary: UIConstants.primaryColor,
          secondary: UIConstants.accentColor,
          error: UIConstants.errorColor,
          background: UIConstants.backgroundColor,
          surface: UIConstants.surfaceColor,
        ),
        scaffoldBackgroundColor: UIConstants.backgroundColor,
        appBarTheme: AppBarTheme(
          elevation: UIConstants.elevationSmall,
          centerTitle: true,
          backgroundColor: UIConstants.backgroundColor,
          foregroundColor: UIConstants.textPrimaryColor,
          titleTextStyle: UIConstants.headingSmall,
        ),
        cardTheme: CardTheme(
          elevation: UIConstants.cardElevation,
          margin: const EdgeInsets.symmetric(
              vertical: UIConstants.spacing4, horizontal: UIConstants.spacing8),
          shape: RoundedRectangleBorder(
            borderRadius: UIConstants.cardBorderRadius,
          ),
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: UIConstants.paddingListItem,
          minLeadingWidth: 24,
          minVerticalPadding: UIConstants.spacing12,
        ),
        dividerTheme: const DividerThemeData(
          color: UIConstants.dividerColor,
          thickness: 1.0,
          space: 1.0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: UIConstants.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(
                UIConstants.minButtonWidth, UIConstants.minButtonHeight),
            padding: UIConstants.paddingHorizontal16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
            ),
            elevation: UIConstants.elevationSmall,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: UIConstants.primaryColor,
            minimumSize: const Size(
                UIConstants.minButtonWidth, UIConstants.minButtonHeight),
            padding: UIConstants.paddingHorizontal16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: UIConstants.primaryColor,
            side: BorderSide(color: UIConstants.primaryColor),
            minimumSize: const Size(
                UIConstants.minButtonWidth, UIConstants.minButtonHeight),
            padding: UIConstants.paddingHorizontal16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacing16,
            vertical: UIConstants.spacing12,
          ),
          filled: true,
          fillColor: UIConstants.backgroundColor,
          errorStyle:
              UIConstants.bodySmall.copyWith(color: UIConstants.errorColor),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          width: 300,
          actionTextColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: TextTheme(
          displayLarge: UIConstants.headingLarge,
          displayMedium: UIConstants.headingMedium,
          displaySmall: UIConstants.headingSmall,
          headlineMedium: UIConstants.sectionTitle,
          bodyLarge: UIConstants.bodyLarge,
          bodyMedium: UIConstants.bodyMedium,
          bodySmall: UIConstants.bodySmall,
          labelLarge:
              UIConstants.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          labelMedium:
              UIConstants.bodySmall.copyWith(fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: UIConstants.primaryColor,
          size: UIConstants.standardIconSize,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: UIConstants.primaryColor,
          brightness: Brightness.dark,
          primary: UIConstants.primaryColor,
          secondary: UIConstants.secondaryColor,
          error: UIConstants.errorColor,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: AppBarTheme(
          elevation: UIConstants.elevationSmall,
          centerTitle: true,
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          titleTextStyle:
              UIConstants.headingSmall.copyWith(color: Colors.white),
        ),
        cardTheme: CardTheme(
          elevation: UIConstants.cardElevation,
          margin: const EdgeInsets.symmetric(
              vertical: UIConstants.spacing4, horizontal: UIConstants.spacing8),
          shape: RoundedRectangleBorder(
            borderRadius: UIConstants.cardBorderRadius,
          ),
          color: const Color(0xFF2C2C2C),
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: UIConstants.paddingListItem,
          minLeadingWidth: 24,
          minVerticalPadding: UIConstants.spacing12,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF3E3E3E),
          thickness: 1.0,
          space: 1.0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: UIConstants.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(
                UIConstants.minButtonWidth, UIConstants.minButtonHeight),
            padding: UIConstants.paddingHorizontal16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
            ),
            elevation: UIConstants.elevationSmall,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: UIConstants.primaryColor,
            minimumSize: const Size(
                UIConstants.minButtonWidth, UIConstants.minButtonHeight),
            padding: UIConstants.paddingHorizontal16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: UIConstants.primaryColor,
            side: BorderSide(color: UIConstants.primaryColor),
            minimumSize: const Size(
                UIConstants.minButtonWidth, UIConstants.minButtonHeight),
            padding: UIConstants.paddingHorizontal16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacing16,
            vertical: UIConstants.spacing12,
          ),
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          errorStyle:
              UIConstants.bodySmall.copyWith(color: UIConstants.errorColor),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          width: 300,
          actionTextColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.white),
          backgroundColor: Color(0xFF323232),
        ),
        textTheme: TextTheme(
          displayLarge: UIConstants.headingLarge.copyWith(color: Colors.white),
          displayMedium:
              UIConstants.headingMedium.copyWith(color: Colors.white),
          displaySmall: UIConstants.headingSmall.copyWith(color: Colors.white),
          headlineMedium:
              UIConstants.sectionTitle.copyWith(color: Colors.white),
          bodyLarge: UIConstants.bodyLarge.copyWith(color: Colors.white),
          bodyMedium: UIConstants.bodyMedium.copyWith(color: Colors.white),
          bodySmall: UIConstants.bodySmall.copyWith(color: Color(0xFFBDBDBD)),
          labelLarge: UIConstants.bodyMedium
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          labelMedium: UIConstants.bodySmall
              .copyWith(fontWeight: FontWeight.bold, color: Color(0xFFBDBDBD)),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: UIConstants.standardIconSize,
        ),
      );
}
