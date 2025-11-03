import '../models/epf_payment.dart';
import '../constants/app_constants.dart';

/// Class to provide sample EPF payment data
class SampleEPFPayments {
  /// Get a list of sample EPF payments for demonstration purposes
  static List<EPFPayment> getSamplePayments() {
    // Return empty list if sample data is disabled
  if (!AppConstants.sampleData) {
      return [];
    }
    
    return [
      // Regular monthly contributions
      EPFPayment(
        date: DateTime(2023, 4, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-04',
        notes: 'Regular monthly contribution',
      ),
      EPFPayment(
        date: DateTime(2023, 5, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-05',
        notes: 'Regular monthly contribution',
      ),
      EPFPayment(
        date: DateTime(2023, 6, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-06',
        notes: 'Regular monthly contribution',
      ),
      
      // Increased contribution with bonus
      EPFPayment(
        date: DateTime(2023, 7, 1),
        amount: 7000.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-07',
        notes: 'Increased contribution with quarterly bonus',
      ),
      
      // Regular contributions continue
      EPFPayment(
        date: DateTime(2023, 8, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-08',
      ),
      EPFPayment(
        date: DateTime(2023, 9, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-09',
      ),
      
      // Voluntary additional contribution
      EPFPayment(
        date: DateTime(2023, 10, 1),
        amount: 10000.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-10-VPF',
        notes: 'Regular contribution + Voluntary PF',
      ),
      
      // Regular contributions continue
      EPFPayment(
        date: DateTime(2023, 11, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-11',
      ),
      EPFPayment(
        date: DateTime(2023, 12, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2023-12',
      ),
      
      // Year-end bonus contribution
      EPFPayment(
        date: DateTime(2024, 1, 1),
        amount: 15000.0,
        status: 'Completed',
        referenceNumber: 'EPF-2024-01',
        notes: 'Regular contribution + Annual bonus',
      ),
      
      // Regular contributions continue
      EPFPayment(
        date: DateTime(2024, 2, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2024-02',
      ),
      EPFPayment(
        date: DateTime(2024, 3, 1),
        amount: 3500.0,
        status: 'Completed',
        referenceNumber: 'EPF-2024-03',
      ),
      
      // Pending and upcoming payments
      EPFPayment(
        date: DateTime(2024, 4, 1),
        amount: 3500.0,
        status: 'Pending',
        notes: 'Upcoming monthly contribution',
      ),
      EPFPayment(
        date: DateTime(2024, 5, 1),
        amount: 3500.0,
        status: 'Scheduled',
        notes: 'Scheduled monthly contribution',
      ),
      
      // Failed payment
      EPFPayment(
        date: DateTime(2023, 7, 15),
        amount: 5000.0,
        status: 'Failed',
        referenceNumber: 'EPF-2023-VPF-F1',
        notes: 'Failed attempt to make additional VPF contribution',
      ),
    ];
  }

  /// Get the total amount invested in EPF from the sample payments
  static double getTotalInvestedAmount() {
    final payments = getSamplePayments();
    return payments
        .where((payment) => payment.isCompleted)
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Get payments for a specific EPF account
  /// In a real app, this would filter by account ID
  static List<EPFPayment> getPaymentsForAccount(String bankName) {
    // In this sample implementation, we return the same payments for any account
    // In a real app, you would filter by account ID
    return getSamplePayments();
  }
}