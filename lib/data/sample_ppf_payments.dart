import '../models/ppf_payment.dart';
import '../constants/app_constants.dart';

/// Class to provide sample PPF payment data
class SamplePPFPayments {
  /// Get a list of sample PPF payments for demonstration purposes
  static List<PPFPayment> getSamplePayments() {
    // Return empty list if sample data is disabled
    if (!(AppConstants.featureFlags["sampleInvestmentData"] ?? false)) {
      return [];
    }
    
    return [
      // Completed payments from previous years
      PPFPayment(
        date: DateTime(2023, 4, 1),
        amount: 50000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2023-001',
        notes: 'Annual lump sum payment',
      ),
      PPFPayment(
        date: DateTime(2023, 7, 15),
        amount: 25000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2023-002',
        notes: 'Additional mid-year deposit',
      ),
      PPFPayment(
        date: DateTime(2023, 10, 5),
        amount: 25000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2023-003',
      ),
      PPFPayment(
        date: DateTime(2024, 1, 10),
        amount: 50000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2024-001',
        notes: 'Tax-saving investment for FY 2023-24',
      ),
      
      // Pending payments
      PPFPayment(
        date: DateTime(2024, 4, 1),
        amount: 50000.0,
        status: 'Pending',
        notes: 'Scheduled annual payment',
      ),
      
      // Failed payment
      PPFPayment(
        date: DateTime(2023, 12, 15),
        amount: 10000.0,
        status: 'Failed',
        referenceNumber: 'PPF-2023-F01',
        notes: 'Transaction failed due to insufficient funds',
      ),
      
      // Processing payment
      PPFPayment(
        date: DateTime(2024, 3, 25),
        amount: 15000.0,
        status: 'Processing',
        referenceNumber: 'PPF-2024-P01',
        notes: 'Payment in processing state',
      ),
      
      // Older completed payments
      PPFPayment(
        date: DateTime(2022, 4, 5),
        amount: 45000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2022-001',
        notes: 'Annual payment for FY 2022-23',
      ),
      PPFPayment(
        date: DateTime(2022, 9, 12),
        amount: 30000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2022-002',
      ),
      PPFPayment(
        date: DateTime(2022, 12, 28),
        amount: 25000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2022-003',
        notes: 'Year-end additional deposit',
      ),
      
      // Upcoming scheduled payments
      PPFPayment(
        date: DateTime(2024, 6, 15),
        amount: 25000.0,
        status: 'Scheduled',
        notes: 'Scheduled mid-year deposit',
      ),
      PPFPayment(
        date: DateTime(2024, 9, 10),
        amount: 25000.0,
        status: 'Scheduled',
        notes: 'Scheduled Q3 deposit',
      ),
    ];
  }

  /// Get the total amount invested in PPF from the sample payments
  static double getTotalInvestedAmount() {
    final payments = getSamplePayments();
    return payments
        .where((payment) => payment.isCompleted)
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Get payments for a specific PPF account
  /// In a real app, this would filter by account ID
  static List<PPFPayment> getPaymentsForAccount(String bankName) {
    // In this sample implementation, we return the same payments for any account
    // In a real app, you would filter by account ID
    return getSamplePayments();
  }
} 