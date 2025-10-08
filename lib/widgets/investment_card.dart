import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/investment.dart';
import '../providers/portfolio_provider.dart';
import '../screens/fixed_deposit_screen.dart';
import '../screens/recurring_deposit_screen.dart';
import '../screens/ppf_screen.dart';
import '../screens/epf_screen.dart';
import '../utils/number_formatter.dart';

class InvestmentCard extends StatelessWidget {
  final Investment investment;

  const InvestmentCard({
    super.key,
    required this.investment,
  });

  double _calculateTotalAmount(PortfolioProvider portfolio, String type) {
    final investments = portfolio.investments.where((inv) => inv.type == type);
    double total = 0;

    for (var inv in investments) {
      if (inv.type == 'Recurring Deposit' &&
          inv.isRecurring == true &&
          inv.durationInMonths != null) {
        // For recurring deposits, calculate total deposited amount
        total += inv.amount * inv.durationInMonths!;
      } else {
        // For other investment types, use the amount directly
        total += inv.amount;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final bool isFixedDeposit = investment.type == 'Fixed Deposit';
    final bool isRecurringDeposit = investment.type == 'Recurring Deposit';
    final bool isPPF = investment.type == 'PPF';
    final bool isEPF = investment.type == 'EPF';
    final portfolio = context.watch<PortfolioProvider>();
    final investmentCount = portfolio.getInvestmentCount(investment.type);
    final totalAmount = _calculateTotalAmount(portfolio, investment.type);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          if (isRecurringDeposit) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecurringDepositScreen(
                  investmentType: investment.type,
                  typeColor: investment.color,
                ),
              ),
            );
          } else if (isPPF) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PPFScreen(
                  investmentType: investment.type,
                  typeColor: investment.color,
                ),
              ),
            );
          } else if (isEPF) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EPFScreen(
                  investmentType: investment.type,
                  typeColor: investment.color,
                ),
              ),
            );
          } else if (isFixedDeposit) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FixedDepositScreen(
                  investmentType: investment.type,
                  typeColor: investment.color,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    investment.icon,
                    size: 32,
                    color: investment.color,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          investment.type,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$investmentCount ${investmentCount == 1 ? (isPPF || isEPF ? 'Account' : 'Investment') : (isPPF || isEPF ? 'Accounts' : 'Investments')}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NumberFormatter.formatAmount(totalAmount),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: investment.color,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Returns',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NumberFormatter.formatPercentage(
                            investment.returnsPercentage),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: investment.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
