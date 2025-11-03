import '../constants/app_constants.dart';
import 'investment_storage_service.dart';
import 'shared_preferences_investment_storage.dart';
import 'sample_data_investment_storage.dart';

/// Factory to create the appropriate InvestmentStorageService implementation
/// based on the sampleData feature flag
class InvestmentStorageFactory {
  /// Creates and returns the appropriate storage service
  /// - SampleDataInvestmentStorage when sampleData is true
  /// - SharedPreferencesInvestmentStorage when sampleData is false
  static Future<InvestmentStorageService> create() async {
  final useSampleData = AppConstants.sampleData;
    
    if (useSampleData) {
      // Demo mode - use in-memory sample data
      return SampleDataInvestmentStorage();
    } else {
      // Production mode - use SharedPreferences
      return await SharedPreferencesInvestmentStorage.create();
    }
  }
}
