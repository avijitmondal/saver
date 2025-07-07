import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_constants.dart';
import 'config/theme_config.dart';
import 'config/route_config.dart';
import 'config/provider_config.dart';
import 'services/navigation_service.dart';
import 'services/service_locator.dart';
import 'utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize logger
  Logger.instance.configure(
    enabled: true,
    minLevel: LogLevel.debug,
  );

  // Initialize service locator
  setupLocator();

  // Get navigation service from locator
  final navigationService = locator<NavigationService>();

  runApp(SaverApp(navigationService: navigationService));
}

class SaverApp extends StatelessWidget {
  final NavigationService navigationService;

  const SaverApp({
    Key? key,
    required this.navigationService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderConfig.wrapWithProviders(
      MaterialApp(
        navigatorKey: navigationService.navigatorKey,
        title: AppConstants.appName,
        theme: ThemeConfig.lightTheme,
        darkTheme: AppConstants.enableDarkMode ? ThemeConfig.darkTheme : null,
        themeMode: ThemeMode.system,
        initialRoute: RouteConfig.initialRoute,
        routes: RouteConfig.routes,
        onGenerateRoute: RouteConfig.onGenerateRoute,
        onUnknownRoute: RouteConfig.onUnknownRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
