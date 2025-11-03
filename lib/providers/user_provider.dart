import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../services/local_storage_service.dart';
import '../constants/app_constants.dart';
import '../constants/sample_user_data.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _userData = {};
  LocalStorageService? _storageService;
  bool _isLoaded = false;

  // Getters
  bool get isLoaded => _isLoaded;
  bool get isLoggedIn => _userData.isNotEmpty;
  String get firstName => _userData['firstName'] ?? '';
  String get lastName => _userData['lastName'] ?? '';
  String get fullName => '$firstName $lastName'.trim();
  String get email => _userData['email'] ?? '';
  String get phone => _userData['phone'] ?? '';
  String get address => _userData['address'] ?? '';
  DateTime get dateOfBirth => _userData['dateOfBirth'] != null 
      ? DateTime.fromMillisecondsSinceEpoch(_userData['dateOfBirth'])
      : DateTime.now();
  
  // Theme mode getter - returns string representation
  String get themeMode => _userData['themeMode'] ?? 'system';
  
  // Convert string to ThemeMode enum
  ThemeMode get themeModeEnum {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Initialize and load user data
  Future<void> initialize() async {
    if (_isLoaded) return;
    
    _storageService = await LocalStorageService.getInstance();
    await _loadUserData();
    _isLoaded = true;
    notifyListeners();
  }

  // Load user data from storage
  Future<void> _loadUserData() async {
    try {
      final userData = await _storageService!.loadUserData();
      if (userData != null) {
        _userData = userData;
  } else if (AppConstants.sampleData) {
        // Load sample user if sampleData enabled and no user data exists
        _userData = Map<String, dynamic>.from(SampleUserData.sampleUser);
        await _saveUserData();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Save user data to storage
  Future<void> _saveUserData() async {
    try {
      await _storageService?.saveUserData(_userData);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Create new user
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    required DateTime dateOfBirth,
    required String password,
  }) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }

    _userData = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'passwordHash': _hashPassword(password),
    };
    
    await _saveUserData();
    notifyListeners();
  }

  // Update user data
  Future<void> updateUserData({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
  }) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }

    if (firstName != null) _userData['firstName'] = firstName;
    if (lastName != null) _userData['lastName'] = lastName;
    if (email != null) _userData['email'] = email;
    if (phone != null) _userData['phone'] = phone;
    if (address != null) _userData['address'] = address;
    
    await _saveUserData();
    notifyListeners();
  }

  // Update date of birth
  Future<void> updateDateOfBirth(DateTime dateOfBirth) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }

    _userData['dateOfBirth'] = dateOfBirth.millisecondsSinceEpoch;
    await _saveUserData();
    notifyListeners();
  }

  // Set password
  Future<void> setPassword(String password) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }

    _userData['passwordHash'] = _hashPassword(password);
    await _saveUserData();
    notifyListeners();
  }

  // Update theme mode
  Future<void> updateThemeMode(String mode) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }

    // Validate mode is one of: 'system', 'light', 'dark'
    if (!['system', 'light', 'dark'].contains(mode)) {
      mode = 'system';
    }

    _userData['themeMode'] = mode;
    await _saveUserData();
    notifyListeners();
  }

  // Validate password
  bool validatePassword(String password) {
    final storedHash = _userData['passwordHash'];
    if (storedHash == null) return false;
    return storedHash == _hashPassword(password);
  }

  // Clear user data (including storage)
  Future<void> clearUserData() async {
    _userData.clear();
    await _storageService?.clearAllData();
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _userData.clear();
    await _storageService?.clearAllData();
    notifyListeners();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

