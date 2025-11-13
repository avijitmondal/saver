import '../models/investment.dart';
import '../services/investment_storage_service.dart';
import 'investment_repository.dart';

/// Implementation of InvestmentRepository using InvestmentStorageService
/// Follows Dependency Inversion Principle - depends on abstraction
class InvestmentRepositoryImpl implements InvestmentRepository {
  final InvestmentStorageService _storageService;
  List<Investment> _cache = [];

  InvestmentRepositoryImpl(this._storageService);

  @override
  Future<List<Investment>> getAll() async {
    _cache = await _storageService.loadInvestments();
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> saveAll(List<Investment> investments) async {
    _cache = List.from(investments);
    await _storageService.saveInvestments(_cache);
  }

  @override
  Future<void> add(Investment investment) async {
    _cache.add(investment);
    await _storageService.saveInvestments(_cache);
  }

  @override
  Future<void> update(Investment investment) async {
    final index = _cache.indexWhere((inv) => inv.id == investment.id);
    if (index != -1) {
      _cache[index] = investment;
      await _storageService.saveInvestments(_cache);
    }
  }

  @override
  Future<void> delete(String investmentId) async {
    _cache.removeWhere((inv) => inv.id == investmentId);
    await _storageService.saveInvestments(_cache);
  }

  @override
  Future<void> clear() async {
    _cache = [];
    await _storageService.clearInvestments();
  }

  @override
  Future<bool> hasData() async {
    return await _storageService.hasInvestmentData();
  }
}
