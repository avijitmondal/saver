import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saver/models/investment.dart';

void main() {
  group('Investment Backward Compatibility', () {
    test('Old data without id field gets auto-generated UUID', () {
      // Simulate old data format (no 'id' field)
      final oldDataMap = {
        'type': 'Fixed Deposit',
        'amount': 50000.0,
        'interest': 7.5,
        'iconCodePoint': Icons.account_balance.codePoint,
        'colorValue': Colors.blue.value,
        'bank': 'HDFC Bank',
        'durationInMonths': 12,
        'isRecurring': false,
        'compoundingFrequency': 'quarterly',
      };

      // Load using fromMap
      final investment = Investment.fromMap(oldDataMap);

      // Verify ID was auto-generated
      expect(investment.id, isNotEmpty);
      expect(investment.id.length, 36); // UUID v4 format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
      expect(investment.id.contains('-'), true);

      // Verify other fields loaded correctly
      expect(investment.type, 'Fixed Deposit');
      expect(investment.amount, 50000.0);
      expect(investment.interest, 7.5);
      expect(investment.bank, 'HDFC Bank');
    });

  // Legacy alternate interest field name was never released; test removed.

    test('New data with id field preserves the ID', () {
      final testId = 'test-uuid-123-456';
      final newDataMap = {
        'id': testId,
        'type': 'Recurring Deposit',
        'amount': 25000.0,
        'interest': 6.5,
        'iconCodePoint': Icons.savings.codePoint,
        'colorValue': Colors.green.value,
      };

      final investment = Investment.fromMap(newDataMap);

      // Verify ID is preserved
      expect(investment.id, testId);
      expect(investment.type, 'Recurring Deposit');
    });

    test('Multiple loads of same old data generate different IDs', () {
      final oldDataMap = {
        'type': 'Fixed Deposit',
        'amount': 50000.0,
        'interest': 7.5,
        'iconCodePoint': Icons.account_balance.codePoint,
        'colorValue': Colors.blue.value,
      };

      // Load twice
      final investment1 = Investment.fromMap(oldDataMap);
      final investment2 = Investment.fromMap(oldDataMap);

      // IDs should be different (new UUID each time for old data)
      expect(investment1.id, isNot(equals(investment2.id)));
      
      // But other fields should match
      expect(investment1.type, investment2.type);
      expect(investment1.amount, investment2.amount);
    });

    test('Upgraded data (fromMap then toMap) includes ID', () {
      // Old data without ID
      final oldDataMap = {
        'type': 'PPF',
        'amount': 100000.0,
        'interest': 7.1,
        'iconCodePoint': Icons.shield.codePoint,
        'colorValue': Colors.orange.value,
      };

      // Load old data
      final investment = Investment.fromMap(oldDataMap);
      
      // Save it back (simulating app upgrade)
      final upgradedMap = investment.toMap();

      // Verify ID is now included in saved data
      expect(upgradedMap.containsKey('id'), true);
      expect(upgradedMap['id'], isNotEmpty);
      expect(upgradedMap['id'], equals(investment.id));

      // Verify reloading preserves the same ID
      final reloadedInvestment = Investment.fromMap(upgradedMap);
      expect(reloadedInvestment.id, equals(investment.id));
    });
  });
}
