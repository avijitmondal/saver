/// Value Object for positive monetary amounts
/// Ensures amount is always valid and positive
class Money {
  final double value;

  Money._(this.value);

  /// Factory constructor that validates amount
  factory Money(double amount) {
    if (amount < 0) {
      throw ArgumentError('Amount cannot be negative: $amount');
    }
    if (amount.isNaN || amount.isInfinite) {
      throw ArgumentError('Invalid amount: $amount');
    }
    return Money._(amount);
  }

  /// Try to create money, returns null if invalid
  static Money? tryParse(double amount) {
    try {
      return Money(amount);
    } catch (e) {
      return null;
    }
  }

  /// Create from string
  static Money? fromString(String amount) {
    final parsed = double.tryParse(amount);
    if (parsed == null) return null;
    return tryParse(parsed);
  }

  /// Zero money
  static Money zero() => Money._(0.0);

  /// Add two money values
  Money operator +(Money other) => Money._(value + other.value);

  /// Subtract two money values
  Money operator -(Money other) {
    final result = value - other.value;
    if (result < 0) {
      throw ArgumentError('Result cannot be negative');
    }
    return Money._(result);
  }

  /// Multiply by a factor
  Money operator *(double factor) {
    if (factor < 0) {
      throw ArgumentError('Factor cannot be negative');
    }
    return Money._(value * factor);
  }

  /// Divide by a divisor
  Money operator /(double divisor) {
    if (divisor <= 0) {
      throw ArgumentError('Divisor must be positive');
    }
    return Money._(value / divisor);
  }

  /// Compare money values
  bool operator >(Money other) => value > other.value;
  bool operator <(Money other) => value < other.value;
  bool operator >=(Money other) => value >= other.value;
  bool operator <=(Money other) => value <= other.value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toStringAsFixed(2);
}
