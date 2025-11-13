import 'package:flutter_test/flutter_test.dart';
import 'package:saver/domain/value_objects/email.dart';
import 'package:saver/domain/value_objects/phone_number.dart';
import 'package:saver/domain/value_objects/money.dart';
import 'package:saver/domain/value_objects/interest_rate.dart';

void main() {
  group('Email Value Object', () {
    test('accepts valid email', () {
      expect(() => Email('test@example.com'), returnsNormally);
      expect(Email('test@example.com').value, equals('test@example.com'));
    });

    test('normalizes email to lowercase', () {
      final email = Email('Test@Example.COM');
      expect(email.value, equals('test@example.com'));
    });

    test('trims whitespace', () {
      final email = Email('  test@example.com  ');
      expect(email.value, equals('test@example.com'));
    });

    test('rejects invalid email format', () {
      expect(() => Email('invalid'), throwsArgumentError);
      expect(() => Email('invalid@'), throwsArgumentError);
      expect(() => Email('@example.com'), throwsArgumentError);
      expect(() => Email('test@.com'), throwsArgumentError);
    });

    test('tryParse returns null for invalid email', () {
      expect(Email.tryParse('invalid'), isNull);
      expect(Email.tryParse('test@example.com'), isNotNull);
    });

    test('equality works correctly', () {
      final email1 = Email('test@example.com');
      final email2 = Email('TEST@example.com');
      expect(email1, equals(email2)); // Case insensitive
    });
  });

  group('PhoneNumber Value Object', () {
    test('accepts valid phone numbers', () {
      expect(() => PhoneNumber('1234567890'), returnsNormally);
      expect(() => PhoneNumber('+12345678901'), returnsNormally);
    });

    test('cleans formatting', () {
      final phone = PhoneNumber('(123) 456-7890');
      expect(phone.value, equals('1234567890'));
    });

    test('rejects invalid phone numbers', () {
      expect(() => PhoneNumber('123'), throwsArgumentError);
      expect(() => PhoneNumber('abc'), throwsArgumentError);
      expect(() => PhoneNumber('123456789012345678901'), throwsArgumentError);
    });

    test('formats for display', () {
      final phone = PhoneNumber('1234567890');
      expect(phone.formatted, equals('(123) 456-7890'));
    });

    test('preserves international format', () {
      final phone = PhoneNumber('+12345678901');
      expect(phone.formatted, equals('+12345678901'));
    });

    test('tryParse returns null for invalid', () {
      expect(PhoneNumber.tryParse('invalid'), isNull);
      expect(PhoneNumber.tryParse('1234567890'), isNotNull);
    });
  });

  group('Money Value Object', () {
    test('accepts valid amounts', () {
      expect(() => Money(100.50), returnsNormally);
      expect(() => Money(0), returnsNormally);
      expect(Money(100.50).value, equals(100.50));
    });

    test('rejects negative amounts', () {
      expect(() => Money(-10), throwsArgumentError);
    });

    test('rejects invalid amounts', () {
      expect(() => Money(double.nan), throwsArgumentError);
      expect(() => Money(double.infinity), throwsArgumentError);
    });

    test('addition works correctly', () {
      final m1 = Money(100);
      final m2 = Money(50);
      final result = m1 + m2;
      expect(result.value, equals(150));
    });

    test('subtraction works correctly', () {
      final m1 = Money(100);
      final m2 = Money(50);
      final result = m1 - m2;
      expect(result.value, equals(50));
    });

    test('subtraction throws when result would be negative', () {
      final m1 = Money(50);
      final m2 = Money(100);
      expect(() => m1 - m2, throwsArgumentError);
    });

    test('multiplication works correctly', () {
      final m = Money(100);
      final result = m * 2.5;
      expect(result.value, equals(250));
    });

    test('division works correctly', () {
      final m = Money(100);
      final result = m / 2;
      expect(result.value, equals(50));
    });

    test('comparison operators work', () {
      final m1 = Money(100);
      final m2 = Money(50);
      
      expect(m1 > m2, isTrue);
      expect(m2 < m1, isTrue);
      expect(m1 >= Money(100), isTrue);
      expect(m2 <= Money(50), isTrue);
    });

    test('zero creates zero money', () {
      final zero = Money.zero();
      expect(zero.value, equals(0));
    });

    test('fromString parses correctly', () {
      final money = Money.fromString('123.45');
      expect(money?.value, equals(123.45));
    });

    test('fromString returns null for invalid', () {
      expect(Money.fromString('invalid'), isNull);
    });
  });

  group('InterestRate Value Object', () {
    test('accepts valid rates', () {
      expect(() => InterestRate(8.5), returnsNormally);
      expect(() => InterestRate(0), returnsNormally);
      expect(() => InterestRate(100), returnsNormally);
    });

    test('rejects rates outside 0-100 range', () {
      expect(() => InterestRate(-1), throwsArgumentError);
      expect(() => InterestRate(101), throwsArgumentError);
    });

    test('rejects invalid rates', () {
      expect(() => InterestRate(double.nan), throwsArgumentError);
      expect(() => InterestRate(double.infinity), throwsArgumentError);
    });

    test('asDecimal converts correctly', () {
      final rate = InterestRate(8.5);
      expect(rate.asDecimal, closeTo(0.085, 0.0001));
    });

    test('asPercentage returns value', () {
      final rate = InterestRate(8.5);
      expect(rate.asPercentage, equals(8.5));
    });

    test('toString formats as percentage', () {
      final rate = InterestRate(8.5);
      expect(rate.toString(), equals('8.50%'));
    });

    test('fromString parses correctly', () {
      final rate = InterestRate.fromString('8.5');
      expect(rate?.value, equals(8.5));
    });

    test('tryParse returns null for invalid', () {
      expect(InterestRate.tryParse(-1), isNull);
      expect(InterestRate.tryParse(101), isNull);
      expect(InterestRate.tryParse(8.5), isNotNull);
    });
  });
}
