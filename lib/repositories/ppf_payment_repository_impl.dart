import '../models/ppf_payment.dart';
import '../repositories/ppf_payment_repository.dart';
import '../services/ppf_payment_storage_service.dart';

/// Implementation of PPFPaymentRepository using PPFPaymentStorageService
/// Handles actual data persistence through the storage service
class PPFPaymentRepositoryImpl implements PPFPaymentRepository {
  final PPFPaymentStorageService _storageService;

  PPFPaymentRepositoryImpl(this._storageService);

  @override
  Future<List<PPFPayment>> getPaymentsForAccount(String accountId) async {
    return await _storageService.loadPayments(accountId);
  }

  @override
  Future<void> addPayment(String accountId, PPFPayment payment) async {
    final payments = await getPaymentsForAccount(accountId);
    payments.add(payment);
    await _storageService.savePayments(accountId, payments);
  }

  @override
  Future<void> addPayments(String accountId, List<PPFPayment> newPayments) async {
    final payments = await getPaymentsForAccount(accountId);
    payments.addAll(newPayments);
    await _storageService.savePayments(accountId, payments);
  }

  @override
  Future<void> deletePayment(String accountId, PPFPayment payment) async {
    final payments = await getPaymentsForAccount(accountId);
    payments.removeWhere((p) => 
      p.date == payment.date && 
      p.amount == payment.amount &&
      p.status == payment.status
    );
    await _storageService.savePayments(accountId, payments);
  }

  @override
  Future<void> deletePayments(String accountId, List<PPFPayment> paymentsToDelete) async {
    final payments = await getPaymentsForAccount(accountId);
    for (var paymentToDelete in paymentsToDelete) {
      payments.removeWhere((p) => 
        p.date == paymentToDelete.date && 
        p.amount == paymentToDelete.amount &&
        p.status == paymentToDelete.status
      );
    }
    await _storageService.savePayments(accountId, payments);
  }

  @override
  Future<void> clearAccount(String accountId) async {
    await _storageService.clearPayments(accountId);
  }

  @override
  Future<bool> hasData(String accountId) async {
    final payments = await getPaymentsForAccount(accountId);
    return payments.isNotEmpty;
  }
}
