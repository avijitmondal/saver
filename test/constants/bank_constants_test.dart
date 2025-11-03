import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saver/constants/bank_constants.dart';

void main() {
  group('BankConstants', () {
    group('banks', () {
      test('should contain expected bank names', () {
        expect(BankConstants.banks, isA<List<String>>());
        expect(BankConstants.banks.length, 13);
        expect(BankConstants.banks, contains('SBI'));
        expect(BankConstants.banks, contains('HDFC'));
        expect(BankConstants.banks, contains('ICICI'));
        expect(BankConstants.banks, contains('Axis'));
        expect(BankConstants.banks, contains('Kotak Mahindra'));
        expect(BankConstants.banks, contains('PNB'));
        expect(BankConstants.banks, contains('Bank of Baroda'));
        expect(BankConstants.banks, contains('Canara'));
        expect(BankConstants.banks, contains('IDFC First'));
        expect(BankConstants.banks, contains('IndusInd'));
        expect(BankConstants.banks, contains('Yes Bank'));
        expect(BankConstants.banks, contains('Indian Bank'));
        expect(BankConstants.banks, contains('Other'));
      });

      test('should be in correct order', () {
        expect(BankConstants.banks, [
          'SBI',
          'HDFC',
          'ICICI',
          'Axis',
          'Kotak Mahindra',
          'PNB',
          'Bank of Baroda',
          'Canara',
          'IDFC First',
          'IndusInd',
          'Yes Bank',
          'Indian Bank',
          'Other',
        ]);
      });

      test('should not contain duplicates', () {
        final uniqueBanks = BankConstants.banks.toSet();
        expect(uniqueBanks.length, BankConstants.banks.length);
      });
    });

    group('bankColors', () {
      test('should contain color for each bank', () {
        expect(BankConstants.bankColors, isA<Map<String, Color>>());
        expect(BankConstants.bankColors.length, 13);
        
        for (final bank in BankConstants.banks) {
          expect(BankConstants.bankColors.containsKey(bank), isTrue,
              reason: 'Bank "$bank" should have a color');
        }
      });

      test('should have correct color values', () {
        expect(BankConstants.bankColors['SBI'], const Color(0xFF2D5DA9));
        expect(BankConstants.bankColors['HDFC'], const Color(0xFF004C8F));
        expect(BankConstants.bankColors['ICICI'], const Color(0xFFF58220));
        expect(BankConstants.bankColors['Axis'], const Color(0xFF800020));
        expect(BankConstants.bankColors['Kotak Mahindra'], const Color(0xFFED1C24));
        expect(BankConstants.bankColors['PNB'], const Color(0xFF002E5D));
        expect(BankConstants.bankColors['Bank of Baroda'], const Color(0xFFFF6600));
        expect(BankConstants.bankColors['Canara'], const Color(0xFFED2024));
        expect(BankConstants.bankColors['IDFC First'], const Color(0xFFFB8B24));
        expect(BankConstants.bankColors['IndusInd'], const Color(0xFF005F32));
        expect(BankConstants.bankColors['Yes Bank'], const Color(0xFF003DA5));
        expect(BankConstants.bankColors['Indian Bank'], const Color(0xFF0072CE));
        expect(BankConstants.bankColors['Other'], const Color(0xFF757575));
      });

      test('should have valid color objects', () {
        BankConstants.bankColors.forEach((bank, color) {
          expect(color, isA<Color>());
          expect(color.value, isNonNegative);
        });
      });

      test('should have distinct colors for major banks', () {
        // Ensure major banks have different colors (allowing some duplicates for less popular banks)
        final majorBankColors = [
          BankConstants.bankColors['SBI'],
          BankConstants.bankColors['HDFC'],
          BankConstants.bankColors['ICICI'],
          BankConstants.bankColors['Axis'],
          BankConstants.bankColors['Kotak Mahindra'],
        ];
        final uniqueMajorColors = majorBankColors.toSet();
        expect(uniqueMajorColors.length, majorBankColors.length,
            reason: 'Major banks should have distinct colors');
      });
    });

    group('fdDurations', () {
      test('should contain expected duration values', () {
        expect(BankConstants.fdDurations, isA<List<int>>());
        expect(BankConstants.fdDurations.length, 10);
      });

      test('should have durations in ascending order', () {
        final sortedDurations = [...BankConstants.fdDurations]..sort();
        expect(BankConstants.fdDurations, sortedDurations,
            reason: 'FD durations should be in ascending order');
      });

      test('should contain correct duration values in months', () {
        expect(BankConstants.fdDurations, [3, 6, 9, 12, 15, 18, 24, 36, 48, 60]);
      });

      test('should only contain positive values', () {
        for (final duration in BankConstants.fdDurations) {
          expect(duration, greaterThan(0),
              reason: 'All durations should be positive');
        }
      });

      test('should not contain duplicates', () {
        final uniqueDurations = BankConstants.fdDurations.toSet();
        expect(uniqueDurations.length, BankConstants.fdDurations.length,
            reason: 'All durations should be unique');
      });

      test('should contain durations representing valid time periods', () {
        // Check if durations make sense for FD (Fixed Deposit) periods
        expect(BankConstants.fdDurations.first, 3, 
            reason: 'Minimum FD duration should be 3 months');
        expect(BankConstants.fdDurations.last, 60, 
            reason: 'Maximum FD duration should be 60 months (5 years)');
      });
    });

    group('Integration tests', () {
      test('all banks should have corresponding colors', () {
        for (final bank in BankConstants.banks) {
          expect(BankConstants.bankColors[bank], isNotNull,
              reason: 'Bank "$bank" should have a defined color');
        }
      });

      test('bank colors map should not have extra entries', () {
        final bankSet = BankConstants.banks.toSet();
        final colorKeySet = BankConstants.bankColors.keys.toSet();
        
        expect(colorKeySet.difference(bankSet).isEmpty, isTrue,
            reason: 'bankColors should not contain banks not in banks list');
      });
    });
  });
}
