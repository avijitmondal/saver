import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saver/models/investment.dart';
import 'package:saver/models/user.dart';
import 'package:saver/services/data_export_service.dart';

void main() {
  group('DataExportService Feature Flag Filtering', () {
    late List<Investment> testInvestments;
    late DataExportService exportService;

    setUp(() {
      exportService = DataExportService();
      
      testInvestments = [
        Investment.create(
          type: 'Fixed Deposit',
          amount: 50000,
          interest: 7.5,
          icon: Icons.account_balance,
          color: Colors.blue,
        ),
        Investment.create(
          type: 'Recurring Deposit',
          amount: 5000,
          interest: 6.5,
          icon: Icons.savings,
          color: Colors.green,
        ),
        Investment.create(
          type: 'PPF',
          amount: 100000,
          interest: 7.1,
          icon: Icons.shield,
          color: Colors.orange,
        ),
        Investment.create(
          type: 'EPF',
          amount: 200000,
          interest: 8.15,
          icon: Icons.work,
          color: Colors.purple,
        ),
      ];
    });

    test('exports all investments when no flags provided', () {
      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
      );

      final investments = exportData['investments'] as List;
      expect(investments.length, 4);
    });

    test('exports all investments when all flags are true', () {
      final flags = {
        'fixedDepositInvestment': true,
        'recurringDepositInvestment': true,
        'publicProvidentFundInvestment': true,
        'employeeProvidentFundInvestment': true,
      };

      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
        featureFlags: flags,
      );

      final investments = exportData['investments'] as List;
      expect(investments.length, 4);
    });

    test('filters out PPF when publicProvidentFundInvestment is false', () {
      final flags = {
        'publicProvidentFundInvestment': false,
      };

      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
        featureFlags: flags,
      );

      final investments = exportData['investments'] as List;
      expect(investments.length, 3);
      expect(investments.any((inv) => inv['type'] == 'PPF'), false);
      expect(investments.any((inv) => inv['type'] == 'EPF'), true);
    });

    test('filters out EPF when employeeProvidentFundInvestment is false', () {
      final flags = {
        'employeeProvidentFundInvestment': false,
      };

      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
        featureFlags: flags,
      );

      final investments = exportData['investments'] as List;
      expect(investments.length, 3);
      expect(investments.any((inv) => inv['type'] == 'EPF'), false);
      expect(investments.any((inv) => inv['type'] == 'PPF'), true);
    });

    test('filters out both PPF and EPF when both flags are false', () {
      final flags = {
        'publicProvidentFundInvestment': false,
        'employeeProvidentFundInvestment': false,
      };

      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
        featureFlags: flags,
      );

      final investments = exportData['investments'] as List;
      expect(investments.length, 2);
      expect(investments.any((inv) => inv['type'] == 'PPF'), false);
      expect(investments.any((inv) => inv['type'] == 'EPF'), false);
      expect(investments.any((inv) => inv['type'] == 'Fixed Deposit'), true);
      expect(investments.any((inv) => inv['type'] == 'Recurring Deposit'), true);
    });

    test('filters out Fixed Deposit when flag is false', () {
      final flags = {
        'fixedDepositInvestment': false,
      };

      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
        featureFlags: flags,
      );

      final investments = exportData['investments'] as List;
      expect(investments.length, 3);
      expect(investments.any((inv) => inv['type'] == 'Fixed Deposit'), false);
    });

    test('investment count reflects filtered investments', () {
      final flags = {
        'publicProvidentFundInvestment': false,
        'employeeProvidentFundInvestment': false,
      };

      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
        featureFlags: flags,
      );

      final investments = exportData['investments'] as List;
      expect(investments.length, 2); // Only FD and RD
    });

    test('preview filters investment types correctly', () {
      final flags = {
        'publicProvidentFundInvestment': false,
      };

      final preview = exportService.getExportPreview(
        user: null,
        investments: testInvestments,
        featureFlags: flags,
      );

      final types = preview['investmentTypes'] as List;
      expect(types.length, 3);
      expect(types.contains('PPF'), false);
      expect(types.contains('EPF'), true);
      expect(types.contains('Fixed Deposit'), true);
      expect(types.contains('Recurring Deposit'), true);
    });

    test('preview shows correct total count with filtering', () {
      final flags = {
        'publicProvidentFundInvestment': false,
        'employeeProvidentFundInvestment': false,
      };

      final preview = exportService.getExportPreview(
        user: null,
        investments: testInvestments,
        featureFlags: flags,
      );

      expect(preview['totalInvestments'], 2);
    });

    test('exported investments exclude calculated values', () {
      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
      );

      final investments = exportData['investments'] as List;
      final firstInvestment = investments[0] as Map<String, dynamic>;

      // Should NOT have calculated values
      expect(firstInvestment.containsKey('currentBalance'), false);
      expect(firstInvestment.containsKey('returns'), false);
      expect(firstInvestment.containsKey('returnsPercentage'), false);
      expect(firstInvestment.containsKey('maturityStatus'), false);
      expect(firstInvestment.containsKey('remainingDuration'), false);
      expect(firstInvestment.containsKey('maturityDate'), false);
      expect(firstInvestment.containsKey('duration'), false);
      expect(firstInvestment.containsKey('calculatedValues'), false);

  // Should have core data
      expect(firstInvestment.containsKey('id'), true);
      expect(firstInvestment.containsKey('type'), true);
      expect(firstInvestment.containsKey('amount'), true);
      expect(firstInvestment.containsKey('interest'), true);
      expect(firstInvestment.containsKey('durationInMonths'), true);
      expect(firstInvestment.containsKey('compoundingFrequency'), true);
      expect(firstInvestment.containsKey('iconCodePoint'), true);
      expect(firstInvestment.containsKey('colorValue'), true);
    });

    test('exported investments include icon and color data', () {
      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
      );

      final investments = exportData['investments'] as List;
      final firstInvestment = investments[0] as Map<String, dynamic>;

      expect(firstInvestment['iconCodePoint'], isNotNull);
      expect(firstInvestment['colorValue'], isNotNull);
      expect(firstInvestment['iconCodePoint'], isA<int>());
      expect(firstInvestment['colorValue'], isA<int>());
    });

    test('exported user data excludes passwordHash', () {
      final user = User.create(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '1234567890',
        address: '123 Main St',
        dateOfBirth: DateTime(1990, 1, 1),
        passwordHash: 'secret_hash_should_not_export',
      );

      final exportData = exportService.exportUserData(
        user: user,
        investments: [],
      );

      final userData = exportData['user'] as Map<String, dynamic>;

      // Should NOT have passwordHash
      expect(userData.containsKey('passwordHash'), false);

      // Should have other user fields
      expect(userData['firstName'], 'John');
      expect(userData['lastName'], 'Doe');
      expect(userData['email'], 'john@example.com');
      expect(userData['phone'], '1234567890');
      expect(userData['address'], '123 Main St');
      expect(userData.containsKey('dateOfBirth'), true);
    });

    test('export does not include summary section', () {
      final exportData = exportService.exportUserData(
        user: null,
        investments: testInvestments,
      );

  // Should NOT have summary with calculated totals
      expect(exportData.containsKey('summary'), false);
      expect(exportData.containsKey('totalAmount'), false);
      expect(exportData.containsKey('totalCurrentValue'), false);
      expect(exportData.containsKey('totalReturns'), false);

      // Should only have essential sections
      expect(exportData.containsKey('metadata'), true);
      expect(exportData.containsKey('user'), true);
      expect(exportData.containsKey('investments'), true);
    });
  });
}
