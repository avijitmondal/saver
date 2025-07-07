import 'package:flutter/material.dart';
import '../constants/ui_constants.dart';

/// Helper class to provide consistent styling across the app
class ThemeHelper {
  /// Get a consistent container decoration for cards and sections
  static BoxDecoration getCardDecoration(BuildContext context, {Color? color}) {
    return BoxDecoration(
      color: color ?? Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Get a consistent gradient decoration for backgrounds
  static BoxDecoration getGradientDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.1),
          Theme.of(context).scaffoldBackgroundColor,
        ],
      ),
    );
  }

  /// Get a consistent button style
  static ButtonStyle getPrimaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.spacing16,
        horizontal: UIConstants.spacing24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
      ),
      elevation: UIConstants.elevationSmall,
    );
  }

  /// Get a consistent secondary button style
  static ButtonStyle getSecondaryButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      side: BorderSide(color: Theme.of(context).colorScheme.primary),
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.spacing16,
        horizontal: UIConstants.spacing24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
      ),
    );
  }

  /// Get a consistent text button style
  static ButtonStyle getTextButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.spacing8,
        horizontal: UIConstants.spacing16,
      ),
    );
  }

  /// Get a consistent input decoration
  static InputDecoration getInputDecoration(
    BuildContext context, {
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacing16,
        vertical: UIConstants.spacing16,
      ),
    );
  }

  /// Get a consistent section header style
  static Widget getSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.spacing16,
        horizontal: UIConstants.spacing8,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  /// Get a consistent card padding
  static EdgeInsets getCardPadding() {
    return const EdgeInsets.all(UIConstants.spacing16);
  }

  /// Get a consistent page padding
  static EdgeInsets getPagePadding() {
    return const EdgeInsets.all(UIConstants.spacing24);
  }

  /// Get a consistent icon with background
  static Widget getIconWithBackground(
    BuildContext context,
    IconData icon, {
    double size = UIConstants.standardIconSize,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spacing12),
      decoration: BoxDecoration(
        color: backgroundColor ?? 
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UIConstants.radiusMedium),
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
} 