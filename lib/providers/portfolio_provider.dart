import 'package:flutter/material.dart';
import 'package:saver/constants/app_constants.dart';
import '../models/investment.dart';
import '../data/sample_investments.dart';
import '../services/investment_calculator.dart';
import '../services/local_storage_service.dart';
import 'package:provider/provider.dart';
import 'feature_flags_provider.dart';

class PortfolioProvider extends ChangeNotifier {
  List<Investment> _investments = [];
  LocalStorageService? _storageService;
  bool _isLoaded = false;

  List<Investment> get investments => List.unmodifiable(_investments);
  bool get isLoaded => _isLoaded;

  // Initialize the provider and load data
  Future<void> initialize() async {
    if (_isLoaded) return;

    _storageService = await LocalStorageService.getInstance();
    await _loadInvestments();
    _isLoaded = true;
    notifyListeners();
  }

  // Load investments from storage
  Future<void> _loadInvestments() async {
    try {
      final hasData = await _storageService!.hasInvestmentData();

      if (hasData) {
        // Load existing data
        _investments = await _storageService!.loadInvestments();
      } else {
        // First time user - load sample data if enabled
        _investments = SampleInvestments.getInitialInvestments();
        if (_investments.isNotEmpty) {
          await _saveInvestments();
        }
      }
    } catch (e) {
      print('Error loading investments: $e');
      _investments = [];
    }
  }

  // Save investments to storage
  Future<void> _saveInvestments() async {
    try {
      await _storageService?.saveInvestments(_investments);
    } catch (e) {
      print('Error saving investments: $e');
    }
  }

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

  Future<void> addInvestment(Investment investment) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }
    
    _investments.add(investment);
    await _saveInvestments();
    notifyListeners();
  }

  Future<void> deleteInvestment(Investment investment) async {
    // Ensure storage service is initialized
    if (_storageService == null) {
      await initialize();
    }
    
    _investments.remove(investment);
    await _saveInvestments();
    notifyListeners();
  }

  // Clear all portfolio data (including storage)
  Future<void> clearPortfolio() async {
    _investments.clear();
    await _saveInvestments(); // This will save empty list to storage
    notifyListeners();
  }

  // Update an existing investment
  Future<void> updateInvestment(Investment oldInvestment, Investment newInvestment) async {
    final index = _investments.indexOf(oldInvestment);
    if (index != -1) {
      _investments[index] = newInvestment;
      await _saveInvestments();
      notifyListeners();
    }
  }

  // Export data for backup
  Future<Map<String, dynamic>> exportData() async {
    return {
      'investments': _investments.map((inv) => inv.toMap()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': AppConstants.appVersion,
    };
  }

  // Import data from backup
  Future<bool> importData(Map<String, dynamic> data) async {
    try {
      final List<dynamic> investmentMaps = data['investments'] ?? [];
      _investments = investmentMaps.map((map) => Investment.fromMap(map)).toList();
      await _saveInvestments();
      notifyListeners();
      return true;
    } catch (e) {
      print('Error importing data: $e');
      return false;
    }
  }
}
