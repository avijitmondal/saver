/// Value Object for Phone numbers
/// Ensures phone number is valid when created
class PhoneNumber {
  final String value;

  PhoneNumber._(this.value);

  /// Factory constructor that validates phone number
  factory PhoneNumber(String phone) {
    final cleaned = _clean(phone);
    if (!_isValid(cleaned)) {
      throw ArgumentError('Invalid phone number: $phone');
    }
    return PhoneNumber._(cleaned);
  }

  /// Try to create a phone number, returns null if invalid
  static PhoneNumber? tryParse(String phone) {
    try {
      return PhoneNumber(phone);
    } catch (e) {
      return null;
    }
  }

  /// Clean phone number (remove spaces, dashes, parentheses)
  static String _clean(String phone) {
    return phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }

  static bool _isValid(String phone) {
    if (phone.isEmpty) return false;
    
    // Accept phone numbers with 10-15 digits, optionally starting with +
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    
    return phoneRegex.hasMatch(phone);
  }

  /// Get formatted phone number (for display)
  String get formatted {
    if (value.startsWith('+')) {
      return value;
    }
    
    // Format as (XXX) XXX-XXXX for 10-digit numbers
    if (value.length == 10) {
      return '(${value.substring(0, 3)}) ${value.substring(3, 6)}-${value.substring(6)}';
    }
    
    return value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
