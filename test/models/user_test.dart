import 'package:flutter_test/flutter_test.dart';
import 'package:saver/models/user.dart';

void main() {
  group('User model', () {
    test('factory constructor creates user with auto-generated ID', () {
      final user = User.create(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '1234567890',
        address: '123 Main St',
        dateOfBirth: DateTime(1990, 1, 1),
      );

      expect(user.id, isNotEmpty);
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '1234567890');
      expect(user.address, '123 Main St');
      expect(user.dateOfBirth, DateTime(1990, 1, 1));
      expect(user.themeMode, 'system'); // default value
    });

    test('fullName computed property works correctly', () {
      final user = User.create(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '9876543210',
        address: '456 Oak Ave',
        dateOfBirth: DateTime(1995, 6, 15),
      );

      expect(user.fullName, 'Jane Smith');
    });

    test('serialization to Map includes all fields', () {
      final user = User.create(
        firstName: 'Alice',
        lastName: 'Johnson',
        email: 'alice@example.com',
        phone: '5555555555',
        address: '789 Pine Rd',
        dateOfBirth: DateTime(1988, 3, 20),
        passwordHash: 'hashed_password',
        themeMode: 'dark',
      );

      final map = user.toMap();

      expect(map['id'], user.id);
      expect(map['firstName'], 'Alice');
      expect(map['lastName'], 'Johnson');
      expect(map['email'], 'alice@example.com');
      expect(map['phone'], '5555555555');
      expect(map['address'], '789 Pine Rd');
      expect(map['dateOfBirth'], DateTime(1988, 3, 20).millisecondsSinceEpoch);
      expect(map['passwordHash'], 'hashed_password');
      expect(map['themeMode'], 'dark');
    });

    test('deserialization from Map creates correct User', () {
      final map = {
        'id': 'test-id-123',
        'firstName': 'Bob',
        'lastName': 'Williams',
        'email': 'bob@example.com',
        'phone': '1112223333',
        'address': '321 Elm St',
        'dateOfBirth': DateTime(1992, 11, 5).millisecondsSinceEpoch,
        'passwordHash': 'secure_hash',
        'themeMode': 'light',
      };

      final user = User.fromMap(map);

      expect(user.id, 'test-id-123');
      expect(user.firstName, 'Bob');
      expect(user.lastName, 'Williams');
      expect(user.email, 'bob@example.com');
      expect(user.phone, '1112223333');
      expect(user.address, '321 Elm St');
      expect(user.dateOfBirth, DateTime(1992, 11, 5));
      expect(user.passwordHash, 'secure_hash');
      expect(user.themeMode, 'light');
    });

    test('backward compatibility: fromMap generates ID if missing', () {
      final mapWithoutId = {
        'firstName': 'Charlie',
        'lastName': 'Brown',
        'email': 'charlie@example.com',
        'phone': '9998887777',
        'address': '654 Maple Dr',
        'dateOfBirth': DateTime(1985, 7, 10).millisecondsSinceEpoch,
      };

      final user = User.fromMap(mapWithoutId);

      // Should auto-generate an ID
      expect(user.id, isNotEmpty);
      expect(user.firstName, 'Charlie');
      expect(user.lastName, 'Brown');
      expect(user.themeMode, 'system'); // default value
    });

    test('backward compatibility: fromMap handles missing themeMode', () {
      final mapWithoutTheme = {
        'id': 'old-user-id',
        'firstName': 'David',
        'lastName': 'Miller',
        'email': 'david@example.com',
        'phone': '4445556666',
        'address': '987 Birch Ln',
        'dateOfBirth': DateTime(1980, 12, 25).millisecondsSinceEpoch,
      };

      final user = User.fromMap(mapWithoutTheme);

      expect(user.id, 'old-user-id');
      expect(user.themeMode, 'system'); // default value for old data
    });

    test('JSON serialization round-trip preserves data', () {
      final originalUser = User.create(
        firstName: 'Eve',
        lastName: 'Davis',
        email: 'eve@example.com',
        phone: '7778889999',
        address: '147 Cedar Ct',
        dateOfBirth: DateTime(1993, 4, 18),
        passwordHash: 'my_secure_hash',
        themeMode: 'dark',
      );

      final json = originalUser.toJson();
      final deserializedUser = User.fromJson(json);

      expect(deserializedUser.id, originalUser.id);
      expect(deserializedUser.firstName, originalUser.firstName);
      expect(deserializedUser.lastName, originalUser.lastName);
      expect(deserializedUser.email, originalUser.email);
      expect(deserializedUser.phone, originalUser.phone);
      expect(deserializedUser.address, originalUser.address);
      expect(deserializedUser.dateOfBirth, originalUser.dateOfBirth);
      expect(deserializedUser.passwordHash, originalUser.passwordHash);
      expect(deserializedUser.themeMode, originalUser.themeMode);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = User.create(
        firstName: 'Frank',
        lastName: 'Wilson',
        email: 'frank@example.com',
        phone: '3334445555',
        address: '258 Spruce Blvd',
        dateOfBirth: DateTime(1987, 9, 12),
      );

      final updated = original.copyWith(
        firstName: 'Franklin',
        email: 'franklin@example.com',
        themeMode: 'light',
      );

      // Updated fields
      expect(updated.firstName, 'Franklin');
      expect(updated.email, 'franklin@example.com');
      expect(updated.themeMode, 'light');

      // Unchanged fields
      expect(updated.id, original.id);
      expect(updated.lastName, original.lastName);
      expect(updated.phone, original.phone);
      expect(updated.address, original.address);
      expect(updated.dateOfBirth, original.dateOfBirth);
    });

    test('copyWith preserves original when no parameters provided', () {
      final original = User.create(
        firstName: 'Grace',
        lastName: 'Taylor',
        email: 'grace@example.com',
        phone: '2223334444',
        address: '369 Walnut Ave',
        dateOfBirth: DateTime(1991, 2, 28),
        themeMode: 'dark',
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.firstName, original.firstName);
      expect(copied.lastName, original.lastName);
      expect(copied.email, original.email);
      expect(copied.phone, original.phone);
      expect(copied.address, original.address);
      expect(copied.dateOfBirth, original.dateOfBirth);
      expect(copied.themeMode, original.themeMode);
    });

    test('each factory-created user has unique ID', () {
      final user1 = User.create(
        firstName: 'Test1',
        lastName: 'User1',
        email: 'test1@example.com',
        phone: '1111111111',
        address: 'Address 1',
        dateOfBirth: DateTime(1990, 1, 1),
      );

      final user2 = User.create(
        firstName: 'Test2',
        lastName: 'User2',
        email: 'test2@example.com',
        phone: '2222222222',
        address: 'Address 2',
        dateOfBirth: DateTime(1990, 1, 1),
      );

      expect(user1.id, isNot(equals(user2.id)));
    });
  });
}
