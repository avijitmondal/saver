import 'package:flutter/material.dart';
import '../models/ppf_payment.dart';
import '../repositories/ppf_payment_repository.dart';
import '../data/sample_ppf_payments.dart';
import '../constants/app_constants.dart';

/// Provider for managing PPF payment state
/// Handles both sample data mode and persistent storage mode
class PPFPaymentProvider extends ChangeNotifier {
  final PPFPaymentRepository _repository;
  
  // In-memory storage for sample data mode
  final Map<String, List<PPFPayment>> _sampleModePayments = {};
  
  PPFPaymentProvider({
    required PPFPaymentRepository repository,
  }) : _repository = repository;

  /// Get payments for a specific account
  Future<List<PPFPayment>> getPaymentsForAccount(String accountId) async {
    if (AppConstants.sampleData) {
      // Sample data mode: return sample data + in-memory additions
      if (!_sampleModePayments.containsKey(accountId)) {
        _sampleModePayments[accountId] = [];
      }
      
      final samplePayments = SamplePPFPayments.getPaymentsForAccount(accountId);
      final additionalPayments = _sampleModePayments[accountId] ?? [];
      
      return [...samplePayments, ...additionalPayments];
    } else {
      // Production mode: use repository
      return await _repository.getPaymentsForAccount(accountId);
    }
  }

  /// Add a single payment
  Future<void> addPayment(String accountId, PPFPayment payment) async {
    if (AppConstants.sampleData) {
      // Sample data mode: store in memory
      if (!_sampleModePayments.containsKey(accountId)) {
        _sampleModePayments[accountId] = [];
      }
      _sampleModePayments[accountId]!.add(payment);
      notifyListeners();
    } else {
      // Production mode: persist to storage
      await _repository.addPayment(accountId, payment);
      notifyListeners();
    }
  }

  /// Add multiple payments (for recurring)
  Future<void> addPayments(String accountId, List<PPFPayment> payments) async {
    if (AppConstants.sampleData) {
      // Sample data mode: store in memory
      if (!_sampleModePayments.containsKey(accountId)) {
        _sampleModePayments[accountId] = [];
      }
      _sampleModePayments[accountId]!.addAll(payments);
      notifyListeners();
    } else {
      // Production mode: persist to storage
      await _repository.addPayments(accountId, payments);
      notifyListeners();
    }
  }

  /// Delete a single payment
  Future<void> deletePayment(String accountId, PPFPayment payment) async {
    if (AppConstants.sampleData) {
      // Sample data mode: remove from memory
      if (_sampleModePayments.containsKey(accountId)) {
        _sampleModePayments[accountId]!.removeWhere((p) =>
          p.date == payment.date &&
          p.amount == payment.amount &&
          p.status == payment.status
        );
        notifyListeners();
      }
    } else {
      // Production mode: delete from storage
      await _repository.deletePayment(accountId, payment);
      notifyListeners();
    }
  }

  /// Delete multiple payments (for recurring schedule)
  Future<void> deletePayments(String accountId, List<PPFPayment> payments) async {
    if (AppConstants.sampleData) {
      // Sample data mode: remove from memory
      if (_sampleModePayments.containsKey(accountId)) {
        for (var payment in payments) {
          _sampleModePayments[accountId]!.removeWhere((p) =>
            p.date == payment.date &&
            p.amount == payment.amount &&
            p.status == payment.status
          );
        }
        notifyListeners();
      }
    } else {
      // Production mode: delete from storage
      await _repository.deletePayments(accountId, payments);
      notifyListeners();
    }
  }

  /// Clear all in-memory sample data (for testing)
  void clearSampleData() {
    _sampleModePayments.clear();
    notifyListeners();
  }
}
