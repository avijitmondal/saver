import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/investment.dart';
import '../models/user.dart';

class DataExportService {
  /// Export all user data to JSON format
  static Map<String, dynamic> exportUserData({
    required User? user,
    required List<Investment> investments,
    Map<String, dynamic>? featureFlags,
  }) {
    // Filter investments based on feature flags
    final filteredInvestments = _filterInvestments(investments, featureFlags);
    
    final exportData = {
      'metadata': {
        'exportDate': DateTime.now().toIso8601String(),
        'appVersion': '1.0.4',
        'dataVersion': '1.0',
      },
      'user': user != null ? _userToExportMap(user) : null,
      'investments': filteredInvestments.map((inv) => _investmentToExportMap(inv)).toList(),
    };

    return exportData;
  }

  /// Filter investments based on feature flags
  static List<Investment> _filterInvestments(
    List<Investment> investments,
    Map<String, dynamic>? flags,
  ) {
    if (flags == null) return investments;

    return investments.where((investment) {
      // Filter EPF if disabled
      if (investment.type == 'EPF' &&
          !(flags['employeeProvidentFundInvestment'] ?? true)) {
        return false;
      }
      // Filter PPF if disabled
      if (investment.type == 'PPF' &&
          !(flags['publicProvidentFundInvestment'] ?? true)) {
        return false;
      }
      // Filter Fixed Deposit if disabled
      if (investment.type == 'Fixed Deposit' &&
          !(flags['fixedDepositInvestment'] ?? true)) {
        return false;
      }
      // Filter Recurring Deposit if disabled
      if (investment.type == 'Recurring Deposit' &&
          !(flags['recurringDepositInvestment'] ?? true)) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Convert User to export format (excludes passwordHash)
  static Map<String, dynamic> _userToExportMap(User user) {
    return {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'phone': user.phone,
      'address': user.address,
      'dateOfBirth': user.dateOfBirth.toIso8601String(),
    };
  }

  /// Convert Investment to a more readable export format (excludes calculated values)
  static Map<String, dynamic> _investmentToExportMap(Investment investment) {
    return {
      'id': investment.id,
      'type': investment.type,
      'amount': investment.amount,
  // Annual interest rate
  'interest': investment.interest,
      'bank': investment.bank,
      'startDate': investment.startDate?.toIso8601String(),
      'durationInMonths': investment.durationInMonths,
      'compoundingFrequency': investment.compoundingFrequency,
      'isRecurring': investment.isRecurring,
      'notes': investment.notes,
      'iconCodePoint': investment.icon.codePoint,
      'colorValue': investment.color.value,
    };
  }

  /// Generate a formatted JSON string
  static String generateJsonString(Map<String, dynamic> data, {bool pretty = true}) {
    if (pretty) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    }
    return jsonEncode(data);
  }

  /// Generate filename with timestamp
  static String generateFilename({String prefix = 'saver_export'}) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '${prefix}_$timestamp.json';
  }

  /// Save JSON data to file (for mobile/desktop)
  static Future<File> saveToFile(String jsonData, String filePath) async {
    final file = File(filePath);
    await file.writeAsString(jsonData);
    return file;
  }

  /// Trigger download for web platform
  static void downloadForWeb(String jsonData, String filename) {
    if (kIsWeb) {
      // Web download will be handled by the UI layer using dart:html
      // This is a placeholder for the service layer
      throw UnimplementedError('Use download_service for web downloads');
    }
  }

  /// Get export preview (limited data for showing to user before export)
  static Map<String, dynamic> getExportPreview({
    required User? user,
    required List<Investment> investments,
    Map<String, dynamic>? featureFlags,
  }) {
    // Filter investments based on feature flags
    final filteredInvestments = _filterInvestments(investments, featureFlags);
    
    return {
      'userName': user != null ? '${user.firstName} ${user.lastName}' : 'Unknown',
      'email': user?.email ?? 'N/A',
      'totalInvestments': filteredInvestments.length,
      'investmentTypes': filteredInvestments.map((inv) => inv.type).toSet().toList(),
      'dateRange': {
        'earliest': filteredInvestments
            .where((inv) => inv.startDate != null)
            .map((inv) => inv.startDate!)
            .fold<DateTime?>(
              null,
              (earliest, date) => earliest == null || date.isBefore(earliest) ? date : earliest,
            )
            ?.toIso8601String(),
        'latest': filteredInvestments
            .where((inv) => inv.maturityDate != null)
            .map((inv) => inv.maturityDate!)
            .fold<DateTime?>(
              null,
              (latest, date) => latest == null || date.isAfter(latest) ? date : latest,
            )
            ?.toIso8601String(),
      },
    };
  }
}
