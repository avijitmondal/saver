import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/portfolio_provider.dart';
import '../services/account_manager.dart';
import '../services/data_export_service.dart';
import '../services/service_locator.dart';
import '../config/route_config.dart';
import '../services/dialog_service.dart';
import '../widgets/profile/delete_account_dialog.dart';
import '../constants/app_constants.dart';
import '../constants/ui_constants.dart';
import '../utils/download_helper.dart';
import '../models/user.dart';

/// Controller class for managing profile-related operations
class ProfileController {
  final UserProvider userProvider;
  final AccountManager accountManager;
  final BuildContext context;
  
  // Text controllers for editing fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  // Security settings
  bool isTwoFactorEnabled = false;
  bool _isExporting = false;
  
  // Get export service from service locator
  late final DataExportService _exportService = locator<DataExportService>();

  ProfileController({
    required this.userProvider,
    required this.context,
  }) : accountManager = AccountManager() {
    // Initialize controllers with user data
    _initializeControllers();
  }

  void _initializeControllers() {
    firstNameController.text = userProvider.firstName;
    lastNameController.text = userProvider.lastName;
    emailController.text = userProvider.email;
    phoneController.text = userProvider.phone;
    addressController.text = userProvider.address;
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }

  // User data update methods - simplified with the improved UserProvider
  void updateFirstName(String firstName) {
    userProvider.updateUserData(firstName: firstName);
  }

  void updateLastName(String lastName) {
    userProvider.updateUserData(lastName: lastName);
  }

  void updateEmail(String email) {
    userProvider.updateUserData(email: email);
  }

  void updatePhone(String phone) {
    userProvider.updateUserData(phone: phone);
  }

  void updateAddress(String address) {
    userProvider.updateUserData(address: address);
  }

  void updateDateOfBirth(DateTime dateOfBirth) {
    userProvider.updateDateOfBirth(dateOfBirth);
  }

  void updateTwoFactorAuth(bool value) {
    isTwoFactorEnabled = value;
    // Here you would typically update this in a persistent storage
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value
            ? 'Two-factor authentication enabled'
            : 'Two-factor authentication disabled'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Dialog methods
  Future<void> showEditNameDialog() async {
    final result = await DialogService.showNameEditDialog(
      context: context,
      firstName: userProvider.firstName,
      lastName: userProvider.lastName,
      firstNameController: firstNameController,
      lastNameController: lastNameController,
    );

    if (result != null) {
      updateFirstName(result[0]);
      updateLastName(result[1]);
    }
  }

  Future<void> showEditEmailDialog() async {
    emailController.text = userProvider.email;

    final result = await DialogService.showEditDialog(
      context: context,
      title: 'Email',
      currentValue: userProvider.email,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
    );

    if (result != null) {
      updateEmail(result);
    }
  }

  Future<void> showEditPhoneDialog() async {
    phoneController.text = userProvider.phone;

    final result = await DialogService.showEditDialog(
      context: context,
      title: 'Phone Number',
      currentValue: userProvider.phone,
      controller: phoneController,
      keyboardType: TextInputType.phone,
    );

    if (result != null) {
      updatePhone(result);
    }
  }

  Future<void> showEditAddressDialog() async {
    addressController.text = userProvider.address;

    final result = await DialogService.showEditDialog(
      context: context,
      title: 'Address',
      currentValue: userProvider.address,
      controller: addressController,
      maxLines: 3,
    );

    if (result != null) {
      updateAddress(result);
    }
  }

  Future<void> showDatePickerDialog() async {
    final DateTime? picked = await DialogService.showDatePickerDialog(
      context: context,
      initialDate: userProvider.dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      primaryColor: Colors.green,
    );

    if (picked != null && picked != userProvider.dateOfBirth) {
      updateDateOfBirth(picked);
    }
  }

  // Account actions
  void changePassword() {
    Navigator.of(context).pushNamed(RouteConfig.changePassword);
  }

  Future<void> exportData() async {
    _showExportPreview();
  }

  Future<void> _handleExport() async {
    _isExporting = true;

    try {
      final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);

      // Create User object from UserProvider data
      final user = User.create(
        firstName: userProvider.firstName,
        lastName: userProvider.lastName,
        email: userProvider.email,
        phone: userProvider.phone,
        address: userProvider.address,
        dateOfBirth: userProvider.dateOfBirth,
        gender: userProvider.gender,
      );

      // Generate export data
      final exportData = _exportService.exportUserData(
        user: user,
        investments: portfolioProvider.investments,
        featureFlags: AppConstants.featureFlags,
      );

      // Convert to JSON string
      final jsonString = _exportService.generateJsonString(exportData, pretty: true);

      // Generate filename
      final filename = _exportService.generateFilename();

      // Download file
      final result = await DownloadHelper.downloadFile(
        content: jsonString,
        filename: filename,
        context: context,
      );

      if (result != null) {
        DownloadHelper.showDownloadSuccess(
          context,
          result,
        );
      }
    } catch (e) {
      // Don't show error if user cancelled
      if (!e.toString().contains('cancelled')) {
        DownloadHelper.showDownloadError(
          context,
          e.toString(),
        );
      }
    } finally {
      _isExporting = false;
    }
  }

  void _showExportPreview() {
    final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);

    // Create User object from UserProvider data
    final user = User.create(
      firstName: userProvider.firstName,
      lastName: userProvider.lastName,
      email: userProvider.email,
      phone: userProvider.phone,
      address: userProvider.address,
      dateOfBirth: userProvider.dateOfBirth,
      gender: userProvider.gender,
    );

    final preview = _exportService.getExportPreview(
      user: user,
      investments: portfolioProvider.investments,
      featureFlags: AppConstants.featureFlags,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Preview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPreviewItem('User', preview['userName'] ?? 'Unknown'),
              _buildPreviewItem('Email', preview['email'] ?? 'N/A'),
              const SizedBox(height: UIConstants.spacing16),
              _buildPreviewItem(
                'Total Investments',
                '${preview['totalInvestments']}',
              ),
              if (preview['investmentTypes'] != null)
                _buildPreviewItem(
                  'Investment Types',
                  (preview['investmentTypes'] as List).join(', '),
                ),
              const SizedBox(height: UIConstants.spacing16),
              const Text(
                'This will export all your investment data including:\n'
                '• Personal information\n'
                '• All investment records\n'
                '• Calculated values and returns\n'
                '• Summary statistics',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _handleExport();
            },
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  bool get isExporting => _isExporting;

  void deleteAccount() {
    DeleteAccountDialog.show(
      context,
      onDeleteConfirmed: () => accountManager.deleteAccount(context),
    );
  }

  void logout() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Directly navigate to login screen
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteConfig.login,
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}