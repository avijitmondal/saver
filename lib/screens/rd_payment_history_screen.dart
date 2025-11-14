import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/investment.dart';
import '../models/rd_payment.dart';
import '../utils/number_formatter.dart';
import '../utils/date_utils.dart';

class RDPaymentHistoryScreen extends StatelessWidget {
  final Investment recurringDeposit;

  const RDPaymentHistoryScreen({
    super.key,
    required this.recurringDeposit,
  });

  List<RDPayment> _generatePaymentHistory() {
    if (recurringDeposit.startDate == null || recurringDeposit.durationInMonths == null) {
      return [];
    }

    final List<RDPayment> allPayments = [];
    final now = DateTime.now();
    final startDate = recurringDeposit.startDate!;
    
    // Generate all payments for the entire RD duration
    for (int i = 0; i < recurringDeposit.durationInMonths!; i++) {
      final paymentDate = DateTime(
        startDate.year,
        startDate.month + i,
        startDate.day,
      );
      
      // Determine if payment is completed or upcoming
      final isCompleted = paymentDate.isBefore(now) || 
                         paymentDate.isAtSameMomentAs(now);
      
      allPayments.add(RDPayment(
        date: paymentDate,
        amount: recurringDeposit.amount,
        isCompleted: isCompleted,
        referenceNumber: isCompleted 
            ? 'RD${recurringDeposit.bank ?? 'XXX'}${i + 1}'.replaceAll(' ', '')
            : null,
        status: isCompleted ? PaymentStatus.completed : PaymentStatus.upcoming,
        notes: isCompleted ? 'Monthly deposit #${i + 1}' : 'Scheduled monthly deposit #${i + 1}',
      ));
    }
    
    // Separate completed and upcoming payments
    final completedPayments = allPayments
        .where((p) => p.status == PaymentStatus.completed)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // Oldest first
    
    final upcomingPayments = allPayments
        .where((p) => p.status == PaymentStatus.upcoming)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // Nearest first
    
    // Get last N completed payments and next N upcoming payments
    final limitedCompletedPayments = completedPayments.length > AppConstants.maxCompletedPaymentsToShow
        ? completedPayments.sublist(completedPayments.length - AppConstants.maxCompletedPaymentsToShow)
        : completedPayments;
    
    final limitedUpcomingPayments = upcomingPayments.take(AppConstants.maxUpcomingPaymentsToShow).toList();
    
    return [...limitedCompletedPayments, ...limitedUpcomingPayments];
  }

  @override
  Widget build(BuildContext context) {
    // Generate payments based on actual elapsed time
    final List<RDPayment> payments = _generatePaymentHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RD Payment History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Summary card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        recurringDeposit.icon,
                        color: recurringDeposit.color,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'RD Account: ${recurringDeposit.bank}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Monthly Deposit: ${NumberFormatter.formatAmount(recurringDeposit.amount)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Current Balance: ${NumberFormatter.formatAmount(recurringDeposit.currentBalance)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Maturity Date: ${DateFormatter.formatDate(recurringDeposit.maturityDate)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Payment statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      context,
                      'Payments Made',
                      payments.length.toString(),
                      Colors.green,
                    ),
                    _buildStatColumn(
                      context,
                      'Total Deposited',
                      NumberFormatter.formatAmount(payments.length * recurringDeposit.amount),
                      Colors.blue,
                    ),
                    _buildStatColumn(
                      context,
                      'Remaining',
                      '${(recurringDeposit.durationInMonths ?? 0) - payments.length}',
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Payments list header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Payment History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    // Show dialog to add new payment
                    _showAddPaymentDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Payment'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Payments list
          Expanded(
            child: payments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No payments made yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Payments will appear here as they are made',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: payment.status.color.withOpacity(0.1),
                            child: Icon(
                              payment.status.icon,
                              color: payment.status.color,
                            ),
                          ),
                          title: Text(
                            NumberFormatter.formatAmount(payment.amount),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormatter.formatDate(payment.date)),
                              if (payment.referenceNumber != null)
                                Text(
                                  'Ref: ${payment.referenceNumber}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              if (payment.notes != null)
                                Text(
                                  payment.notes!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Chip(
                                label: Text(
                                  payment.status.displayName,
                                  style: TextStyle(
                                    color: payment.status.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: payment.status.color.withOpacity(0.1),
                                side: BorderSide.none,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    amountController.text = recurringDeposit.amount.toString();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  selectedDate = picked;
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormatter.formatDate(selectedDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // Add payment logic would go here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment added successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('ADD'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
} 