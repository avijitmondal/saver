import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:saver/constants/investment_constants.dart';
import 'package:saver/providers/feature_flags_provider.dart';

class MockFeatureFlagsProvider extends ChangeNotifier implements FeatureFlagsProvider {
  @override
  Map<String, bool> flags;
  MockFeatureFlagsProvider(this.flags);

  @override
  void setFlag(String key, bool value) {
    flags[key] = value;
    notifyListeners();
  }
}

void main() {
  group('InvestmentConstants', () {
    test('allTypes should contain all investment types', () {
      expect(InvestmentConstants.allTypes.length, 4);
      expect(InvestmentConstants.allTypes.map((e) => e.name), containsAll([
        'Fixed Deposit', 'Recurring Deposit', 'PPF', 'EPF',
      ]));
    });

    test('categories should contain expected values', () {
      expect(InvestmentConstants.categories, ['Deposits', 'Other']);
    });

    test('each InvestmentType should have correct properties', () {
      final fd = InvestmentConstants.fixedDeposit;
      expect(fd.name, 'Fixed Deposit');
      expect(fd.icon, Icons.account_balance);
      expect(fd.color, Colors.blue);
      expect(fd.category, 'Deposits');

      final rd = InvestmentConstants.recurringDeposit;
      expect(rd.name, 'Recurring Deposit');
      expect(rd.icon, Icons.repeat);
      expect(rd.color, Colors.purple);
      expect(rd.category, 'Deposits');

      final ppf = InvestmentConstants.ppf;
      expect(ppf.name, 'PPF');
      expect(ppf.icon, Icons.savings);
      expect(ppf.color, Colors.green);
      expect(ppf.category, 'Other');

      final epf = InvestmentConstants.epf;
      expect(epf.name, 'EPF');
      expect(epf.icon, Icons.account_balance_wallet);
      expect(epf.color, Colors.orange);
      expect(epf.category, 'Other');
    });

    testWidgets('getTypesByCategory returns correct types with all flags true', (tester) async {
      final flags = {
        'fixedDepositInvestment': true,
        'recurringDepositInvestment': true,
        'publicProvidentFundInvestment': true,
      };
      await tester.pumpWidget(
        ChangeNotifierProvider<FeatureFlagsProvider>.value(
          value: MockFeatureFlagsProvider(flags),
          child: Builder(
            builder: (context) {
              final deposits = InvestmentConstants.getTypesByCategory(context, 'Deposits');
              final other = InvestmentConstants.getTypesByCategory(context, 'Other');
              expect(deposits.map((e) => e.name), containsAll(['Fixed Deposit', 'Recurring Deposit']));
              expect(other.map((e) => e.name), containsAll(['PPF', 'EPF']));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('getTypesByCategory respects feature flags', (tester) async {
      final flags = {
        'fixedDepositInvestment': false,
        'recurringDepositInvestment': true,
        'publicProvidentFundInvestment': false,
      };
      await tester.pumpWidget(
        ChangeNotifierProvider<FeatureFlagsProvider>.value(
          value: MockFeatureFlagsProvider(flags),
          child: Builder(
            builder: (context) {
              final deposits = InvestmentConstants.getTypesByCategory(context, 'Deposits');
              final other = InvestmentConstants.getTypesByCategory(context, 'Other');
              expect(deposits.map((e) => e.name), contains('Recurring Deposit'));
              expect(deposits.map((e) => e.name), isNot(contains('Fixed Deposit')));
              expect(other.map((e) => e.name), contains('EPF'));
              expect(other.map((e) => e.name), isNot(contains('PPF')));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('getTypeByName returns correct type and respects flags', (tester) async {
      final flags = {
        'fixedDepositInvestment': false,
        'recurringDepositInvestment': true,
        'publicProvidentFundInvestment': true,
      };
      await tester.pumpWidget(
        ChangeNotifierProvider<FeatureFlagsProvider>.value(
          value: MockFeatureFlagsProvider(flags),
          child: Builder(
            builder: (context) {
              expect(InvestmentConstants.getTypeByName(context, 'Fixed Deposit'), isNull);
              expect(InvestmentConstants.getTypeByName(context, 'Recurring Deposit'), isNotNull);
              expect(InvestmentConstants.getTypeByName(context, 'PPF'), isNotNull);
              expect(InvestmentConstants.getTypeByName(context, 'EPF'), isNotNull);
              expect(InvestmentConstants.getTypeByName(context, 'Nonexistent'), isNull);
              return Container();
            },
          ),
        ),
      );
    });
  });
}
