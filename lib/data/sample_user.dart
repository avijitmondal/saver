import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SampleUser {
  // Sample user data
  static const String firstName = 'Avijit';
  static const String lastName = 'Mondal';
  static const String email = 'avijit@avijitmondal.com';
  static const String phone = '9876543210';
  static const String address = '123 Street, Kolkata City';
  static final DateTime dateOfBirth = DateTime(1990, 1, 1);
  static const String password = 'password123'; // This will be hashed by UserProvider

  /// Populates the UserProvider with sample user data
  static void populateUserProvider(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Set sample user data
    userProvider.updateUserData(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
    );
    
    // Set sample date of birth
    userProvider.updateDateOfBirth(dateOfBirth);
    
    // Set sample password (will be hashed by UserProvider)
    userProvider.setPassword(password);
  }
} 