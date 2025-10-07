import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/portfolio_provider.dart';
import '../screens/registration_screen.dart';
import '../screens/signup_screen.dart';
import '../config/route_config.dart';
import 'dialog_service.dart';
import 'navigation_service.dart';
import 'service_locator.dart';

class AccountManager {
  final NavigationService _navigationService = locator<NavigationService>();

  /// Logs out the user and navigates to login screen
  Future<void> logout(BuildContext context) async {
    try {
      // Show loading dialog
      await DialogService.showLoadingDialog(
        context: context,
        message: 'Logging out...',
      );

      // Simulate some delay for logout
      await Future.delayed(const Duration(milliseconds: 500));

      if (!context.mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      // Navigate to login screen - using a more direct approach
      if (!context.mounted) return;
      
      // Use Navigator directly instead of the navigation service
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteConfig.login,
        (route) => false,
      );
    } catch (e) {
      // Close loading dialog if any error occurs
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to logout. Please try again.')),
        );
      }
    }
  }

  /// Deletes the user account and navigates to registration screen
  Future<void> deleteAccount(BuildContext context) async {
    try {
      // Show loading dialog
      await DialogService.showLoadingDialog(
        context: context,
        message: 'Deleting account...',
      );

      // Simulate some delay for data deletion
      await Future.delayed(const Duration(milliseconds: 500));

      // Clear data using locator
      if (!context.mounted) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final portfolioProvider =
          Provider.of<PortfolioProvider>(context, listen: false);

      userProvider.clearUserData();
      portfolioProvider.clearPortfolio();

      // Close loading dialog and navigate
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      // Navigate to welcome screen
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteConfig.welcome,
        (route) => false,
      );
    } catch (e) {
      // Close loading dialog if any error occurs
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to delete account. Please try again.')),
        );
      }
    }
  }

  /// Exports user data (placeholder implementation)
  Future<void> exportData(BuildContext context) async {
    // Implement data export functionality
    await DialogService.showLoadingDialog(
      context: context,
      message: 'Preparing data export...',
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return;
    Navigator.of(context).pop(); // Close loading dialog

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export completed successfully')),
    );
  }
}
