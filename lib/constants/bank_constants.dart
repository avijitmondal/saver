import 'package:flutter/material.dart';

class BankConstants {
  static const List<String> banks = ['SBI', 'HDFC', 'ICICI', 'Other'];

  static const Map<String, Color> bankColors = {
    'SBI': Color(0xFF2D5DA9),
    'HDFC': Color(0xFF004C8F),
    'ICICI': Color(0xFFF58220),
    'Other': Color(0xFF757575),
  };

  static const List<int> fdDurations = [3, 6, 9, 12, 15, 18, 24, 36, 48, 60];
}
