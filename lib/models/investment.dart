import 'package:flutter/material.dart';
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

  double get returns => InvestmentCalculator.calculateReturns(amount, interest);

  double get returnsPercentage =>
      InvestmentCalculator.calculateReturnsPercentage(returns, amount);

  double get currentBalance => InvestmentCalculator.calculateCurrentBalance(
        amount: amount,
        interest: interest,
        startDate: startDate,
        durationInMonths: durationInMonths,
        isRecurring: isRecurring,
      );

  DateTime? get maturityDate {
    if (startDate == null || durationInMonths == null) return null;
    return startDate!.add(Duration(days: durationInMonths! * 30));
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
    if (startDate == null || durationInMonths == null) return 'N/A';
    final now = DateTime.now();
    if (now.isAfter(maturityDate!)) {
      return 'Matured';
    }
    final remainingDays = maturityDate!.difference(now).inDays;
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
  }
  
  String get maturityStatus {
    if (startDate == null || durationInMonths == null) return 'N/A';
    final now = DateTime.now();
    if (now.isAfter(maturityDate!)) {
      return 'Matured';
    }
    
    final remainingDays = maturityDate!.difference(now).inDays;
    final totalDays = durationInMonths! * 30;
    final percentComplete = ((totalDays - remainingDays) / totalDays * 100).round();
    
    return '$percentComplete% Complete';
  }
}
