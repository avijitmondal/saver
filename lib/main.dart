import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'config/theme_config.dart';
import 'config/route_config.dart';
import 'config/provider_config.dart';
import 'config/service_locator.dart';
import 'providers/user_provider.dart';
import 'utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      Logger.instance.error('Flutter Error: ${details.exception}');
    }
  };

  try {
    await _initializeApp();
    runApp(const SaverApp());
  } catch (error, stackTrace) {
    Logger.instance.error('App initialization failed: $error');
    if (kDebugMode) {
      print('Stack trace: $stackTrace');
    }
    runApp(_ErrorApp(error: error.toString()));
  }
}

Future<void> _initializeApp() async {
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize logger
  Logger.instance.configure(
    enabled: true,
    minLevel: kDebugMode ? LogLevel.debug : LogLevel.warning,
  );

  // Initialize service locator
  await serviceLocator.initialize();
  
  Logger.instance.debug('Service locator initialized');
}

class SaverApp extends StatelessWidget {
  const SaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderConfig.wrapWithProviders(
      Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return MaterialApp(
            navigatorKey: serviceLocator.navigationService.navigatorKey,
            title: AppConstants.appName,
            theme: ThemeConfig.lightTheme,
            darkTheme: ThemeConfig.darkTheme,
            themeMode: userProvider.themeModeEnum,
            initialRoute: RouteConfig.initialRoute,
            routes: RouteConfig.routes,
            onGenerateRoute: RouteConfig.onGenerateRoute,
            onUnknownRoute: RouteConfig.onUnknownRoute,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

class _ErrorApp extends StatelessWidget {
  final String error;

  const _ErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saver - Error',
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please restart the app. If the problem persists, contact support.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                if (kDebugMode) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Error: $error',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
