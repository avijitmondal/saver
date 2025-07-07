import 'package:flutter/material.dart';
import '../screens/registration_screen.dart';
import '../screens/home_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

class RouteConfig {
  static const String initialRoute = '/';
  static const String welcome = '/welcome';
  static const String registration = '/registration';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, Widget Function(BuildContext)> get routes => {
        initialRoute: (context) => const SplashScreen(),
        welcome: (context) => const WelcomeScreen(),
        registration: (context) => const RegistrationScreen(),
        home: (context) => const HomeScreen(),
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Add custom route handling logic here if needed
    return null;
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('Route ${settings.name} not found'),
        ),
      ),
    );
  }
}
