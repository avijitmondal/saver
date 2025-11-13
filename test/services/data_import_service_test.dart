import 'package:flutter_test/flutter_test.dart';
import 'package:saver/services/data_import_service.dart';

void main() {
  group('DataImportService', () {
    late DataImportService importService;

    setUp(() {
      importService = DataImportService();
    });

    test('imports valid JSON file successfully', () async {
      final jsonString = '''
{
  "metadata": {
    "exportDate": "2025-11-07T10:30:00.000Z",
    "appVersion": "1.0.4",
    "dataVersion": "1.0"
  },
  "user": {
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "phone": "1234567890",
    "address": "123 Main St",
    "dateOfBirth": "1990-01-01T00:00:00.000Z"
  },
  "investments": [
    {
      "id": "test-id-123",
      "type": "Fixed Deposit",
      "amount": 50000.0,
      "interest": 7.5,
      "bank": "HDFC Bank",
      "startDate": "2024-01-01T00:00:00.000Z",
      "durationInMonths": 12,
      "compoundingFrequency": "quarterly",
      "isRecurring": false,
      "notes": "Tax-saving FD",
      "iconCodePoint": 57415,
      "colorValue": 4280391411
    }
  ]
}
''';

      final result = await importService.importFromJson(jsonString);

      expect(result.success, true);
      expect(result.user, isNotNull);
      expect(result.user!.firstName, 'John');
      expect(result.user!.lastName, 'Doe');
      expect(result.user!.email, 'john@example.com');
      expect(result.investments, isNotNull);
      expect(result.investments!.length, 1);
      expect(result.investments![0].type, 'Fixed Deposit');
      expect(result.investments![0].amount, 50000.0);
    });

    test('validates import file correctly', () async {
      final jsonString = '''
{
  "metadata": {
    "exportDate": "2025-11-07T10:30:00.000Z",
    "appVersion": "1.0.4",
    "dataVersion": "1.0"
  },
  "user": {
    "firstName": "Jane",
    "lastName": "Smith",
    "email": "jane@example.com"
  },
  "investments": [
    {"id": "1", "type": "FD", "amount": 10000},
    {"id": "2", "type": "RD", "amount": 5000}
  ]
}
''';

      final result = await importService.validateImportFile(jsonString);

      expect(result.isValid, true);
      expect(result.userName, 'Jane Smith');
      expect(result.email, 'jane@example.com');
      expect(result.investmentCount, 2);
    });

    test('rejects invalid JSON', () async {
      final jsonString = 'invalid json {';

      final result = await importService.importFromJson(jsonString);

      expect(result.success, false);
      expect(result.error, isNotNull);
      expect(result.error, contains('Invalid JSON format'));
    });

    test('rejects missing required fields', () async {
      final jsonString = '''
{
  "user": {
    "firstName": "Test"
  }
}
''';

      final result = await importService.importFromJson(jsonString);

      expect(result.success, false);
      expect(result.error, 'Invalid export file format');
    });

    test('rejects unsupported data version', () async {
      final jsonString = '''
{
  "metadata": {
    "dataVersion": "2.0"
  },
  "user": {},
  "investments": []
}
''';

      final result = await importService.importFromJson(jsonString);

      expect(result.success, false);
      expect(result.error, contains('Unsupported data version'));
    });
  });
}
