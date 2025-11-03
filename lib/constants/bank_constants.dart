import 'package:flutter/material.dart';

class BankConstants {
  static const List<String> banks = [
    'SBI',
    'HDFC',
    'ICICI',
    'Axis',
    'Kotak Mahindra',
    'PNB',
    'Bank of Baroda',
    'Canara',
    'IDFC First',
    'IndusInd',
    'Yes Bank',
    'Indian Bank',
    'Other',
  ];

  static const Map<String, Color> bankColors = {
    'SBI': Color(0xFF2D5DA9),
    'HDFC': Color(0xFF004C8F),
    'ICICI': Color(0xFFF58220),
    'Axis': Color(0xFF800020),
    'Kotak Mahindra': Color(0xFFED1C24),
    'PNB': Color(0xFF002E5D),
    'Bank of Baroda': Color(0xFFFF6600),
    'Canara': Color(0xFFED2024),
    'IDFC First': Color(0xFFFB8B24),
    'IndusInd': Color(0xFF005F32),
    'Yes Bank': Color(0xFF003DA5),
    'Indian Bank': Color(0xFF0072CE),
    'Other': Color(0xFF757575),
  };

  static const List<int> fdDurations = [3, 6, 9, 12, 15, 18, 24, 36, 48, 60];
}
