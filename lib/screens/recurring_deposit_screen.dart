import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/investment.dart';
import 'add_recurring_deposit_screen.dart';
import '../widgets/section_header.dart';
import '../widgets/recurring_deposit_card.dart';
import '../utils/number_formatter.dart';

class RecurringDepositScreen extends StatelessWidget {
  final String investmentType;
  final Color typeColor;

  const RecurringDepositScreen({
    super.key,
    required this.investmentType,
    required this.typeColor,
  });

  List<Investment> _sortInvestments(List<Investment> investments) {
    final now = DateTime.now();
    final active = <Investment>[];
    final matured = <Investment>[];

    // Separate active and matured investments
    for (var investment in investments) {
      if (investment.maturityDate == null) continue;

      if (now.isAfter(investment.maturityDate!)) {
        matured.add(investment);
      } else {
        active.add(investment);
      }
    }

    // Sort active investments by earliest maturity first
    active.sort((a, b) {
      final aMaturity = a.maturityDate ?? DateTime(3000);
      final bMaturity = b.maturityDate ?? DateTime(3000);
      return aMaturity.compareTo(bMaturity); // Earlier dates first
    });

    // Sort matured investments by most recently matured first
    matured.sort((a, b) {
      final aMaturity = a.maturityDate ?? DateTime(1900);
      final bMaturity = b.maturityDate ?? DateTime(1900);
      return bMaturity.compareTo(aMaturity); // Recent dates first
    });

    return [...active, ...matured];
  }

  Widget _buildSummaryCard(List<Investment> investments) {
    // Filter active and matured investments
    final activeInvestments = investments.where((investment) => 
      investment.maturityDate == null || 
      investment.maturityDate!.isAfter(DateTime.now())
    ).toList();
    
    final maturedInvestments = investments.where((investment) => 
      investment.maturityDate != null && 
      investment.maturityDate!.isBefore(DateTime.now())
    ).toList();
    
    // Calculate active balance
    double activeBalance = activeInvestments.fold(
      0,
      (sum, investment) => sum + investment.currentBalance,
    );
    
    // Calculate matured balance (for tracking only)
    double maturedBalance = maturedInvestments.fold(
      0,
      (sum, investment) => sum + investment.currentBalance,
    );

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: typeColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Active Balance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              NumberFormatter.formatAmount(activeBalance),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: typeColor,
              ),
            ),
            if (maturedInvestments.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Matured Balance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                NumberFormatter.formatAmount(maturedBalance),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${activeInvestments.length} Active, ${maturedInvestments.length} Matured',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentCard(BuildContext context, Investment investment,
      int index, bool isMatured, bool isFirstItem, bool previousIsMatured) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFirstItem && !isMatured)
          const SectionHeader(
            title: 'Active Recurring Deposits',
            backgroundColor: Colors.green,
            textColor: Colors.white,
          ),
        if (!isFirstItem && isMatured && !previousIsMatured)
          const SectionHeader(
            title: 'Matured Recurring Deposits',
            backgroundColor: Colors.grey,
            textColor: Colors.white,
          ),
        Dismissible(
          key: Key(investment.hashCode.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text(
                      'Are you sure you want to delete this recurring deposit?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'DELETE',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            final portfolio = context.read<PortfolioProvider>();
            portfolio.deleteInvestment(investment);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recurring deposit deleted'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          },
          background: Container(
            color: Colors.red,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: RecurringDepositCard(
            investment: investment,
            index: index,
            isMatured: isMatured,
            typeColor: typeColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final investments = _sortInvestments(portfolio.investments
        .where((investment) => investment.type == investmentType)
        .toList());

    return Scaffold(
      appBar: AppBar(
        title: Text(investmentType),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(investments),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: investments.length,
            itemBuilder: (context, index) {
              final investment = investments[index];
              final isMatured = DateTime.now()
                  .isAfter(investment.maturityDate ?? DateTime(3000));
              final isFirstItem = index == 0;
              final previousIsMatured = index > 0 &&
                  DateTime.now().isAfter(
                      investments[index - 1].maturityDate ?? DateTime(3000));

              return _buildInvestmentCard(
                context,
                investment,
                index,
                isMatured,
                isFirstItem,
                previousIsMatured,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecurringDepositScreen(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
