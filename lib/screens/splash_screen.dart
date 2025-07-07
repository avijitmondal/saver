import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import '../config/route_config.dart';
import '../providers/user_provider.dart';
import '../constants/app_constants.dart';
import '../data/sample_user.dart';
import '../screens/coming_soon_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Configure system UI
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward().then((_) {
      // Initialize user data if needed
      _initializeUserData();

      // Navigate after animation
      Future.delayed(const Duration(milliseconds: 500), () {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Only show Coming Soon screen if enabled and NOT on Android/iOS
        final isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
        if ((AppConstants.featureFlags["enableComingSoonScreen"] ?? false) && !isMobile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              // Pass an exact DateTime instead of a duration
              builder: (_) => ComingSoonScreen(targetTime: DateTime(2026, 01, 01, 00, 00, 00)),
            ),
          );
          return;
        }

        // Check if user data exists
        if (userProvider.fullName.isNotEmpty) {
          // User data exists, navigate to login screen
          Navigator.pushReplacementNamed(context, RouteConfig.login);
        } else {
          // No user data, navigate to welcome
          Navigator.pushReplacementNamed(context, RouteConfig.welcome);
        }
      });
    });
  }

  void _initializeUserData() {
    if (!(AppConstants.featureFlags["enableSampleUser"] ?? false)) return;
    // Use the SampleUser class to populate user data
    SampleUser.populateUserProvider(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track Your Investments',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
