/// Value Object for interest rates
/// Ensures rate is always valid (between 0 and 100)
class InterestRate {
  final double value;

  InterestRate._(this.value);

  /// Factory constructor that validates interest rate
  factory InterestRate(double rate) {
    if (rate < 0 || rate > 100) {
      throw ArgumentError('Interest rate must be between 0 and 100: $rate');
    }
    if (rate.isNaN || rate.isInfinite) {
      throw ArgumentError('Invalid interest rate: $rate');
    }
    return InterestRate._(rate);
  }

  /// Try to create interest rate, returns null if invalid
  static InterestRate? tryParse(double rate) {
    try {
      return InterestRate(rate);
    } catch (e) {
      return null;
    }
  }

  /// Create from string
  static InterestRate? fromString(String rate) {
    final parsed = double.tryParse(rate);
    if (parsed == null) return null;
    return tryParse(parsed);
  }

  /// Get as decimal (e.g., 8.5% -> 0.085)
  double get asDecimal => value / 100;

  /// Get as percentage (e.g., 0.085 -> 8.5)
  double get asPercentage => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterestRate &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '${value.toStringAsFixed(2)}%';
}
