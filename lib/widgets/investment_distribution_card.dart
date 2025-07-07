import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:saver/constants/app_constants.dart';
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

    // Get unique investment types and their total current balances
    final Map<String, double> typeBalances = {};
    final Map<String, Color> typeColors = {};

    for (var investment in portfolio.investments) {
      // Exclude Recurring Deposit if flag is false
      if (investment.type == 'Recurring Deposit' &&
          !(AppConstants.featureFlags['enableRecurringDepositInvestment'] ?? true)) {
        continue;
      }
      typeBalances[investment.type] =
          (typeBalances[investment.type] ?? 0) + investment.currentBalance;

      // Use the color from InvestmentConstants
      final investmentType = InvestmentConstants.getTypeByName(investment.type);
      typeColors[investment.type] = investmentType?.color ?? Colors.grey;
    }

    // Calculate total of all current balances
    final totalBalance =
        typeBalances.values.fold<double>(0.0, (sum, balance) => sum + balance);

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
    switch (type.name) {
      case 'Fixed Deposit':
        return 'FD';
      case 'Recurring Deposit':
        // Hide legend if recurring deposit is disabled
        if (!(AppConstants.featureFlags['enableRecurringDepositInvestment'] ?? true)) {
          return '';
        }
        return 'RD';
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
                ...InvestmentConstants.allTypes.map((type) {
                  final portfolio = context.watch<PortfolioProvider>();
                  final totalBalance =
                      portfolio.getTotalAmountByType(type.name);
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
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
