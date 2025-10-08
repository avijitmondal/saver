import 'package:flutter/material.dart';
import 'package:saver/constants/app_constants.dart';
import '../config/route_config.dart';
import '../constants/ui_constants.dart';
import '../widgets/common/app_scaffold.dart';
import '../utils/theme_helper.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
          Image.asset(
            'assets/ic_launcher.png',
            height: 120,
            width: 120,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.account_balance_wallet_outlined,
              size: 120,
            ),
          ),
          // const SizedBox(height: UIConstants.spacing32),
          
          // Signup Text
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.spacing16),
          const Spacer(),

          // Use ElevatedButton.icon for Google signup
          /*
          ElevatedButton.icon(
            icon: Image.asset(
              'assets/google_logo.png',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
            ),
            label: const Text('Signup with Google'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              // Navigator.pushReplacementNamed(context, RouteConfig.registration);
            },
          ),
          const SizedBox(height: UIConstants.spacing16),

          // Use ElevatedButton.icon for Github signup (optionally add a GitHub icon)
          ElevatedButton.icon(
            icon: Image.asset(
              'assets/github-icon-white.png',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
            ),
            label: const Text('Signup with Github'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              // Navigator.pushReplacementNamed(context, RouteConfig.registration);
            },
          ),
          const SizedBox(height: UIConstants.spacing16),
          */

          // Proceed Button
          ElevatedButton(
            child: const Text('Signup with Email'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, RouteConfig.registration);
            },
          ),
          const SizedBox(height: UIConstants.spacing16),
        ],
      ),
    );
  }
}
