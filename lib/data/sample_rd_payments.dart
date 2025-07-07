import '../models/rd_payment.dart';

class SampleRDPayments {
  // Get payments for a specific recurring deposit account
  static List<RDPayment> getPaymentsForAccount(String accountId) {
    // Return the sample payments for the given account
    switch (accountId) {
      case 'HDFC Bank':
        return _hdfcBankPayments;
      case 'ICICI Bank':
        return _iciciBankPayments;
      case 'SBI':
        return _sbiPayments;
      case 'Axis Bank':
        return _axisBankPayments;
      default:
        return _defaultPayments;
    }
  }

  // Sample payments for HDFC Bank
  static final List<RDPayment> _hdfcBankPayments = [
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 150)),
      amount: 5000,
      isCompleted: true,
      referenceNumber: 'RD00123456',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 120)),
      amount: 5000,
      isCompleted: true,
      referenceNumber: 'RD00123457',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 90)),
      amount: 5000,
      isCompleted: true,
      referenceNumber: 'RD00123458',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 60)),
      amount: 5000,
      isCompleted: true,
      referenceNumber: 'RD00123459',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 30)),
      amount: 5000,
      isCompleted: true,
      referenceNumber: 'RD00123460',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now(),
      amount: 5000,
      isCompleted: false,
      status: PaymentStatus.pending,
    ),
    RDPayment(
      date: DateTime.now().add(const Duration(days: 30)),
      amount: 5000,
      isCompleted: false,
      status: PaymentStatus.scheduled,
    ),
  ];

  // Sample payments for ICICI Bank
  static final List<RDPayment> _iciciBankPayments = [
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 180)),
      amount: 3000,
      isCompleted: true,
      referenceNumber: 'ICRD987654',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 150)),
      amount: 3000,
      isCompleted: true,
      referenceNumber: 'ICRD987655',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 120)),
      amount: 3000,
      isCompleted: true,
      referenceNumber: 'ICRD987656',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 90)),
      amount: 3000,
      isCompleted: true,
      referenceNumber: 'ICRD987657',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 60)),
      amount: 3000,
      isCompleted: false,
      status: PaymentStatus.failed,
      notes: 'Insufficient funds',
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 30)),
      amount: 3000,
      isCompleted: true,
      referenceNumber: 'ICRD987658',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now(),
      amount: 3000,
      isCompleted: false,
      status: PaymentStatus.pending,
    ),
  ];

  // Sample payments for SBI
  static final List<RDPayment> _sbiPayments = [
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 120)),
      amount: 2000,
      isCompleted: true,
      referenceNumber: 'SBRD456789',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 90)),
      amount: 2000,
      isCompleted: true,
      referenceNumber: 'SBRD456790',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 60)),
      amount: 2000,
      isCompleted: true,
      referenceNumber: 'SBRD456791',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 30)),
      amount: 2000,
      isCompleted: true,
      referenceNumber: 'SBRD456792',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now(),
      amount: 2000,
      isCompleted: false,
      status: PaymentStatus.pending,
    ),
  ];

  // Sample payments for Axis Bank
  static final List<RDPayment> _axisBankPayments = [
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 90)),
      amount: 10000,
      isCompleted: true,
      referenceNumber: 'AXRD789012',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 60)),
      amount: 10000,
      isCompleted: true,
      referenceNumber: 'AXRD789013',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 30)),
      amount: 10000,
      isCompleted: true,
      referenceNumber: 'AXRD789014',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now(),
      amount: 10000,
      isCompleted: false,
      status: PaymentStatus.pending,
    ),
  ];

  // Default payments (used when no specific account is matched)
  static final List<RDPayment> _defaultPayments = [
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 90)),
      amount: 1000,
      isCompleted: true,
      referenceNumber: 'RD123456',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 60)),
      amount: 1000,
      isCompleted: true,
      referenceNumber: 'RD123457',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now().subtract(const Duration(days: 30)),
      amount: 1000,
      isCompleted: true,
      referenceNumber: 'RD123458',
      status: PaymentStatus.completed,
    ),
    RDPayment(
      date: DateTime.now(),
      amount: 1000,
      isCompleted: false,
      status: PaymentStatus.pending,
    ),
  ];
} 