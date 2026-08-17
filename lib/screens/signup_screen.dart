import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:saver/constants/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import '../config/route_config.dart';
import '../constants/ui_constants.dart';
import '../widgets/common/app_scaffold.dart';
import '../utils/theme_helper.dart';
import '../services/data_import_service.dart';
import '../services/service_locator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isImporting = false;
  
  // Get import service from service locator
  late final DataImportService _importService = locator<DataImportService>();

  Future<void> _handleImportData() async {
    try {
      setState(() => _isImporting = true);

      // Pick file
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (files.isEmpty) {
        setState(() => _isImporting = false);
        return;
      }

      final file = files.first;
      final bytes = await file.readAsBytes();
      final jsonContent = utf8.decode(bytes);

      // Validate file first
      final validation = await _importService.validateImportFile(jsonContent);
      
      if (!validation.isValid) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(validation.error ?? 'Invalid export file'),
            backgroundColor: UIConstants.errorColor,
          ),
        );
        setState(() => _isImporting = false);
        return;
      }

      // Show confirmation dialog
      if (!mounted) return;
      final confirmed = await _showImportConfirmation(validation);
      
      if (!confirmed) {
        setState(() => _isImporting = false);
        return;
      }

      // Import data
      final importResult = await _importService.importFromJson(jsonContent);

      if (!importResult.success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(importResult.error ?? 'Import failed'),
            backgroundColor: UIConstants.errorColor,
          ),
        );
        setState(() => _isImporting = false);
        return;
      }

      setState(() => _isImporting = false);

      if (!mounted) return;

      // Navigate to registration with imported data
      Navigator.pushReplacementNamed(
        context,
        RouteConfig.registration,
        arguments: importResult, // Pass the import result to registration
      );

    } catch (e) {
      setState(() => _isImporting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Import failed: $e'),
          backgroundColor: UIConstants.errorColor,
        ),
      );
    }
  }

  Future<bool> _showImportConfirmation(ValidationResult validation) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This will import:'),
            const SizedBox(height: 12),
            if (validation.userName != null)
              Text('• User: ${validation.userName}'),
            if (validation.email != null)
              Text('• Email: ${validation.email}'),
            if (validation.investmentCount != null && validation.investmentCount! > 0)
              Text('• ${validation.investmentCount} investments'),
            const SizedBox(height: 12),
            const Text(
              'You will only need to set a password to complete registration.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Import'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

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
          const SizedBox(height: UIConstants.spacing24),
          
          // App Name
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.spacing8),
          
          // Tagline
          Text(
            'Track your investments. Manage your future.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
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
              Navigator.pushNamed(context, RouteConfig.registration);
            },
          ),
          const SizedBox(height: UIConstants.spacing16),

          // Import Data Button
          OutlinedButton.icon(
            icon: _isImporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file),
            label: const Text('Import Existing Data'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onPressed: _isImporting ? null : _handleImportData,
          ),
          const SizedBox(height: UIConstants.spacing16),
        ],
      ),
    );
  }
}
