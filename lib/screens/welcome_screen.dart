import 'package:flutter/material.dart';
import 'package:saver/constants/app_constants.dart';
import '../config/route_config.dart';
import '../constants/ui_constants.dart';
import '../widgets/common/app_scaffold.dart';
import '../widgets/common/styled_components.dart';
import '../utils/theme_helper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      useGradientBackground: true,
      padding: ThemeHelper.getPagePadding(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          // App Logo
          const StyledAppLogo(size: 120),
          const SizedBox(height: UIConstants.spacing32),
          
          // Welcome Text
          Text(
            'Welcome to ${AppConstants.appName}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.spacing16),
          
          // Subtitle
          Text(
            'Track your investments across different categories and manage your portfolio efficiently.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: UIConstants.textSecondaryColor,
                ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          
          // Features List
          _buildFeatureItem(
            context,
            Icons.track_changes,
            'Track Investments',
            'Monitor your investments across various categories',
          ),
          _buildFeatureItem(
            context,
            Icons.analytics,
            'Portfolio Analytics',
            'Get insights into your investment performance',
          ),
          _buildFeatureItem(
            context,
            Icons.security,
            'Secure & Private',
            'Your data stays on your device',
          ),
          const Spacer(),
          
          // Proceed Button
          StyledPrimaryButton(
            text: 'Get Started',
            onPressed: () {
              Navigator.pushReplacementNamed(context, RouteConfig.signup);
            },
          ),
          const SizedBox(height: UIConstants.spacing16),
          
          // Terms and Privacy
          Text(
            'By proceeding, you agree to our Terms of Service and Privacy Policy',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.spacing24),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.spacing8),
      child: Row(
        children: [
          StyledIconWithBackground(
            icon: icon,
            size: UIConstants.standardIconSize,
          ),
          const SizedBox(width: UIConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: UIConstants.textSecondaryColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 