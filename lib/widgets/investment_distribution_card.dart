import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:saver/providers/feature_flags_provider.dart';
import '../providers/portfolio_provider.dart';
import '../constants/investment_constants.dart';

class InvestmentDistributionCard extends StatefulWidget {
  const InvestmentDistributionCard({super.key});

  @override
  State<InvestmentDistributionCard> createState() =>
      _InvestmentDistributionCardState();
}

class _InvestmentDistributionCardState
    extends State<InvestmentDistributionCard> {
  int? touchedIndex;

  List<PieChartSectionData> _getSections(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final flags = Provider.of<FeatureFlagsProvider>(context).flags;

    // Get unique investment types and their total balances
    final Map<String, double> typeBalances = {};
    final Map<String, Color> typeColors = {};

    // Calculate balances by type using the same logic as portfolio.getTotalAmountByType
    for (var investment in portfolio.investments) {
      // Exclude Fixed Deposit if flag is false
      if (investment.type == 'Fixed Deposit' &&
          !(flags['fixedDepositInvestment'] ?? true)) {
        continue;
      }
      // Exclude Recurring Deposit if flag is false
      if (investment.type == 'Recurring Deposit' &&
          !(flags['recurringDepositInvestment'] ?? true)) {
        continue;
      }
      // Exclude EPF if flag is false
      if (investment.type == 'EPF' &&
          !(flags['employeeProvidentFundInvestment'] ?? true)) {
        continue;
      }
      // Exclude PPF if flag is false
      if (investment.type == 'PPF' &&
          !(flags['publicProvidentFundInvestment'] ?? true)) {
        continue;
      }

      // Calculate the correct balance based on investment type
      double balance;
      if (investment.type == 'Recurring Deposit' && 
          investment.isRecurring == true && 
          investment.durationInMonths != null) {
        // For recurring deposits, calculate total deposited amount
        balance = investment.amount * investment.durationInMonths!;
      } else {
        // For other investment types, use the amount directly
        balance = investment.amount;
      }

      typeBalances[investment.type] = (typeBalances[investment.type] ?? 0) + balance;

      // Use the color from InvestmentConstants
      final investmentType = InvestmentConstants.getTypeByName(context, investment.type);
      typeColors[investment.type] = investmentType?.color ?? Colors.grey;
    }

    // Calculate total of all current balances
    final totalBalance =
        typeBalances.values.fold<double>(0.0, (sum, balance) => sum + balance);

    if (totalBalance == 0) {
      // Show a single inactive ring section if there is no investment
      return [
        PieChartSectionData(
          color: Colors.grey[300]!,
          value: 1,
          title: '',
          radius: 80.0,
        ),
      ];
    }

    final entries = typeBalances.entries.toList();
    return entries.asMap().entries.map((mapEntry) {
      final index = mapEntry.key;
      final entry = mapEntry.value;
      final percentage =
          totalBalance > 0 ? (entry.value / totalBalance * 100) : 0.0;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 100.0 : 80.0;

      return PieChartSectionData(
        color: typeColors[entry.key]!,
        value: percentage,
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  String _getLegendText(InvestmentType type) {
    final flags = Provider.of<FeatureFlagsProvider>(context).flags;
    switch (type.name) {
      case 'Fixed Deposit':
        if (!(flags['fixedDepositInvestment'] ?? true)) {
          return '';
        }
        return 'FD';
      case 'Recurring Deposit':
        if (!(flags['recurringDepositInvestment'] ?? true)) {
          return '';
        }
        return 'RD';
      case 'EPF':
        if (!(flags['employeeProvidentFundInvestment'] ?? true)) {
          return '';
        }
        return 'EPF';
      case 'PPF':
        if (!(flags['publicProvidentFundInvestment'] ?? true)) {
          return '';
        }
        return 'PPF';
      default:
        return type.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Investment Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _getSections(context),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                ...InvestmentConstants.allTypes
                  .where((type) {
                    final flags = Provider.of<FeatureFlagsProvider>(context, listen: false).flags;
                    final portfolio = context.watch<PortfolioProvider>();
                    final totalBalance = portfolio.getTotalAmountByType(type.name);
                    
                    // Only show if feature flag is enabled AND there are investments in this category
                    if (type.name == 'Fixed Deposit' && (!(flags['fixedDepositInvestment'] ?? true) || totalBalance <= 0)) return false;
                    if (type.name == 'Recurring Deposit' && (!(flags['recurringDepositInvestment'] ?? true) || totalBalance <= 0)) return false;
                    if (type.name == 'EPF' && (!(flags['employeeProvidentFundInvestment'] ?? true) || totalBalance <= 0)) return false;
                    if (type.name == 'PPF' && (!(flags['publicProvidentFundInvestment'] ?? true) || totalBalance <= 0)) return false;
                    
                    // For other investment types, only show if there are investments
                    return totalBalance > 0;
                  })
                  .map((type) {
                    final portfolio = context.watch<PortfolioProvider>();
                    final totalBalance = portfolio.getTotalAmountByType(type.name);
                    final percentage = portfolio.totalInvestment > 0
                        ? (totalBalance / portfolio.totalInvestment * 100)
                        : 0.0;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: type.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_getLegendText(type)} (${percentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
