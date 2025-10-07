import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../config/route_config.dart';
import '../constants/ui_constants.dart';
import '../widgets/common/styled_components.dart';
import '../widgets/common/app_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get user provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Validate password
      final bool isPasswordValid = userProvider.validatePassword(_passwordController.text);

      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (isPasswordValid) {
        // Navigate to home screen on successful login
        Navigator.pushReplacementNamed(context, RouteConfig.home);
      } else {
        // Show error message for invalid password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid password. Please try again.'),
            backgroundColor: UIConstants.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return AppScaffold(
      showAppBar: false,
      useGradientBackground: true,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Logo
            Image.asset(
              'assets/ic_launcher.png',
              height: 80,
              width: 80,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_balance_wallet_outlined,
                size: 80,
              ),
            ),
            const SizedBox(height: UIConstants.spacing24),
            
            // Welcome Text
            Text(
              'Welcome back, ${userProvider.firstName}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UIConstants.spacing8),
            
            Text(
              'Please enter your password to continue',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: UIConstants.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UIConstants.spacing32),
            
            // Password Field
            StyledTextField(
              controller: _passwordController,
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword 
                      ? Icons.visibility_outlined 
                      : Icons.visibility_off_outlined,
                ),
                onPressed: _togglePasswordVisibility,
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: UIConstants.spacing24),
            
            // Login Button
            StyledPrimaryButton(
              text: 'Login',
              onPressed: _handleLogin,
              isLoading: _isLoading,
            ),
            const SizedBox(height: UIConstants.spacing16),
            
            // Forgot Password
            StyledTextButton(
              text: 'Forgot Password?',
              onPressed: () {
                Navigator.pushNamed(context, RouteConfig.forgotPassword);
              },
            ),
            
            // Use Different Account
            /*StyledTextButton(
              text: 'Use Different Account',
              onPressed: () {
                Navigator.pushReplacementNamed(context, RouteConfig.welcome);
              },
            ),*/
          ],
        ),
      ),
    );
  }
}