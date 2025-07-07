import 'package:flutter/material.dart';
import '../models/investment.dart';
import '../utils/date_utils.dart';
import '../utils/number_formatter.dart';
import 'bank_logo.dart';

class PPFCard extends StatelessWidget {
  final Investment investment;
  final int? index;
  final bool isMatured;
  final Color typeColor;

  const PPFCard({
    super.key,
    required this.investment,
    this.index,
    required this.isMatured,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = _buildCardContent();
    return isMatured ? _buildMaturedCard(cardContent) : cardContent;
  }

  Widget _buildMaturedCard(Widget content) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.03),
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      ),
    );
  }

  Widget _buildCardContent() {
    return Card(
      elevation: isMatured ? 2 : 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),
            if (investment.startDate != null) ...[
              _buildDateInfo(),
              const SizedBox(height: 12),
              _buildDurationInfo(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
            ],
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index != null) _buildIndexBadge(),
        if (index != null) const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Principal: ${NumberFormatter.formatAmount(investment.amount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Interest Rate: ${NumberFormatter.formatPercentage(investment.interest)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        BankLogo(bank: investment.bank),
      ],
    );
  }

  Widget _buildIndexBadge() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${index! + 1}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: typeColor,
        ),
      ),
    );
  }

  Widget _buildDateInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateColumn(
            'Start Date', DateFormatter.formatDate(investment.startDate)),
        _buildDateColumn(
            'Maturity Date', DateFormatter.formatDate(investment.maturityDate)),
      ],
    );
  }

  Widget _buildDateColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoColumn('Duration', investment.duration),
        _buildInfoColumn(
          'Status',
          investment.remainingDuration,
          valueColor: isMatured ? Colors.red : Colors.green,
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoColumn(
          'Returns',
          NumberFormatter.formatPercentage(investment.returnsPercentage),
          valueColor: Colors.green,
        ),
        _buildInfoColumn(
          'Current Balance',
          NumberFormatter.formatAmount(investment.currentBalance),
          valueColor: Colors.green,
        ),
      ],
    );
  }
}
