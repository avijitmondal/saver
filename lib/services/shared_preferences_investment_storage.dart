import '../models/investment.dart';
import '../services/local_storage_service.dart';
import 'investment_storage_service.dart';

/// Implementation of InvestmentStorageService using SharedPreferences
/// Used when sampleInvestmentData flag is false (production mode)
class SharedPreferencesInvestmentStorage implements InvestmentStorageService {
  final LocalStorageService _localStorageService;
  
  SharedPreferencesInvestmentStorage(this._localStorageService);
  
  static Future<SharedPreferencesInvestmentStorage> create() async {
    final localStorage = await LocalStorageService.getInstance();
    return SharedPreferencesInvestmentStorage(localStorage);
  }
  
  @override
  Future<List<Investment>> loadInvestments() async {
    return await _localStorageService.loadInvestments();
  }
  
  @override
  Future<void> saveInvestments(List<Investment> investments) async {
    await _localStorageService.saveInvestments(investments);
  }
  
  @override
  Future<bool> hasInvestmentData() async {
    return await _localStorageService.hasInvestmentData();
  }
  
  @override
  Future<void> clearInvestments() async {
    await _localStorageService.saveInvestments([]);
  }
}
