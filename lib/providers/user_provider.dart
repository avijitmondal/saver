import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../services/authentication_service.dart';
import '../constants/app_constants.dart';
import '../constants/sample_user_data.dart';

/// Refactored UserProvider following SOLID principles
/// - Single Responsibility: Only manages user state
/// - Dependency Inversion: Depends on UserRepository abstraction
/// - Removed business logic (moved to services)
class UserProvider extends ChangeNotifier {
  final UserRepository _repository;
  final AuthenticationService _authService;
  
  User? _user;
  bool _isLoaded = false;

  UserProvider({
    required UserRepository repository,
    required AuthenticationService authService,
  })  : _repository = repository,
        _authService = authService;

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
  String get themeMode => _user?.themeMode ?? 'system';
  String get gender => _user?.gender ?? '';

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

  /// Initialize and load user data
  Future<void> initialize() async {
    if (_isLoaded) return;

    await _loadUserData();
    _isLoaded = true;
    notifyListeners();
  }

  /// Load user data from repository
  Future<void> _loadUserData() async {
    try {
      if (AppConstants.sampleData) {
        // Use sample data (in-memory only, not persisted)
        _user = User.fromMap(SampleUserData.sampleUser);
      } else {
        // Load from persistent storage via repository
        _user = await _repository.getUser();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  /// Save user data to repository
  Future<void> _saveUserData() async {
    try {
      if (_user != null && !AppConstants.sampleData) {
        await _repository.saveUser(_user!);
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  /// Create new user
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    required DateTime dateOfBirth,
    required String password,
    required String gender,
  }) async {
    _user = User.create(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      dateOfBirth: dateOfBirth,
      passwordHash: _authService.hashPassword(password),
      gender: gender,
    );

    await _saveUserData();
    notifyListeners();
  }

  /// Update user data
  Future<void> updateUserData({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
  }) async {
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

  /// Update date of birth
  Future<void> updateDateOfBirth(DateTime dateOfBirth) async {
    if (_user == null) return;

    _user = _user!.copyWith(dateOfBirth: dateOfBirth);
    await _saveUserData();
    notifyListeners();
  }

  /// Set password
  Future<void> setPassword(String password) async {
    if (_user == null) return;

    _user = _user!.copyWith(
      passwordHash: _authService.hashPassword(password),
    );
    await _saveUserData();
    notifyListeners();
  }

  /// Update theme mode
  Future<void> updateThemeMode(String mode) async {
    if (_user == null) return;

    // Validate mode is one of: 'system', 'light', 'dark'
    if (!['system', 'light', 'dark'].contains(mode)) {
      mode = 'system';
    }

    _user = _user!.copyWith(themeMode: mode);
    await _saveUserData();
    notifyListeners();
  }

  /// Validate password
  bool validatePassword(String password) {
    final storedHash = _user?.passwordHash;
    if (storedHash == null) return false;
    return _authService.validatePassword(password, storedHash);
  }

  /// Clear user data (including storage)
  Future<void> clearUserData() async {
    _user = null;
    await _repository.deleteUser();
    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    _user = null;
    await _repository.deleteUser();
    notifyListeners();
  }
}
