import 'dart:convert';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final DateTime dateOfBirth;
  final String? passwordHash;

  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.dateOfBirth,
    this.passwordHash,
  });

  // Serialization methods
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'passwordHash': passwordHash,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] ?? 0),
      passwordHash: map['passwordHash'],
    );
  }

  // JSON serialization
  String toJson() => jsonEncode(toMap());
  
  static User fromJson(String jsonString) {
    return fromMap(jsonDecode(jsonString));
  }

  // Copy with method for updates
  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? passwordHash,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}
