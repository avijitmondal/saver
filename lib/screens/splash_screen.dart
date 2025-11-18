import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import '../config/route_config.dart';
import '../providers/user_provider.dart';
import '../providers/portfolio_provider.dart';
import '../constants/app_constants.dart';
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
      // Initialize providers and user data
      _initializeApp();

      // Navigate after animation
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateBasedOnUserData();
      });
    });
  }

  void _initializeApp() async {
    // Initialize providers first
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);

    // Ensure both providers are initialized
    await userProvider.initialize();
    await portfolioProvider.initialize();
  }

  void _navigateBasedOnUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Check if running on supported platforms (iOS/Android only)
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    if ((AppConstants.featureFlags["comingSoonScreen"] ?? false) && !isMobile) {
      // Show platform not supported screen for web/desktop
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    Image.asset(
                      'assets/ic_launcher.png',
                      height: 100,
                      width: 100,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
                      'Track your investments. Manage your future.',
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
