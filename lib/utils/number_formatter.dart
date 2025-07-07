import 'package:intl/intl.dart';

class NumberFormatter {
  static final _indianCurrencyFormat = NumberFormat('#,##,###.##');
  static final _percentFormat = NumberFormat('#,##,###.##');

  static String formatAmount(double amount) {
    return '₹${_indianCurrencyFormat.format(amount)}';
  }

  static String formatAmountWithoutSymbol(double amount) {
    return _indianCurrencyFormat.format(amount);
  }

  static String formatPercentage(double percentage) {
    return '${_percentFormat.format(percentage)}%';
  }
}
