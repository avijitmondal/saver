import 'package:flutter/material.dart';
import 'home_screen.dart';

class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In / Sign Up')),
      body: Center(
        child: ElevatedButton.icon(
          icon: Image.asset(
            'assets/google_logo.png',
            height: 24,
            width: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
          ),
          label: const Text('Continue with Google'),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}
