import 'dart:convert';
import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final DateTime dateOfBirth;
  final String? passwordHash;
  final String themeMode;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.dateOfBirth,
    this.passwordHash,
    this.themeMode = 'system',
  });

  // Factory constructor to create user with auto-generated ID
  factory User.create({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    required DateTime dateOfBirth,
    String? passwordHash,
    String themeMode = 'system',
  }) {
    return User(
      id: const Uuid().v4(),
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      dateOfBirth: dateOfBirth,
      passwordHash: passwordHash,
      themeMode: themeMode,
    );
  }

  // Computed properties
  String get fullName => '$firstName $lastName'.trim();

  // Serialization methods
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'passwordHash': passwordHash,
      'themeMode': themeMode,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? const Uuid().v4(), // Generate new ID if missing (for backward compatibility)
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] ?? 0),
      passwordHash: map['passwordHash'],
      themeMode: map['themeMode'] ?? 'system',
    );
  }

  // JSON serialization
  String toJson() => jsonEncode(toMap());
  
  static User fromJson(String jsonString) {
    return fromMap(jsonDecode(jsonString));
  }

  // Copy with method for updates
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? passwordHash,
    String? themeMode,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      passwordHash: passwordHash ?? this.passwordHash,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
