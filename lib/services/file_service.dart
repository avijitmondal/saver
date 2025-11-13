import 'dart:convert';
import 'package:intl/intl.dart';

/// Service for file operations (JSON generation, filename creation)
/// Follows Single Responsibility Principle - only handles file operations
class FileService {
  /// Generate a formatted JSON string
  String generateJsonString(
    Map<String, dynamic> data, {
    bool pretty = true,
  }) {
    if (pretty) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    }
    return jsonEncode(data);
  }

  /// Generate filename with timestamp
  String generateFilename({String prefix = 'saver_export'}) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '${prefix}_$timestamp.json';
  }

  /// Parse JSON string to Map
  Map<String, dynamic>? parseJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Validate JSON structure has required keys
  bool validateJsonStructure(
    Map<String, dynamic> data,
    List<String> requiredKeys,
  ) {
    return requiredKeys.every((key) => data.containsKey(key));
  }
}
