import '../models/ppf_payment.dart';

/// Interface for PPF payment data persistence following Repository Pattern
/// Enables dependency inversion and easier testing
abstract class PPFPaymentRepository {
  /// Load all PPF payments for a specific account
  Future<List<PPFPayment>> getPaymentsForAccount(String accountId);
  
  /// Add a single payment
  Future<void> addPayment(String accountId, PPFPayment payment);
  
  /// Add multiple payments (for recurring)
  Future<void> addPayments(String accountId, List<PPFPayment> payments);
  
  /// Delete a payment
  Future<void> deletePayment(String accountId, PPFPayment payment);
  
  /// Delete multiple payments (for recurring schedule)
  Future<void> deletePayments(String accountId, List<PPFPayment> payments);
  
  /// Clear all payments for an account
  Future<void> clearAccount(String accountId);
  
  /// Check if payment data exists for an account
  Future<bool> hasData(String accountId);
}
