import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../services/local_storage_service.dart';
import '../constants/app_constants.dart';
import '../constants/sample_user_data.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  LocalStorageService? _storageService;
  bool _isLoaded = false;

  // Getters
  bool get isLoaded => _isLoaded;
  bool get isLoggedIn => _user != null;
  String get firstName => _user?.firstName ?? '';
  String get lastName => _user?.lastName ?? '';
  String get fullName => _user?.fullName ?? '';
  String get email => _user?.email ?? '';
  String get phone => _user?.phone ?? '';
  String get address => _user?.address ?? '';
  DateTime get dateOfBirth => _user?.dateOfBirth ?? DateTime.now();
  
  // Theme mode getter - returns string representation
  String get themeMode => _user?.themeMode ?? 'system';
  
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
      if (AppConstants.sampleData) {
        // Use sample data (in-memory only, not persisted)
        _user = User.fromMap(SampleUserData.sampleUser);
      } else {
        // Load from persistent storage
        final userData = await _storageService!.loadUserData();
        if (userData != null) {
          _user = User.fromMap(userData);
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Save user data to storage
  Future<void> _saveUserData() async {
    try {
      // Only persist to storage if not using sample data
      if (!AppConstants.sampleData) {
        await _storageService?.saveUserData(_user?.toMap() ?? {});
      }
      // If sampleData is true, data stays in-memory only
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

    _user = User.create(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      dateOfBirth: dateOfBirth,
      passwordHash: _hashPassword(password),
    );
    
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

    if (_user == null) return;

    _user = _user!.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
    );
    
    await _saveUserData();
    notifyListeners();
  }

  // Update date of birth
  Future<void> updateDateOfBirth(DateTime dateOfBirth) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }

    if (_user == null) return;

    _user = _user!.copyWith(dateOfBirth: dateOfBirth);
    await _saveUserData();
    notifyListeners();
  }

  // Set password
  Future<void> setPassword(String password) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }

    if (_user == null) return;

    _user = _user!.copyWith(passwordHash: _hashPassword(password));
    await _saveUserData();
    notifyListeners();
  }

  // Update theme mode
  Future<void> updateThemeMode(String mode) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }

    if (_user == null) return;

    // Validate mode is one of: 'system', 'light', 'dark'
    if (!['system', 'light', 'dark'].contains(mode)) {
      mode = 'system';
    }

    _user = _user!.copyWith(themeMode: mode);
    await _saveUserData();
    notifyListeners();
  }

  // Validate password
  bool validatePassword(String password) {
    final storedHash = _user?.passwordHash;
    if (storedHash == null) return false;
    return storedHash == _hashPassword(password);
  }

  // Clear user data (including storage)
  Future<void> clearUserData() async {
    _user = null;
    await _storageService?.clearAllData();
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _user = null;
    await _storageService?.clearAllData();
    notifyListeners();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

