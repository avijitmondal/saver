import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  DateTime _dateOfBirth = DateTime.now();
  String _password = ''; // This will store the hashed password

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get fullName => '$_firstName $_lastName'.trim();
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  DateTime get dateOfBirth => _dateOfBirth;
  bool get hasPassword => _password.isNotEmpty;

  // Update user data with a more flexible approach
  void updateUserData({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
  }) {
    if (firstName != null) _firstName = firstName;
    if (lastName != null) _lastName = lastName;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (address != null) _address = address;
    notifyListeners();
  }

  void updateDateOfBirth(DateTime date) {
    _dateOfBirth = date;
    notifyListeners();
  }
  
  // Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert to bytes
    final digest = sha256.convert(bytes); // Apply SHA-256 hashing
    return digest.toString(); // Return the hash as a string
  }
  
  // Set password - now encrypts the password before storing
  void setPassword(String password) {
    _password = _hashPassword(password);
    notifyListeners();
  }
  
  // Validate password - now hashes the input password before comparing
  bool validatePassword(String password) {
    final hashedPassword = _hashPassword(password);
    return _password == hashedPassword;
  }

  // Clear all user data
  void clearUserData() {
    _firstName = '';
    _lastName = '';
    _email = '';
    _phone = '';
    _address = '';
    _dateOfBirth = DateTime.now();
    _password = '';
    notifyListeners();
  }
}
