import '../models/investment.dart';

/// Abstract interface for investment storage
/// Implementations can use different backends (SharedPreferences, sample data, database, etc.)
abstract class InvestmentStorageService {
  /// Load investments from storage
  Future<List<Investment>> loadInvestments();
  
  /// Save investments to storage
  Future<void> saveInvestments(List<Investment> investments);
  
  /// Check if storage has any investment data
  Future<bool> hasInvestmentData();
  
  /// Clear all investment data from storage
  Future<void> clearInvestments();
}
