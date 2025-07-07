import 'package:flutter/material.dart';
import '../models/investment.dart';
import '../utils/number_formatter.dart';
import '../utils/date_utils.dart';

class FixedDepositDetailsScreen extends StatelessWidget {
  final Investment fixedDeposit;

  const FixedDepositDetailsScreen({
    super.key,
    required this.fixedDeposit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Deposit Details'),
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
                          fixedDeposit.icon,
                          color: fixedDeposit.color,
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fixedDeposit.bank ?? 'Unknown Bank',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Fixed Deposit',
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
                        _buildInfoColumn('Principal', NumberFormatter.formatAmount(fixedDeposit.amount)),
                        _buildInfoColumn('Current Value', NumberFormatter.formatAmount(fixedDeposit.currentBalance)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn('Interest Rate', '${fixedDeposit.interest.toStringAsFixed(2)}%'),
                        _buildInfoColumn('Expected Returns', NumberFormatter.formatAmount(fixedDeposit.returns)),
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
              _buildDetailRow('Start Date', DateFormatter.formatDate(fixedDeposit.startDate)),
              _buildDetailRow('Maturity Date', DateFormatter.formatDate(fixedDeposit.maturityDate)),
              _buildDetailRow('Duration', fixedDeposit.duration),
              _buildDetailRow('Remaining Time', fixedDeposit.remainingDuration),
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
              _buildDetailRow('Principal Amount', NumberFormatter.formatAmount(fixedDeposit.amount)),
              _buildDetailRow('Interest Rate', '${fixedDeposit.interest.toStringAsFixed(2)}% p.a.'),
              _buildDetailRow('Expected Interest', NumberFormatter.formatAmount(fixedDeposit.returns)),
              _buildDetailRow('Maturity Amount', NumberFormatter.formatAmount(fixedDeposit.amount + fixedDeposit.returns)),
              _buildDetailRow('Returns Percentage', '${fixedDeposit.returnsPercentage.toStringAsFixed(2)}%'),
            ]),
            
            if (fixedDeposit.notes != null) ...[
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
                    fixedDeposit.notes!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
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
                      // TODO: Implement renewal logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Renewal feature coming soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Set Up Renewal'),
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
  
  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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