import 'package:flutter/material.dart';
import '../models/investment.dart';
import '../repositories/investment_repository.dart';
import '../services/investment_filter_service.dart';
import '../services/investment_calculator.dart';

/// Refactored PortfolioProvider following SOLID principles
/// - Single Responsibility: Only manages portfolio state
/// - Dependency Inversion: Depends on InvestmentRepository abstraction
/// - Business logic delegated to services
class PortfolioProvider extends ChangeNotifier {
  final InvestmentRepository _repository;
  final InvestmentFilterService _filterService;
  
  List<Investment> _investments = [];
  bool _isLoaded = false;

  PortfolioProvider({
    required InvestmentRepository repository,
    InvestmentFilterService? filterService,
  })  : _repository = repository,
        _filterService = filterService ?? InvestmentFilterService();

  List<Investment> get investments => List.unmodifiable(_investments);
  bool get isLoaded => _isLoaded;

  /// Initialize the provider and load data
  Future<void> initialize() async {
    if (_isLoaded) return;

    await _loadInvestments();
    _isLoaded = true;
    notifyListeners();
  }

  /// Load investments from repository
  Future<void> _loadInvestments() async {
    try {
      final hasData = await _repository.hasData();

      if (hasData) {
        _investments = await _repository.getAll();
      } else {
        _investments = [];
      }
    } catch (e) {
      print('Error loading investments: $e');
      _investments = [];
    }
  }

  /// Get active investments with feature flags applied
  List<Investment> activeInvestmentsWithFlags(
    Map<String, dynamic>? featureFlags,
  ) {
    return _filterService.filterActiveWithFlags(_investments, featureFlags);
  }

  /// Get investment count by type with feature flags
  int getInvestmentCountWithFlags(
    String type,
    Map<String, dynamic>? featureFlags,
  ) {
    final active = activeInvestmentsWithFlags(featureFlags);
    return _filterService.filterByType(active, type).length;
  }

  /// Get total amount by type with feature flags
  double getTotalAmountByTypeWithFlags(
    String type,
    Map<String, dynamic>? featureFlags,
  ) {
    final active = activeInvestmentsWithFlags(featureFlags);
    final ofType = _filterService.filterByType(active, type);
    return ofType.fold(
      0.0,
      (sum, investment) => sum + investment.currentBalance,
    );
  }

  /// Get total investment with feature flags
  double totalInvestmentWithFlags(Map<String, dynamic>? featureFlags) {
    final active = activeInvestmentsWithFlags(featureFlags);
    return active.fold(
      0.0,
      (sum, investment) => sum + investment.currentBalance,
    );
  }

  /// Get total returns with feature flags
  double totalReturnsWithFlags(Map<String, dynamic>? featureFlags) {
    final active = activeInvestmentsWithFlags(featureFlags);
    return active.fold(
      0.0,
      (sum, investment) => sum + investment.returns,
    );
  }

  /// Calculate XIRR with feature flags
  double xirrWithFlags(Map<String, dynamic>? featureFlags) {
    final active = activeInvestmentsWithFlags(featureFlags);
    final amounts = active.map((e) => e.amount).toList();
    final interests = active.map((e) => e.interest).toList();
    return InvestmentCalculator.calculateXIRR(
      amounts,
      interests,
      totalInvestmentWithFlags(featureFlags),
    );
  }

  /// Calculate absolute returns with feature flags
  double absoluteReturnsWithFlags(Map<String, dynamic>? featureFlags) {
    final active = activeInvestmentsWithFlags(featureFlags);
    final currentValue = active.fold(
      0.0,
      (sum, investment) => sum + investment.currentBalance,
    );

    final invested = active.fold(0.0, (sum, investment) {
      if (investment.isRecurring &&
          investment.startDate != null &&
          investment.durationInMonths != null) {
        final now = DateTime.now();
        final monthsElapsed =
            now.difference(investment.startDate!).inDays / 30;
        final actualMonths = monthsElapsed.floor();
        int depositsMade = actualMonths + 1;
        if (depositsMade > investment.durationInMonths!) {
          depositsMade = investment.durationInMonths!;
        }
        return sum + (investment.amount * depositsMade);
      } else {
        return sum + investment.amount;
      }
    });

    return InvestmentCalculator.calculateAbsoluteReturns(
      currentValue,
      invested,
    );
  }

  /// Add investment
  Future<void> addInvestment(Investment investment) async {
    await _repository.add(investment);
    _investments.add(investment);
    notifyListeners();
  }

  /// Delete investment
  Future<void> deleteInvestment(Investment investment) async {
    await _repository.delete(investment.id);
    _investments.remove(investment);
    notifyListeners();
  }

  /// Update an existing investment
  Future<void> updateInvestment(
    Investment oldInvestment,
    Investment newInvestment,
  ) async {
    final index = _investments.indexOf(oldInvestment);
    if (index != -1) {
      await _repository.update(newInvestment);
      _investments[index] = newInvestment;
      notifyListeners();
    }
  }

  /// Clear all portfolio data
  Future<void> clearPortfolio() async {
    _investments.clear();
    await _repository.clear();
    notifyListeners();
  }
}
