import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/notifications_provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/feature_flags_provider.dart';

class ProviderConfig {
  static List<ChangeNotifierProvider> get providers => [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<NotificationsProvider>(
          create: (_) => NotificationsProvider(),
        ),
        ChangeNotifierProvider<PortfolioProvider>(
          create: (_) => PortfolioProvider(),
        ),
        ChangeNotifierProvider<FeatureFlagsProvider>(
          create: (_) => FeatureFlagsProvider(),
        ),
      ];

  static Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}
