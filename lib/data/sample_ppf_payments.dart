import '../models/ppf_payment.dart';
import '../constants/app_constants.dart';

/// Class to provide sample PPF payment data
class SamplePPFPayments {
  /// Get a list of sample PPF payments for demonstration purposes
  static List<PPFPayment> getSamplePayments() {
    // Return empty list if sample data is disabled
  if (!AppConstants.sampleData) {
      return [];
    }
    
    return [
      // Completed payments (sorted by date, oldest to newest)
      PPFPayment(
        date: DateTime(2024, 4, 1),
        amount: 50000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2024-001',
        notes: 'Annual lump sum payment',
      ),
      PPFPayment(
        date: DateTime(2024, 7, 15),
        amount: 25000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2024-002',
        notes: 'Additional mid-year deposit',
      ),
      PPFPayment(
        date: DateTime(2024, 10, 5),
        amount: 25000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2024-003',
      ),
      // Monthly recurring payments from Dec 2024
      PPFPayment(
        date: DateTime(2024, 12, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2024-R12',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 1, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R01',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 1, 10),
        amount: 50000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-001',
        notes: 'Tax-saving investment for FY 2024-25',
      ),
      PPFPayment(
        date: DateTime(2025, 2, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R02',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 3, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R03',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      // Quarterly payment
      PPFPayment(
        date: DateTime(2025, 4, 15),
        amount: 15000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-Q02',
        notes: 'Quarterly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Quarterly',
      ),
      PPFPayment(
        date: DateTime(2025, 4, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R04',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 5, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R05',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 6, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R06',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 7, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R07',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      // Quarterly payment
      PPFPayment(
        date: DateTime(2025, 7, 15),
        amount: 15000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-Q03',
        notes: 'Quarterly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Quarterly',
      ),
      PPFPayment(
        date: DateTime(2025, 8, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R08',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 9, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R09',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 10, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R10',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2025, 10, 10),
        amount: 50000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-004',
        notes: 'October lump sum payment',
      ),
      // Quarterly payment
      PPFPayment(
        date: DateTime(2025, 10, 15),
        amount: 15000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-Q04',
        notes: 'Quarterly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Quarterly',
      ),
      PPFPayment(
        date: DateTime(2025, 11, 1),
        amount: 5000.0,
        status: 'Completed',
        referenceNumber: 'PPF-2025-R11',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      
      // Upcoming payments (sorted by date, nearest first)
      PPFPayment(
        date: DateTime(2025, 12, 1),
        amount: 5000.0,
        status: 'Upcoming',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2026, 1, 1),
        amount: 5000.0,
        status: 'Upcoming',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2026, 1, 15),
        amount: 15000.0,
        status: 'Upcoming',
        notes: 'Quarterly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Quarterly',
      ),
      PPFPayment(
        date: DateTime(2026, 2, 1),
        amount: 5000.0,
        status: 'Upcoming',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2026, 3, 1),
        amount: 5000.0,
        status: 'Upcoming',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2026, 4, 1),
        amount: 5000.0,
        status: 'Upcoming',
        notes: 'Monthly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Monthly',
      ),
      PPFPayment(
        date: DateTime(2026, 4, 15),
        amount: 15000.0,
        status: 'Upcoming',
        notes: 'Quarterly recurring deposit',
        isRecurring: true,
        recurringFrequency: 'Quarterly',
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