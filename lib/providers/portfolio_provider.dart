import 'package:flutter/material.dart';
import 'package:saver/constants/app_constants.dart';
import '../models/investment.dart';
import '../data/sample_investments.dart';
import '../services/investment_calculator.dart';

class PortfolioProvider extends ChangeNotifier {
  final List<Investment> _investments =
      SampleInvestments.getInitialInvestments();

  List<Investment> get investments => List.unmodifiable(_investments);

  // Get only active (non-matured) investments
  List<Investment> get activeInvestments => _investments
      .where((investment) =>
          (investment.type != 'Fixed Deposit' ||
              (AppConstants.featureFlags['enableFixedDepositInvestment'] ?? true)) &&
          (investment.type != 'Recurring Deposit' ||
              (AppConstants.featureFlags['enableRecurringDepositInvestment'] ?? true)) &&
          (investment.type != 'PPF' ||
              (AppConstants.featureFlags['enablePublicProvidentFundInvestment'] ?? true)) &&
          (investment.type != 'EPF' ||
              (AppConstants.featureFlags['enableEmployeeProvidentFundInvestment'] ?? true)) &&
          (investment.maturityDate == null ||
              investment.maturityDate!.isAfter(DateTime.now())))
      .toList();

  int getInvestmentCount(String type) {
    return activeInvestments.where((investment) => investment.type == type).length;
  }

  double getTotalAmountByType(String type) {
    return activeInvestments
        .where((investment) => investment.type == type)
        .fold(0.0, (sum, investment) => sum + investment.currentBalance);
  }

  double get totalInvestment {
    return activeInvestments.fold(
      0.0,
      (sum, investment) => sum + investment.currentBalance,
    );
  }

  double get totalReturns {
    return activeInvestments.fold(
      0.0,
      (sum, investment) => sum + investment.returns,
    );
  }

  double get xirr {
    final amounts = activeInvestments.map((e) => e.amount).toList();
    final interests = activeInvestments.map((e) => e.interest).toList();
    return InvestmentCalculator.calculateXIRR(
        amounts, interests, totalInvestment);
  }

  double get absoluteReturns {
    return InvestmentCalculator.calculateAbsoluteReturns(
        totalReturns, totalInvestment);
  }

  void addInvestment(Investment investment) {
    _investments.add(investment);
    notifyListeners();
  }

  void deleteInvestment(Investment investment) {
    _investments.remove(investment);
    notifyListeners();
  }

  // Clear all portfolio data
  void clearPortfolio() {
    _investments.clear();
    notifyListeners();
  }
}
