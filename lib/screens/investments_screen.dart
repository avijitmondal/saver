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
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddInvestmentDialog(context),
        ),
      ],
      body: ListView(
        children: [
          ...uniqueInvestments.map(
            (investment) => InvestmentCard(investment: investment),
          ),
        ],
      ),
    );
  }
}
