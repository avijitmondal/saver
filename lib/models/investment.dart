import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../services/investment_calculator.dart';

class Investment {
  final String id;
  final String type;
  final double amount;
  final double interest;
  final IconData icon;
  final Color color;
  final DateTime? startDate;
  final int? durationInMonths;
  final String? bank;
  final bool isRecurring;
  final String? notes;
  final String compoundingFrequency; // 'quarterly', 'half-yearly', 'yearly'

  const Investment({
    required this.id,
    required this.type,
    required this.amount,
    required this.interest,
    required this.icon,
    required this.color,
    this.startDate,
    this.durationInMonths,
    this.bank,
    this.isRecurring = false,
    this.notes,
    this.compoundingFrequency = 'quarterly',
  });

  // Factory constructor to create investment with auto-generated ID
  factory Investment.create({
    required String type,
    required double amount,
    required double interest,
    required IconData icon,
    required Color color,
    DateTime? startDate,
    int? durationInMonths,
    String? bank,
    bool isRecurring = false,
    String? notes,
    String compoundingFrequency = 'quarterly',
  }) {
    return Investment(
      id: const Uuid().v4(),
      type: type,
      amount: amount,
      interest: interest,
      icon: icon,
      color: color,
      startDate: startDate,
      durationInMonths: durationInMonths,
      bank: bank,
      isRecurring: isRecurring,
      notes: notes,
      compoundingFrequency: compoundingFrequency,
    );
  }

  double get returns {
    try {
      return InvestmentCalculator.calculateReturns(
        amount,
        interest,
        durationInMonths: durationInMonths,
        compoundingPerYear: _compoundingPerYear,
      );
    } catch (e) {
      print('Error calculating returns: $e');
      return 0.0;
    }
  }

  double get returnsPercentage {
    try {
      return InvestmentCalculator.calculateReturnsPercentage(returns, amount, isRecurring: isRecurring, durationInMonths: durationInMonths);
    } catch (e) {
      print('Error calculating returns percentage: $e');
      return 0.0;
    }
  }

  double get currentBalance {
    try {
      return InvestmentCalculator.calculateCurrentBalance(
        amount: amount,
        interest: interest,
        startDate: startDate,
        durationInMonths: durationInMonths,
        isRecurring: isRecurring,
        compoundingPerYear: _compoundingPerYear,
      );
    } catch (e) {
      print('Error calculating current balance: $e');
      return amount;
    }
  }

  DateTime? get maturityDate {
    try {
      if (startDate == null || durationInMonths == null) return null;
      return startDate!.add(Duration(days: durationInMonths! * 30));
    } catch (e) {
      print('Error calculating maturity date: $e');
      return null;
    }
  }

  String get duration {
    if (durationInMonths == null) return 'N/A';
    final years = durationInMonths! ~/ 12;
    final months = durationInMonths! % 12;
    String duration = '';
    if (years > 0) {
      duration += '$years year${years > 1 ? 's' : ''}';
      if (months > 0) {
        duration += ' ';
      }
    }
    if (months > 0) {
      duration += '$months month${months > 1 ? 's' : ''}';
    }
    return duration;
  }

  String get remainingDuration {
    try {
      if (startDate == null || durationInMonths == null) return 'N/A';
      final maturity = maturityDate;  // Get maturity date safely
      if (maturity == null) return 'N/A';
      
      final now = DateTime.now();
      if (now.isAfter(maturity)) {
        return 'Matured';
      }
      
      final remainingDays = maturity.difference(now).inDays;
      if (remainingDays < 0) return 'Matured';
      
      final remainingMonths = (remainingDays / 30).floor();
      final years = remainingMonths ~/ 12;
      final months = remainingMonths % 12;
      String duration = '';
      if (years > 0) {
        duration += '$years year${years > 1 ? 's' : ''}';
        if (months > 0) {
          duration += ' ';
        }
      }
      if (months > 0) {
        duration += '$months month${months > 1 ? 's' : ''}';
      }
      if (duration.isEmpty) {
        duration = '$remainingDays day${remainingDays > 1 ? 's' : ''}';
      }
      return 'Matures in $duration';
    } catch (e) {
      print('Error calculating remaining duration: $e');
      return 'N/A';
    }
  }
  
  String get maturityStatus {
    try {
      if (startDate == null || durationInMonths == null) return 'N/A';
      final maturity = maturityDate;  // Get maturity date safely
      if (maturity == null) return 'N/A';
      
      final now = DateTime.now();
      if (now.isAfter(maturity)) {
        return 'Matured';
      }
    
      final remainingDays = maturity.difference(now).inDays;
      if (remainingDays < 0) return 'Matured';
      
      final totalDays = durationInMonths! * 30;
      final percentComplete = ((totalDays - remainingDays) / totalDays * 100).round();
      
      return '$percentComplete% Complete';
    } catch (e) {
      print('Error calculating maturity status: $e');
      return 'N/A';
    }
  }

  // Serialization methods
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'interest': interest,
  'iconCodePoint': icon.codePoint,
  'colorValue': color.value,
      'startDate': startDate?.millisecondsSinceEpoch,
      'durationInMonths': durationInMonths,
      'bank': bank,
      'notes': notes,
      'isRecurring': isRecurring,
      'compoundingFrequency': compoundingFrequency,
    };
  }

  static Investment fromMap(Map<String, dynamic> map) {
    return Investment(
      id: map['id'] ?? const Uuid().v4(), // Generate new ID if missing (for backward compatibility)
      type: map['type'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      interest: (map['interest'] ?? 0.0).toDouble(),
      icon: map['iconCodePoint'] != null
          ? _iconFromCodePoint(map['iconCodePoint'])
          : Icons.account_balance,
      color: map['colorValue'] != null 
          ? Color(map['colorValue'])
          : Colors.blue,
      startDate: map['startDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'])
          : null,
      durationInMonths: map['durationInMonths'],
      bank: map['bank'],
      notes: map['notes'],
      isRecurring: map['isRecurring'] ?? false,
      compoundingFrequency: map['compoundingFrequency'] ?? 'quarterly',
    );
  }

  // JSON serialization
  String toJson() => jsonEncode(toMap());
  
  static Investment fromJson(String jsonString) {
    return fromMap(jsonDecode(jsonString));
  }
  // Helper to map codePoint to constant icons for web compatibility
  static IconData _iconFromCodePoint(int codePoint) {
    switch (codePoint) {
      case 0xe84f:
        return Icons.account_balance;
      case 0xe850:
        return Icons.account_balance_wallet;
      case 0xe8b0:
        return Icons.attach_money;
      default:
        return Icons.account_balance;
    }
  }

  // Internal helper: map frequency string to periods per year
  int get _compoundingPerYear {
    switch (compoundingFrequency.toLowerCase()) {
      case 'quarterly':
        return 4;
      case 'half-yearly':
      case 'semi-annually':
        return 2;
      case 'yearly':
      case 'annual':
        return 1;
      case 'monthly': // future-proofing if added later
        return 12;
      default:
        return 4; // sensible default
    }
  }
}
