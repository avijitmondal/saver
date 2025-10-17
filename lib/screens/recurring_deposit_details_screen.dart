import 'package:flutter/material.dart';
import '../models/investment.dart';
import '../utils/number_formatter.dart';
import '../utils/date_utils.dart';
import 'rd_payment_history_screen.dart';

class RecurringDepositDetailsScreen extends StatelessWidget {
  final Investment recurringDeposit;

  const RecurringDepositDetailsScreen({
    super.key,
    required this.recurringDeposit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Deposit Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card with basic info
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          recurringDeposit.icon,
                          color: recurringDeposit.color,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recurringDeposit.bank ?? 'Unknown Bank',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Recurring Deposit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildInfoColumn(
                            'Monthly Deposit',
                            NumberFormatter.formatAmount(recurringDeposit.amount),
                            alignment: CrossAxisAlignment.start,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoColumn(
                            'Current Value',
                            NumberFormatter.formatAmount(
                              recurringDeposit.isRecurring == true && recurringDeposit.durationInMonths != null
                                  ? recurringDeposit.amount * recurringDeposit.durationInMonths!
                                  : recurringDeposit.amount,
                            ),
                            alignment: CrossAxisAlignment.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildInfoColumn(
                            'Interest Rate',
                            '${recurringDeposit.interest.toStringAsFixed(2)}%',
                            alignment: CrossAxisAlignment.start,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoColumn(
                            'Expected Returns',
                            NumberFormatter.formatAmount(recurringDeposit.returns),
                            alignment: CrossAxisAlignment.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Detailed information
            const Text(
              'Deposit Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildDetailCard([
              _buildDetailRow('Start Date', DateFormatter.formatDate(recurringDeposit.startDate)),
              _buildDetailRow('Maturity Date', DateFormatter.formatDate(recurringDeposit.maturityDate)),
              _buildDetailRow('Duration', recurringDeposit.duration),
              _buildDetailRow('Remaining Time', recurringDeposit.remainingDuration),
              _buildDetailRow('Deposit Frequency', 'Monthly'),
            ]),
            
            const SizedBox(height: 24),
            
            const Text(
              'Financial Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildDetailCard([
              _buildDetailRow('Monthly Deposit', NumberFormatter.formatAmount(recurringDeposit.amount)),
              _buildDetailRow('Interest Rate', '${recurringDeposit.interest.toStringAsFixed(2)}% p.a.'),
              _buildDetailRow('Total Deposits', _calculateTotalDeposits()),
              _buildDetailRow('Expected Interest', NumberFormatter.formatAmount(recurringDeposit.returns)),
              _buildDetailRow('Maturity Amount', _calculateMaturityAmount()),
              _buildDetailRow('Returns Percentage', '${recurringDeposit.returnsPercentage.toStringAsFixed(2)}%'),
            ]),
            
            if (recurringDeposit.notes != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    recurringDeposit.notes!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Payment history button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RDPaymentHistoryScreen(
                      recurringDeposit: recurringDeposit,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('View Payment History'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement premature withdrawal logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Premature withdrawal feature coming soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.money_off),
                    label: const Text('Premature Withdrawal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.red[800],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement missed payment logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Missed payment feature coming soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Make Payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      foregroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _calculateTotalDeposits() {
    if (recurringDeposit.startDate == null || recurringDeposit.durationInMonths == null) {
      return 'N/A';
    }
    
    final totalAmount = recurringDeposit.amount * recurringDeposit.durationInMonths!;
    return NumberFormatter.formatAmount(totalAmount);
  }
  
  String _calculateMaturityAmount() {
    if (recurringDeposit.startDate == null || recurringDeposit.durationInMonths == null) {
      return 'N/A';
    }
    
    final totalDeposits = recurringDeposit.amount * recurringDeposit.durationInMonths!;
    return NumberFormatter.formatAmount(totalDeposits + recurringDeposit.returns);
  }
  
  Widget _buildInfoColumn(String title, String value, {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: alignment == CrossAxisAlignment.end ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }
  
  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}