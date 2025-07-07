import 'package:flutter/material.dart';
import '../models/investment.dart';
import '../models/rd_payment.dart';
import '../utils/number_formatter.dart';
import '../utils/date_utils.dart';
import '../data/sample_rd_payments.dart';

class RDPaymentHistoryScreen extends StatelessWidget {
  final Investment recurringDeposit;

  const RDPaymentHistoryScreen({
    super.key,
    required this.recurringDeposit,
  });

  @override
  Widget build(BuildContext context) {
    // Get payments from the sample data
    final List<RDPayment> payments = SampleRDPayments.getPaymentsForAccount(
        recurringDeposit.bank ?? '');

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
                      'Total Payments',
                      payments.where((p) => p.isCompleted).length.toString(),
                      Colors.blue,
                    ),
                    _buildStatColumn(
                      context,
                      'Pending',
                      payments.where((p) => p.status == PaymentStatus.pending).length.toString(),
                      Colors.orange,
                    ),
                    _buildStatColumn(
                      context,
                      'Upcoming',
                      payments.where((p) => p.status == PaymentStatus.scheduled).length.toString(),
                      Colors.green,
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
                ? const Center(
                    child: Text(
                      'No payment history available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      final isCompleted = payment.isCompleted;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                payment.status.color.withOpacity(0.1),
                            child: Icon(
                              payment.status.icon,
                              color: payment.status.color,
                            ),
                          ),
                          title: Text(
                            isCompleted
                                ? NumberFormatter.formatAmount(payment.amount)
                                : payment.status == PaymentStatus.pending
                                    ? 'Pending Payment'
                                    : 'Upcoming Payment',
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
                          trailing: isCompleted
                              ? IconButton(
                                  icon: const Icon(Icons.receipt_long,
                                      color: Colors.grey),
                                  onPressed: () {
                                    // Show receipt details
                                    _showReceiptDetails(context, payment);
                                  },
                                )
                              : TextButton(
                                  onPressed: () {
                                    // Show dialog to make payment
                                    _showMakePaymentDialog(context, payment);
                                  },
                                  child: const Text('Make Payment'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.green,
                                  ),
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
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
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

  void _showMakePaymentDialog(BuildContext context, RDPayment payment) {
    final amountController = TextEditingController();
    amountController.text = payment.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Payment Date: ${DateFormatter.formatDate(payment.date)}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
              // Make payment logic would go here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment successful'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('PAY NOW'),
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
              // Download receipt logic would go here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receipt downloaded'),
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