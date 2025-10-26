import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/investment_calculator.dart';

class Investment {
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

  const Investment({
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
  });

  double get returns {
    try {
      return InvestmentCalculator.calculateReturns(amount, interest, durationInMonths: durationInMonths);
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
    };
  }

  static Investment fromMap(Map<String, dynamic> map) {
    return Investment(
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
}
