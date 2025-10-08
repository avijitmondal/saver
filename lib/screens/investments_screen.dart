import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feature_flags_provider.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/investment_card.dart';
import '../models/investment.dart';
import '../constants/investment_constants.dart';
import '../widgets/common/app_scaffold.dart';
import 'add_fixed_deposit_screen.dart';
import 'add_recurring_deposit_screen.dart';
import 'add_ppf_screen.dart';
import 'add_epf_screen.dart';

class InvestmentsScreen extends StatelessWidget {
  const InvestmentsScreen({super.key});

  List<Investment> _getUniqueInvestments(List<Investment> investments) {
    final Map<String, Investment> uniqueMap = {};
    for (var investment in investments) {
      if (!uniqueMap.containsKey(investment.type)) {
        uniqueMap[investment.type] = investment;
      }
    }
    return uniqueMap.values.toList();
  }

  void _showAddInvestmentDialog(BuildContext context) {
    final flags = Provider.of<FeatureFlagsProvider>(context, listen: false).flags;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Investment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: InvestmentConstants.allTypes
              .where((type) =>
                  (type.name != 'Fixed Deposit' ||
                      (flags['fixedDepositInvestment'] ?? true)) &&
                  (type.name != 'Recurring Deposit' ||
                      (flags['recurringDepositInvestment'] ?? true)) &&
                  (type.name != 'PPF' ||
                      (flags['publicProvidentFundInvestment'] ?? true)) &&
                  (type.name != 'EPF' ||
                      (flags['employeeProvidentFundInvestment'] ?? true)))
              .map((type) {
            return ListTile(
              leading: Icon(
                type.icon,
                color: type.color,
              ),
              title: Text(type.name),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddScreen(context, type);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddScreen(BuildContext context, InvestmentType type) {
    Widget screen;
    switch (type.name) {
      case 'Fixed Deposit':
        screen = const AddFixedDepositScreen();
        break;
      case 'Recurring Deposit':
        screen = const AddRecurringDepositScreen();
        break;
      case 'PPF':
        screen = const AddPPFScreen();
        break;
      case 'EPF':
        screen = const AddEPFScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flags = Provider.of<FeatureFlagsProvider>(context).flags;
    final portfolio = context.watch<PortfolioProvider>();
    final uniqueInvestments = _getUniqueInvestments(
      portfolio.investments.where((inv) =>
        (inv.type != 'Fixed Deposit' ||
          (flags['fixedDepositInvestment'] ?? true)) &&
        (inv.type != 'Recurring Deposit' ||
          (flags['recurringDepositInvestment'] ?? true)) &&
        (inv.type != 'PPF' ||
          (flags['publicProvidentFundInvestment'] ?? true)) &&
        (inv.type != 'EPF' ||
          (flags['employeeProvidentFundInvestment'] ?? true))
      ).toList(),
    );

    return AppScaffold(
      title: 'Investments',
      body: uniqueInvestments.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'You haven\'t started investing yet',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Investment is the key to building wealth for your future. Start your journey today and watch your money grow over time.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => _showAddInvestmentDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Start Investing'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              children: [
                ...uniqueInvestments.map(
                  (investment) => InvestmentCard(investment: investment),
                ),
              ],
            ),
      floatingActionButton: uniqueInvestments.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showAddInvestmentDialog(context),
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
