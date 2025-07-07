import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saver/constants/app_constants.dart';
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Investment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: InvestmentConstants.allTypes
              .where((type) =>
                  (type.name != 'Fixed Deposit' ||
                      (AppConstants.featureFlags['enableFixedDepositInvestment'] ?? true)) &&
                  (type.name != 'Recurring Deposit' ||
                      (AppConstants.featureFlags['enableRecurringDepositInvestment'] ?? true)))
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
    final portfolio = context.watch<PortfolioProvider>();
    final uniqueInvestments = _getUniqueInvestments(
      portfolio.investments.where((inv) =>
        (inv.type != 'Fixed Deposit' ||
          (AppConstants.featureFlags['enableFixedDepositInvestment'] ?? true)) &&
        (inv.type != 'Recurring Deposit' ||
          (AppConstants.featureFlags['enableRecurringDepositInvestment'] ?? true))
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
