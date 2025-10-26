import 'package:flutter/material.dart';
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

    final List<RDPayment> payments = [];
    final now = DateTime.now();
    final startDate = recurringDeposit.startDate!;
    
  // Calculate how many months have elapsed since start date
  // Add 1 because the first payment is made on the start date itself
  final monthsElapsed = ((now.difference(startDate).inDays / 30).floor()) + 1;
    
    // Generate payments only for elapsed months (payments that should have been made)
    final paymentsToGenerate = monthsElapsed < recurringDeposit.durationInMonths! 
        ? monthsElapsed 
        : recurringDeposit.durationInMonths!;
    
    for (int i = 0; i < paymentsToGenerate; i++) {
      // Each payment is made at the start of each month
      final paymentDate = DateTime(
        startDate.year,
        startDate.month + i,
        startDate.day,
      );
      
      payments.add(RDPayment(
        date: paymentDate,
        amount: recurringDeposit.amount,
        isCompleted: true,
        referenceNumber: 'RD${recurringDeposit.bank ?? 'XXX'}${i + 1}'.replaceAll(' ', ''),
        status: PaymentStatus.completed,
        notes: 'Monthly deposit #${i + 1}',
      ));
    }
    
    return payments;
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
                            backgroundColor: Colors.green.withOpacity(0.1),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
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
                          trailing: IconButton(
                            icon: const Icon(Icons.receipt_long,
                                color: Colors.grey),
                            onPressed: () {
                              _showReceiptDetails(context, payment);
                            },
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

  void _showReceiptDetails(BuildContext context, RDPayment payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Receipt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReceiptRow('Amount', NumberFormatter.formatAmount(payment.amount)),
            _buildReceiptRow('Date', DateFormatter.formatDate(payment.date)),
            if (payment.referenceNumber != null)
              _buildReceiptRow('Reference', payment.referenceNumber!),
            _buildReceiptRow('Status', payment.status.displayName),
            if (payment.notes != null) _buildReceiptRow('Notes', payment.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download feature coming soon'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('DOWNLOAD'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 