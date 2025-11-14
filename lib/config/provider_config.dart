import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/notifications_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/ppf_payment_provider.dart';
import '../providers/feature_flags_provider.dart';
import '../config/service_locator.dart';

class ProviderConfig {
  static Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final userProvider = serviceLocator.userProvider;
            // Initialize the provider immediately
            userProvider.initialize();
            return userProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final portfolioProvider = serviceLocator.portfolioProvider;
            // Initialize the provider immediately
            portfolioProvider.initialize();
            return portfolioProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => serviceLocator.ppfPaymentProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => FeatureFlagsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationsProvider(),
        ),
      ],
      child: child,
    );
  }
}
