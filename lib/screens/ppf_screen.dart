import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/investment.dart';
import '../widgets/ppf_card.dart';
import 'add_ppf_screen.dart';
import 'ppf_payment_history_screen.dart';

class PPFScreen extends StatelessWidget {
  final String investmentType;
  final Color typeColor;

  const PPFScreen({
    super.key,
    required this.investmentType,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final investments = portfolio.investments
        .where((investment) => investment.type == investmentType)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(investmentType),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: investments.isEmpty
            ? _buildEmptyState()
            : _buildInvestmentView(context, investments[0]),
      ),
      floatingActionButton:
          investments.isEmpty ? _buildAddButton(context) : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No PPF Account Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your PPF account to start tracking',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentView(BuildContext context, Investment investment) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PPFCard(
            investment: investment,
            isMatured: false,
            typeColor: typeColor,
          ),
          const SizedBox(height: 24),
          _buildPaymentHistoryButton(context, investment),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryButton(
      BuildContext context, Investment investment) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PPFPaymentHistoryScreen(
              ppfAccount: investment,
            ),
          ),
        );
      },
      icon: const Icon(Icons.history),
      label: const Text('View Payment History'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddPPFScreen(),
          ),
        );
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
