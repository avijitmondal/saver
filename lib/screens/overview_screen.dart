import 'package:flutter/material.dart';
import '../widgets/portfolio_summary_card.dart';
import '../widgets/investment_distribution_card.dart';
import '../widgets/common/app_scaffold.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Overview',
      body: SingleChildScrollView(
        child: Column(
          children: const [
            PortfolioSummaryCard(),
            SizedBox(height: 20),
            InvestmentDistributionCard(),
          ],
        ),
      ),
    );
  }
}
