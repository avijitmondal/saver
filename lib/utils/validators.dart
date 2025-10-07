import '../constants/app_constants.dart';

class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validateIndianPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return 'Please enter a valid Indian mobile number';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (!RegExp(AppConstants.passwordUppercasePattern).hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(AppConstants.passwordLowercasePattern).hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(AppConstants.passwordNumberPattern).hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(AppConstants.passwordSpecialCharPattern).hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateAmount(String? value, {double? minAmount}) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    if (amount <= 0) {
      return 'Amount must be greater than zero';
    }
    if (minAmount != null && amount < minAmount) {
      return 'Minimum amount is ₹${minAmount.toStringAsFixed(0)}';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  static String? validateAge(DateTime? dateOfBirth, {int minAge = 18}) {
    if (dateOfBirth == null) {
      return 'Please select your date of birth';
    }
    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;
    final monthDiff = now.month - dateOfBirth.month;
    final dayDiff = now.day - dateOfBirth.day;
    final exactAge = age - ((monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)) ? 1 : 0);
    
    if (exactAge < minAge) {
      return 'You must be at least $minAge years old';
    }
    return null;
  }
}
