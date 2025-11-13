/// Value Object for Email addresses
/// Ensures email is always valid when created
class Email {
  final String value;

  Email._(this.value);

  /// Factory constructor that validates email
  factory Email(String email) {
    final trimmed = email.trim().toLowerCase();
    if (!_isValid(trimmed)) {
      throw ArgumentError('Invalid email address: $email');
    }
    return Email._(trimmed);
  }

  /// Try to create an email, returns null if invalid
  static Email? tryParse(String email) {
    try {
      return Email(email);
    } catch (e) {
      return null;
    }
  }

  static bool _isValid(String email) {
    if (email.isEmpty) return false;
    
    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    return emailRegex.hasMatch(email);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Email &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
