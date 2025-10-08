import 'package:flutter/material.dart';
import '../models/investment.dart';
import '../models/ppf_payment.dart';
import '../utils/number_formatter.dart';
import '../utils/date_utils.dart';
import '../data/sample_ppf_payments.dart';

class PPFPaymentHistoryScreen extends StatelessWidget {
  final Investment ppfAccount;

  const PPFPaymentHistoryScreen({
    super.key,
    required this.ppfAccount,
  });

  @override
  Widget build(BuildContext context) {
    // Get payments from the sample data
    final List<PPFPayment> payments = SamplePPFPayments.getPaymentsForAccount(ppfAccount.bank ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PPF Payment History'),
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
                        Icons.account_balance,
                        color: ppfAccount.color,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'PPF Account: ${ppfAccount.bank}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total Invested: ${NumberFormatter.formatAmount(ppfAccount.amount)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Current Balance: ${NumberFormatter.formatAmount(ppfAccount.currentBalance)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
            child: ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                final isCompleted = payment.isCompleted;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.pending,
                        color: isCompleted ? Colors.green : Colors.orange,
                      ),
                    ),
                    title: Text(
                      isCompleted
                          ? NumberFormatter.formatAmount(payment.amount)
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
                      ],
                    ),
                    trailing: isCompleted
                        ? const Icon(Icons.receipt_long, color: Colors.grey)
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

  void _showAddPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
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

  void _showMakePaymentDialog(BuildContext context, PPFPayment payment) {
    final amountController = TextEditingController();
    amountController.text = payment.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Date: ${DateFormatter.formatDate(payment.date)}'),
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
            child: const Text('PAY'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
