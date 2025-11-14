import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/ppf_payment.dart';
import '../constants/app_constants.dart';
import '../data/sample_ppf_payments.dart';

/// Abstraction for PPF payment storage.
/// Mirrors investment storage factory approach allowing sample vs persistent implementations.
abstract class PPFPaymentStorageService {
  Future<List<PPFPayment>> loadPayments(String accountId);
  Future<void> savePayments(String accountId, List<PPFPayment> payments);
  Future<void> clearPayments(String accountId);
  Future<void> clearAll();
}

/// SharedPreferences implementation of PPF payment storage (production mode).
class SharedPreferencesPPFPaymentStorage implements PPFPaymentStorageService {
  static const String _keyPrefix = 'ppf_payments_';
  final SharedPreferences _prefs;
  SharedPreferencesPPFPaymentStorage._(this._prefs);
  static Future<SharedPreferencesPPFPaymentStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesPPFPaymentStorage._(prefs);
  }
  String _getKey(String accountId) => '$_keyPrefix$accountId';
  @override
  Future<List<PPFPayment>> loadPayments(String accountId) async {
    try {
      final jsonString = _prefs.getString(_getKey(accountId));
      if (jsonString == null) return [];
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => PPFPayment.fromMap(json)).toList();
    } catch (e) {
      print('Error loading PPF payments: $e');
      return [];
    }
  }
  @override
  Future<void> savePayments(String accountId, List<PPFPayment> payments) async {
    try {
      final jsonList = payments.map((p) => p.toMap()).toList();
      await _prefs.setString(_getKey(accountId), json.encode(jsonList));
    } catch (e) {
      print('Error saving PPF payments: $e');
      throw Exception('Failed to save PPF payments');
    }
  }
  @override
  Future<void> clearPayments(String accountId) async {
    try {
      await _prefs.remove(_getKey(accountId));
    } catch (e) {
      print('Error clearing PPF payments: $e');
      throw Exception('Failed to clear PPF payments');
    }
  }
  @override
  Future<void> clearAll() async {
    try {
      final keys = _prefs.getKeys().where((k) => k.startsWith(_keyPrefix));
      for (var key in keys) {
        await _prefs.remove(key);
      }
    } catch (e) {
      print('Error clearing all PPF payments: $e');
      throw Exception('Failed to clear all PPF payments');
    }
  }
}

/// Sample data (in-memory) implementation for demo mode; non-persistent and resettable.
class SampleDataPPFPaymentStorage implements PPFPaymentStorageService {
  // Keyed by accountId
  final Map<String, List<PPFPayment>> _data = {};

  List<PPFPayment> _initialData(String accountId) {
    // Use sample payments provider and clone to avoid external mutation.
    return SamplePPFPayments.getPaymentsForAccount(accountId)
        .map((p) => p.copyWith())
        .toList();
  }

  @override
  Future<List<PPFPayment>> loadPayments(String accountId) async {
    return _data.putIfAbsent(accountId, () => _initialData(accountId));
  }
  @override
  Future<void> savePayments(String accountId, List<PPFPayment> payments) async {
    _data[accountId] = List.of(payments);
  }
  @override
  Future<void> clearPayments(String accountId) async {
    _data.remove(accountId);
  }
  @override
  Future<void> clearAll() async {
    _data.clear();
  }
}

/// Factory selecting appropriate PPF payment storage based on feature flags (`AppConstants.sampleData`).
class PPFPaymentStorageFactory {
  static Future<PPFPaymentStorageService> create() async {
    final useSampleData = AppConstants.sampleData;
    if (useSampleData) {
      return SampleDataPPFPaymentStorage();
    } else {
      return await SharedPreferencesPPFPaymentStorage.create();
    }
  }
}
