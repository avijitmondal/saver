import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/investment.dart';

class LocalStorageService {
  static const String _investmentsKey = 'investments';
  static const String _userDataKey = 'user_data';
  static const String _appVersionKey = 'app_version';
  
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;
  
  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Investment data persistence
  Future<bool> saveInvestments(List<Investment> investments) async {
    try {
      final investmentMaps = investments.map((investment) => investment.toMap()).toList();
      final jsonString = jsonEncode(investmentMaps);
      return await _preferences!.setString(_investmentsKey, jsonString);
    } catch (e) {
      print('Error saving investments: $e');
      return false;
    }
  }

  Future<List<Investment>> loadInvestments() async {
    try {
      final jsonString = _preferences!.getString(_investmentsKey);
      if (jsonString == null) return [];
      
      final List<dynamic> investmentMaps = jsonDecode(jsonString);
      return investmentMaps.map((map) => Investment.fromMap(map)).toList();
    } catch (e) {
      print('Error loading investments: $e');
      return [];
    }
  }

  // User data persistence
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final jsonString = jsonEncode(userData);
      return await _preferences!.setString(_userDataKey, jsonString);
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadUserData() async {
    try {
      final jsonString = _preferences!.getString(_userDataKey);
      if (jsonString == null) return null;
      
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error loading user data: $e');
      return null;
    }
  }

  // App version tracking
  Future<bool> saveAppVersion(String version) async {
    return await _preferences!.setString(_appVersionKey, version);
  }

  Future<String?> getAppVersion() async {
    return _preferences!.getString(_appVersionKey);
  }

  // Clear all data
  Future<bool> clearAllData() async {
    try {
      await _preferences!.remove(_investmentsKey);
      await _preferences!.remove(_userDataKey);
      return true;
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }

  // Check if data exists
  Future<bool> hasInvestmentData() async {
    return _preferences!.containsKey(_investmentsKey);
  }

  Future<bool> hasUserData() async {
    return _preferences!.containsKey(_userDataKey);
  }
}
