import '../models/investment.dart';
import '../data/sample_investments.dart';
import 'investment_storage_service.dart';

/// Implementation of InvestmentStorageService using in-memory sample data
/// Used when sampleData flag is true (demo/testing mode)
/// All changes are transient and not persisted
class SampleDataInvestmentStorage implements InvestmentStorageService {
  List<Investment>? _cachedInvestments;
  
  @override
  Future<List<Investment>> loadInvestments() async {
    // Cache sample data on first load, return same instance for consistency
    _cachedInvestments ??= SampleInvestments.getInitialInvestments();
    return _cachedInvestments!;
  }
  
  @override
  Future<void> saveInvestments(List<Investment> investments) async {
    // In sample mode, updates are transient (only in memory)
    // Don't persist to SharedPreferences
    _cachedInvestments = investments;
  }
  
  @override
  Future<bool> hasInvestmentData() async {
    // Sample data is always available when this storage is used
    return true;
  }
  
  @override
  Future<void> clearInvestments() async {
    // Clear cache, reload from sample on next load
    _cachedInvestments = null;
  }
}
