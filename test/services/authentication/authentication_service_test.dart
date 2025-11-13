import 'package:flutter_test/flutter_test.dart';
import 'package:saver/services/authentication_service.dart';

void main() {
  group('AuthenticationService', () {
    late AuthenticationService authService;

    setUp(() {
      authService = AuthenticationService();
    });

    group('hashPassword', () {
      test('generates consistent hash for same password', () {
        final hash1 = authService.hashPassword('password123');
        final hash2 = authService.hashPassword('password123');
        
        expect(hash1, equals(hash2));
        expect(hash1, isNotEmpty);
      });

      test('generates different hashes for different passwords', () {
        final hash1 = authService.hashPassword('password123');
        final hash2 = authService.hashPassword('differentPassword');
        
        expect(hash1, isNot(equals(hash2)));
      });

      test('handles empty password', () {
        final hash = authService.hashPassword('');
        expect(hash, isNotEmpty);
      });
    });

    group('validatePassword', () {
      test('validates correct password', () {
        const password = 'mySecurePassword';
        final hash = authService.hashPassword(password);
        
        expect(authService.validatePassword(password, hash), isTrue);
      });

      test('rejects incorrect password', () {
        const password = 'mySecurePassword';
        final hash = authService.hashPassword(password);
        
        expect(authService.validatePassword('wrongPassword', hash), isFalse);
      });

      test('is case sensitive', () {
        const password = 'Password123';
        final hash = authService.hashPassword(password);
        
        expect(authService.validatePassword('password123', hash), isFalse);
      });
    });

    group('checkPasswordStrength', () {
      test('identifies weak password (too short)', () {
        final strength = authService.checkPasswordStrength('abc');
        expect(strength, equals(PasswordStrength.weak));
      });

      test('identifies weak password (only lowercase)', () {
        final strength = authService.checkPasswordStrength('abcdefgh');
        expect(strength, equals(PasswordStrength.weak));
      });

      test('identifies medium password', () {
        final strength = authService.checkPasswordStrength('Password1');
        expect(strength, equals(PasswordStrength.medium));
      });

      test('identifies strong password', () {
        final strength = authService.checkPasswordStrength('MyP@ssw0rd123');
        expect(strength, equals(PasswordStrength.strong));
      });

      test('strong password with all character types', () {
        final strength = authService.checkPasswordStrength('MyPassword123');
        // Has uppercase, lowercase, digits, and length >= 12, so it's strong
        expect(strength, equals(PasswordStrength.strong));
      });
    });
  });
}
