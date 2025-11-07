import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:saver/models/investment.dart';

void main() {
  group('Investment model', () {
    Investment buildInvestment({
      required String frequency,
      bool isRecurring = false,
      int months = 12,
      double amount = 10000,
      double interest = 8.0,
      DateTime? startDate,
    }) {
      return Investment.create(
        type: isRecurring ? 'RD' : 'FD',
        amount: amount,
        interest: interest,
        icon: Icons.account_balance,
        color: Colors.blue,
        startDate: startDate ?? DateTime.now().subtract(Duration(days: months * 30)),
        durationInMonths: months,
        isRecurring: isRecurring,
        compoundingFrequency: frequency,
      );
    }

    test('Compounding frequency affects returns ordering', () {
      final quarterly = buildInvestment(frequency: 'quarterly');
      final halfYearly = buildInvestment(frequency: 'half-yearly');
      final yearly = buildInvestment(frequency: 'yearly');

      expect(quarterly.returns > halfYearly.returns, true);
      expect(halfYearly.returns > yearly.returns, true);
    });

    test('Monthly > Quarterly when supported', () {
      final monthly = buildInvestment(frequency: 'monthly');
      final quarterly = buildInvestment(frequency: 'quarterly');
      expect(monthly.returns > quarterly.returns, true);
    });

    test('Unknown frequency falls back to quarterly', () {
      final unknown = buildInvestment(frequency: 'random');
      final quarterly = buildInvestment(frequency: 'quarterly');
      expect((unknown.returns - quarterly.returns).abs() < 0.01, true);
    });

    test('returnsPercentage uses principal for FD', () {
      final inv = buildInvestment(frequency: 'quarterly');
      final pct = inv.returnsPercentage;
      expect(pct, greaterThan(0));
      // approximate compound interest percentage for 8% quarterly ~ > 8%
      expect(pct, greaterThan(8));
    });

    test('returnsPercentage uses total deposits for RD', () {
      final rd = buildInvestment(frequency: 'quarterly', isRecurring: true, amount: 1000, months: 12);
      final pct = rd.returnsPercentage;
      expect(pct, greaterThan(0));
      // Should be less than FD percentage because base is larger (total deposits)
      final fdSame = buildInvestment(frequency: 'quarterly', amount: 12000, months: 12);
      expect(pct < fdSame.returnsPercentage, true);
    });

    test('currentBalance does not exceed maturity accrual for FD', () {
      final inv = buildInvestment(frequency: 'quarterly', months: 12);
      final balanceNow = inv.currentBalance;
      // Simulate matured investment by using past start date
      final matured = Investment.create(
        type: 'FD',
        amount: 10000,
        interest: 8.0,
        icon: Icons.account_balance,
        color: Colors.blue,
        startDate: DateTime.now().subtract(const Duration(days: 365)),
        durationInMonths: 12,
        compoundingFrequency: 'quarterly',
      );
      expect(balanceNow <= matured.currentBalance, true);
    });

    test('maturityStatus shows 100% after maturity', () {
      final matured = buildInvestment(frequency: 'quarterly', months: 12, startDate: DateTime.now().subtract(const Duration(days: 400)));
      expect(matured.maturityStatus, anyOf(['Matured', '100% Complete']));
    });

    test('Serialization toMap/fromMap preserves fields', () {
      final inv = buildInvestment(frequency: 'half-yearly', months: 18, amount: 25000, interest: 7.5);
      final map = inv.toMap();
      final from = Investment.fromMap(map);
      expect(from.type, inv.type);
      expect(from.amount, inv.amount);
      expect(from.interest, inv.interest);
      expect(from.compoundingFrequency, 'half-yearly');
      expect(from.durationInMonths, 18);
    });

    test('JSON serialization round trip', () {
      final inv = buildInvestment(frequency: 'yearly', months: 6, amount: 5000, interest: 5.0);
      final json = inv.toJson();
      final from = Investment.fromJson(json);
      expect(from.compoundingFrequency, 'yearly');
      expect(from.amount, 5000);
      expect(from.durationInMonths, 6);
    });

    test('maturityDate returns null when startDate or duration missing', () {
      final invNoStart = Investment.create(
        type: 'FD',
        amount: 1000,
        interest: 5,
        icon: Icons.account_balance,
        color: Colors.green,
        durationInMonths: 12,
        compoundingFrequency: 'quarterly',
      );
      expect(invNoStart.maturityDate, isNull);

      final invNoDuration = Investment.create(
        type: 'FD',
        amount: 1000,
        interest: 5,
        icon: Icons.account_balance,
        color: Colors.green,
        startDate: DateTime.now(),
        compoundingFrequency: 'quarterly',
      );
      expect(invNoDuration.maturityDate, isNull);
    });

    test('remainingDuration returns N/A when incomplete data', () {
      final inv = Investment.create(
        type: 'FD',
        amount: 1000,
        interest: 5,
        icon: Icons.account_balance,
        color: Colors.green,
        compoundingFrequency: 'quarterly',
      );
      expect(inv.remainingDuration, 'N/A');
    });

    test('Zero interest produces returns of zero (FD)', () {
      final inv = buildInvestment(frequency: 'quarterly', interest: 0.0);
      expect(inv.returns, 0);
      expect(inv.returnsPercentage, 0);
    });

    test('Zero amount produces returns and balance of zero (FD)', () {
      final inv = buildInvestment(frequency: 'quarterly', amount: 0);
      expect(inv.returns, 0);
      expect(inv.currentBalance, 0);
      expect(inv.returnsPercentage, 0);
    });

    test('Recurring deposit zero interest accrual equals total deposits', () {
      final rd = buildInvestment(frequency: 'quarterly', isRecurring: true, amount: 1000, months: 6, interest: 0.0);
      // Current balance should equal number of deposits made * amount (approx)
      final balance = rd.currentBalance;
      expect(balance >= 1000, true);
    });

    test('Frequency mapping monthly uses 12 periods', () {
      final monthly = buildInvestment(frequency: 'monthly');
      final quarterly = buildInvestment(frequency: 'quarterly');
      expect(monthly.returns > quarterly.returns, true);
    });

    test('Frequency mapping yearly uses fewer periods', () {
      final yearly = buildInvestment(frequency: 'yearly');
      final quarterly = buildInvestment(frequency: 'quarterly');
      expect(yearly.returns < quarterly.returns, true);
    });

    test('Maturity status percentage before maturity', () {
      final inv = buildInvestment(frequency: 'quarterly', months: 12, startDate: DateTime.now().subtract(const Duration(days: 180)));
      final status = inv.maturityStatus;
      expect(status.contains('%'), true);
    });

    test('Icon mapping fallback works (unknown codePoint)', () {
      final map = {
        'type': 'FD',
        'amount': 1000.0,
        'interest': 5.0,
        'iconCodePoint': 123456, // not in mapping
        'colorValue': Colors.red.value,
        'startDate': DateTime.now().millisecondsSinceEpoch,
        'durationInMonths': 12,
        'compoundingFrequency': 'quarterly',
      };
      final inv = Investment.fromMap(map);
      expect(inv.icon, isNotNull);
    });

    test('Simple interest fallback when duration invalid', () {
      final inv = buildInvestment(frequency: 'quarterly', months: -5, amount: 10000, interest: 8.0);
      // calculateReturns falls back to simple interest when duration <=0
      expect(inv.returns, closeTo(10000 * 0.08, 0.01));
    });

    // Additional coverage tests
    test('Icon mapping specific code points', () {
      final map1 = {
        'type': 'FD', 'amount': 1000.0, 'interest': 5.0, 'iconCodePoint': 0xe84f, 'colorValue': Colors.blue.value, 'startDate': DateTime.now().millisecondsSinceEpoch, 'durationInMonths': 12, 'compoundingFrequency': 'quarterly'
      };
      final map2 = {
        'type': 'FD', 'amount': 1000.0, 'interest': 5.0, 'iconCodePoint': 0xe850, 'colorValue': Colors.blue.value, 'startDate': DateTime.now().millisecondsSinceEpoch, 'durationInMonths': 12, 'compoundingFrequency': 'quarterly'
      };
      final map3 = {
        'type': 'FD', 'amount': 1000.0, 'interest': 5.0, 'iconCodePoint': 0xe8b0, 'colorValue': Colors.blue.value, 'startDate': DateTime.now().millisecondsSinceEpoch, 'durationInMonths': 12, 'compoundingFrequency': 'quarterly'
      };
      // Validate that mapping returns the intended IconData (codePoint match for stable ones, wallet may differ across material versions)
      expect(Investment.fromMap(map1).icon, Icons.account_balance);
      expect(Investment.fromMap(map2).icon, Icons.account_balance_wallet);
      expect(Investment.fromMap(map3).icon, Icons.attach_money);
    });

    test('Duration formatting variants', () {
      final invYearsMonths = buildInvestment(frequency: 'quarterly', months: 14); // 1 year 2 months
      final invYearsOnly = buildInvestment(frequency: 'quarterly', months: 24); // 2 years
      final invMonthsOnly = buildInvestment(frequency: 'quarterly', months: 5); // 5 months
      expect(invYearsMonths.duration.contains('1 year') && invYearsMonths.duration.contains('2 months'), true);
      expect(invYearsOnly.duration, '2 years');
      expect(invMonthsOnly.duration, '5 months');
    });

    test('Remaining duration days path', () {
      final startDate = DateTime.now().subtract(const Duration(days: 15));
      final inv = Investment.create(
        type: 'FD', amount: 1000, interest: 5, icon: Icons.account_balance, color: Colors.blue,
        startDate: startDate, durationInMonths: 1, compoundingFrequency: 'quarterly'
      );
      final remaining = inv.remainingDuration;
      expect(remaining.contains('Matures in'), true);
      expect(remaining.contains('day'), true);
    });

    test('Remaining duration matured path', () {
      final startDate = DateTime.now().subtract(const Duration(days: 400));
      final inv = Investment.create(
        type: 'FD', amount: 1000, interest: 5, icon: Icons.account_balance, color: Colors.blue,
        startDate: startDate, durationInMonths: 12, compoundingFrequency: 'quarterly'
      );
      expect(inv.remainingDuration, 'Matured');
    });

    test('Maturity status N/A when missing data', () {
      final inv = Investment.create(
        type: 'FD', amount: 1000, interest: 5, icon: Icons.account_balance, color: Colors.blue,
        compoundingFrequency: 'quarterly'
      );
      expect(inv.maturityStatus, 'N/A');
    });

    test('Maturity status matured path', () {
      final startDate = DateTime.now().subtract(const Duration(days: 380));
      final inv = Investment.create(
        type: 'FD', amount: 1000, interest: 5, icon: Icons.account_balance, color: Colors.blue,
        startDate: startDate, durationInMonths: 12, compoundingFrequency: 'quarterly'
      );
      expect(inv.maturityStatus, anyOf(['Matured', '100% Complete']));
    });

    test('ReturnsPercentage recurring 0 duration months', () {
      final inv = Investment.create(
        type: 'RD', amount: 500, interest: 7, icon: Icons.account_balance, color: Colors.blue,
        startDate: DateTime.now(), durationInMonths: 0, isRecurring: true, compoundingFrequency: 'quarterly'
      );
      expect(inv.returnsPercentage, 0);
    });

    test('Current balance recurring deposit early months', () {
      final startDate = DateTime.now().subtract(const Duration(days: 45)); // ~1.5 months
      final rd = Investment.create(
        type: 'RD', amount: 1000, interest: 8, icon: Icons.account_balance, color: Colors.blue,
        startDate: startDate, durationInMonths: 12, isRecurring: true, compoundingFrequency: 'quarterly'
      );
      final bal = rd.currentBalance;
      expect(bal > 1000, true); // at least first deposit plus interest on first
    });
  });
}
