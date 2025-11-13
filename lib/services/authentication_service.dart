import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Service for authentication-related operations
/// Follows Single Responsibility Principle - only handles authentication logic
class AuthenticationService {
  /// Hash a password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Validate a password against stored hash
  bool validatePassword(String password, String storedHash) {
    final hash = hashPassword(password);
    return hash == storedHash;
  }

  /// Check password strength
  PasswordStrength checkPasswordStrength(String password) {
    if (password.length < 6) {
      return PasswordStrength.weak;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int strengthScore = 0;
    if (hasUppercase) strengthScore++;
    if (hasLowercase) strengthScore++;
    if (hasDigit) strengthScore++;
    if (hasSpecialChar) strengthScore++;

    if (password.length >= 12 && strengthScore >= 3) {
      return PasswordStrength.strong;
    } else if (password.length >= 8 && strengthScore >= 2) {
      return PasswordStrength.medium;
    }

    return PasswordStrength.weak;
  }
}

/// Password strength levels
enum PasswordStrength {
  weak,
  medium,
  strong,
}
