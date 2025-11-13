import '../models/investment.dart';

/// Interface for investment data persistence following Repository Pattern
/// Enables dependency inversion and easier testing
abstract class InvestmentRepository {
  /// Load all investments from storage
  Future<List<Investment>> getAll();
  
  /// Save investments to storage
  Future<void> saveAll(List<Investment> investments);
  
  /// Add a single investment
  Future<void> add(Investment investment);
  
  /// Update an existing investment
  Future<void> update(Investment investment);
  
  /// Delete an investment
  Future<void> delete(String investmentId);
  
  /// Clear all investments
  Future<void> clear();
  
  /// Check if investment data exists
  Future<bool> hasData();
}
