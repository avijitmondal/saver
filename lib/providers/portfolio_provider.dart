import 'package:flutter/material.dart';
import 'package:saver/constants/app_constants.dart';
import '../models/investment.dart';
import '../data/sample_investments.dart';
import '../services/investment_calculator.dart';
import 'package:provider/provider.dart';
import 'feature_flags_provider.dart';

class PortfolioProvider extends ChangeNotifier {
  final List<Investment> _investments =
      SampleInvestments.getInitialInvestments();

  List<Investment> get investments => List.unmodifiable(_investments);

  // Get only active (non-matured) investments
  List<Investment> activeInvestmentsWithFlags(BuildContext context) {
    final flags = Provider.of<FeatureFlagsProvider>(context, listen: false).flags;
    return _investments
        .where((investment) =>
            (investment.type != 'Fixed Deposit' ||
                (flags['fixedDepositInvestment'] ?? true)) &&
            (investment.type != 'Recurring Deposit' ||
                (flags['recurringDepositInvestment'] ?? true)) &&
            (investment.type != 'PPF' ||
                (flags['publicProvidentFundInvestment'] ?? true)) &&
            (investment.type != 'EPF' ||
                (flags['employeeProvidentFundInvestment'] ?? true)) &&
            (investment.maturityDate == null ||
                investment.maturityDate!.isAfter(DateTime.now())))
        .toList();
  }

  int getInvestmentCountWithFlags(BuildContext context, String type) {
    return activeInvestmentsWithFlags(context)
        .where((investment) => investment.type == type)
        .length;
  }

  double getTotalAmountByTypeWithFlags(BuildContext context, String type) {
    return activeInvestmentsWithFlags(context)
        .where((investment) => investment.type == type)
        .fold(0.0, (sum, investment) => sum + investment.currentBalance);
  }

  double totalInvestmentWithFlags(BuildContext context) {
    return activeInvestmentsWithFlags(context).fold(
      0.0,
      (sum, investment) => sum + investment.currentBalance,
    );
  }

  double totalReturnsWithFlags(BuildContext context) {
    return activeInvestmentsWithFlags(context).fold(
      0.0,
      (sum, investment) => sum + investment.returns,
    );
  }

  double xirrWithFlags(BuildContext context) {
    final investments = activeInvestmentsWithFlags(context);
    final amounts = investments.map((e) => e.amount).toList();
    final interests = investments.map((e) => e.interest).toList();
    return InvestmentCalculator.calculateXIRR(
        amounts, interests, totalInvestmentWithFlags(context));
  }

  double absoluteReturnsWithFlags(BuildContext context) {
    return InvestmentCalculator.calculateAbsoluteReturns(
        totalReturnsWithFlags(context), totalInvestmentWithFlags(context));
  }

  // Legacy getters for backward compatibility (if needed)
  List<Investment> get activeInvestments => _investments
      .where((investment) =>
          (investment.type != 'Fixed Deposit' ||
              (AppConstants.featureFlags['fixedDepositInvestment'] ?? true)) &&
          (investment.type != 'Recurring Deposit' ||
              (AppConstants.featureFlags['recurringDepositInvestment'] ?? true)) &&
          (investment.type != 'PPF' ||
              (AppConstants.featureFlags['publicProvidentFundInvestment'] ?? true)) &&
          (investment.type != 'EPF' ||
              (AppConstants.featureFlags['employeeProvidentFundInvestment'] ?? true)) &&
          (investment.maturityDate == null ||
              investment.maturityDate!.isAfter(DateTime.now())))
      .toList();

  int getInvestmentCount(String type) {
    return activeInvestments.where((investment) => investment.type == type).length;
  }

  double getTotalAmountByType(String type) {
    double total = 0;
    final investmentsOfType = _investments.where((inv) => inv.type == type);
    
    for (var investment in investmentsOfType) {
      if (type == 'Recurring Deposit' && 
          investment.isRecurring == true && 
          investment.durationInMonths != null) {
        // For recurring deposits, calculate total deposited amount
        total += investment.amount * investment.durationInMonths!;
      } else {
        // For other investment types, use the amount directly
        total += investment.amount;
      }
    }
    
    return total;
  }

  double get totalInvestment {
    double total = 0;
    for (var investment in _investments) {
      if (investment.type == 'Recurring Deposit' && 
          investment.isRecurring == true && 
          investment.durationInMonths != null) {
        // For recurring deposits, calculate total deposited amount
        total += investment.amount * investment.durationInMonths!;
      } else {
        // For other investment types, use the amount directly
        total += investment.amount;
      }
    }
    return total;
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
