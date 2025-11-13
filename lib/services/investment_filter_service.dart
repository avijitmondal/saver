import '../models/investment.dart';

/// Service for filtering investments based on feature flags
/// Follows Single Responsibility Principle - only handles filtering logic
class InvestmentFilterService {
  /// Filter investments based on feature flags
  List<Investment> filterByFeatureFlags(
    List<Investment> investments,
    Map<String, dynamic>? featureFlags,
  ) {
    if (featureFlags == null) return investments;

    return investments.where((investment) {
      return _isInvestmentTypeEnabled(investment.type, featureFlags);
    }).toList();
  }

  /// Filter investments to only active (non-matured) ones
  List<Investment> filterActive(List<Investment> investments) {
    final now = DateTime.now();
    return investments.where((investment) {
      return investment.maturityDate == null ||
          investment.maturityDate!.isAfter(now);
    }).toList();
  }

  /// Filter investments by type
  List<Investment> filterByType(
    List<Investment> investments,
    String type,
  ) {
    return investments.where((inv) => inv.type == type).toList();
  }

  /// Filter active investments considering feature flags
  List<Investment> filterActiveWithFlags(
    List<Investment> investments,
    Map<String, dynamic>? featureFlags,
  ) {
    final filtered = filterByFeatureFlags(investments, featureFlags);
    return filterActive(filtered);
  }

  /// Check if investment type is enabled by feature flags
  bool _isInvestmentTypeEnabled(String type, Map<String, dynamic> flags) {
    switch (type) {
      case 'EPF':
        return flags['employeeProvidentFundInvestment'] ?? true;
      case 'PPF':
        return flags['publicProvidentFundInvestment'] ?? true;
      case 'Fixed Deposit':
        return flags['fixedDepositInvestment'] ?? true;
      case 'Recurring Deposit':
        return flags['recurringDepositInvestment'] ?? true;
      default:
        return true;
    }
  }
}
