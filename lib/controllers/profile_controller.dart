import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import '../services/account_manager.dart';
import '../config/route_config.dart';
import '../services/dialog_service.dart';
import '../widgets/profile/delete_account_dialog.dart';

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
    // Implement password change logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change password feature not implemented yet'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void exportData() {
    accountManager.exportData(context);
  }

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