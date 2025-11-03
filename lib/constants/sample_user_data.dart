import 'package:crypto/crypto.dart';
import 'dart:convert';

class SampleUserData {
  // Sample user data - single user profile for demo/testing
  static final Map<String, dynamic> sampleUser = {
    'firstName': 'John',
    'lastName': 'Doe',
    'email': 'john.doe@example.com',
    'phone': '9876543210',
    'address': '123 Main Street, Mumbai, Maharashtra',
    'dateOfBirth': DateTime(1990, 5, 15).millisecondsSinceEpoch,
    'passwordHash': _hashPassword('password123'),
  };

  // Helper method to hash passwords
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
