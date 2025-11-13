import '../models/investment.dart';
import '../models/user.dart';
import 'data_transformation_service.dart';
import 'file_service.dart';

/// Refactored DataImportService following SOLID principles
/// Now orchestrates specialized services instead of doing everything
class DataImportService {
  final DataTransformationService _transformationService;
  final FileService _fileService;

  DataImportService({
    DataTransformationService? transformationService,
    FileService? fileService,
  })  : _transformationService = transformationService ?? DataTransformationService(),
        _fileService = fileService ?? FileService();

  /// Import data from JSON string
  Future<ImportResult> importFromJson(String jsonString) async {
    try {
      final data = _fileService.parseJson(jsonString);
      
      if (data == null) {
        return ImportResult(
          success: false,
          error: 'Invalid JSON format',
        );
      }

      // Validate format
      if (!_fileService.validateJsonStructure(
        data,
        ['metadata', 'user', 'investments'],
      )) {
        return ImportResult(
          success: false,
          error: 'Invalid export file format',
        );
      }

      // Validate version compatibility
      final metadata = data['metadata'] as Map<String, dynamic>;
      final dataVersion = metadata['dataVersion'] as String?;

      if (dataVersion != '1.0') {
        return ImportResult(
          success: false,
          error: 'Unsupported data version: $dataVersion',
        );
      }

      // Parse user data
      User? user;
      if (data['user'] != null) {
        user = _transformationService.importDataToUser(
          data['user'] as Map<String, dynamic>,
        );
        
        if (user == null) {
          return ImportResult(
            success: false,
            error: 'Failed to parse user data',
          );
        }
      }

      // Parse investments
      List<Investment> investments = [];
      try {
        final investmentsList = data['investments'] as List;
        for (var invData in investmentsList) {
          final investment = _transformationService.importDataToInvestment(
            invData as Map<String, dynamic>,
          );
          
          if (investment != null) {
            investments.add(investment);
          }
        }
      } catch (e) {
        return ImportResult(
          success: false,
          error: 'Failed to parse investment data: $e',
        );
      }

      return ImportResult(
        success: true,
        user: user,
        investments: investments,
        metadata: ImportMetadata(
          exportDate: metadata['exportDate'] != null
              ? DateTime.parse(metadata['exportDate'])
              : null,
          appVersion: metadata['appVersion'] as String?,
        ),
      );
    } catch (e) {
      return ImportResult(
        success: false,
        error: 'Failed to parse JSON: $e',
      );
    }
  }

  /// Validate import file before full import
  Future<ValidationResult> validateImportFile(String jsonString) async {
    try {
      final data = _fileService.parseJson(jsonString);
      
      if (data == null) {
        return ValidationResult(
          isValid: false,
          error: 'Invalid JSON format',
        );
      }

      int investmentCount = 0;
      String? userName;
      String? email;

      if (data['investments'] != null) {
        investmentCount = (data['investments'] as List).length;
      }

      if (data['user'] != null) {
        final userData = data['user'] as Map<String, dynamic>;
        final firstName = userData['firstName'] ?? '';
        final lastName = userData['lastName'] ?? '';
        userName = '$firstName $lastName'.trim();
        email = userData['email'];
      }

      return ValidationResult(
        isValid: true,
        investmentCount: investmentCount,
        userName: userName,
        email: email,
      );
    } catch (e) {
      return ValidationResult(
        isValid: false,
        error: 'Invalid file format',
      );
    }
  }
}

/// Result of import operation
class ImportResult {
  final bool success;
  final String? error;
  final User? user;
  final List<Investment>? investments;
  final ImportMetadata? metadata;

  ImportResult({
    required this.success,
    this.error,
    this.user,
    this.investments,
    this.metadata,
  });
}

/// Import metadata
class ImportMetadata {
  final DateTime? exportDate;
  final String? appVersion;

  ImportMetadata({
    this.exportDate,
    this.appVersion,
  });
}

/// Result of validation
class ValidationResult {
  final bool isValid;
  final String? error;
  final int? investmentCount;
  final String? userName;
  final String? email;

  ValidationResult({
    required this.isValid,
    this.error,
    this.investmentCount,
    this.userName,
    this.email,
  });
}
