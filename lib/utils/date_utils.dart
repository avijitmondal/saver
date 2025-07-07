import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM, yyyy').format(date);
  }

  static String formatDuration(int months) {
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    String duration = '';
    if (years > 0) {
      duration += '$years year${years > 1 ? 's' : ''}';
      if (remainingMonths > 0) {
        duration += ' ';
      }
    }
    if (remainingMonths > 0) {
      duration += '$remainingMonths month${remainingMonths > 1 ? 's' : ''}';
    }
    return duration;
  }
}
