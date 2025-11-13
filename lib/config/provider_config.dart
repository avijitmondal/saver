import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/notifications_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/feature_flags_provider.dart';
import '../services/service_locator.dart';

class ProviderConfig {
  static Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final userProvider = locator<UserProvider>();
            // Initialize the provider immediately
            userProvider.initialize();
            return userProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final portfolioProvider = locator<PortfolioProvider>();
            // Initialize the provider immediately
            portfolioProvider.initialize();
            return portfolioProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => FeatureFlagsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => locator<NotificationsProvider>(),
        ),
      ],
      child: child,
    );
  }
}
