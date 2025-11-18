import 'dart:io';
import '../models/investment.dart';
import '../models/user.dart';
import 'data_transformation_service.dart';
import 'investment_filter_service.dart';
import 'file_service.dart';

/// Refactored DataExportService following SOLID principles
/// Now orchestrates specialized services instead of doing everything
class DataExportService {
  final DataTransformationService _transformationService;
  final InvestmentFilterService _filterService;
  final FileService _fileService;

  DataExportService({
    DataTransformationService? transformationService,
    InvestmentFilterService? filterService,
    FileService? fileService,
  })  : _transformationService = transformationService ?? DataTransformationService(),
        _filterService = filterService ?? InvestmentFilterService(),
        _fileService = fileService ?? FileService();

  /// Export all user data to JSON format
  Map<String, dynamic> exportUserData({
    required User? user,
    required List<Investment> investments,
    Map<String, dynamic>? featureFlags,
  }) {
    // Filter investments based on feature flags
    final filteredInvestments = 
        _filterService.filterByFeatureFlags(investments, featureFlags);

    final exportData = {
      'metadata': {
        'exportDate': DateTime.now().toIso8601String(),
        'appVersion': '1.0.4',
        'dataVersion': '1.0',
      },
      'user': user != null ? _transformationService.userToExportMap(user) : null,
      'investments': filteredInvestments
          .map((inv) => _transformationService.investmentToExportMap(inv))
          .toList(),
    };

    return exportData;
  }

  /// Get export preview (limited data for showing to user before export)
  Map<String, dynamic> getExportPreview({
    required User? user,
    required List<Investment> investments,
    Map<String, dynamic>? featureFlags,
  }) {
    // Filter investments based on feature flags
    final filteredInvestments = 
        _filterService.filterByFeatureFlags(investments, featureFlags);

    return {
      'userName': user != null ? '${user.firstName} ${user.lastName}' : 'Unknown',
      'email': user?.email ?? 'N/A',
      'totalInvestments': filteredInvestments.length,
      'investmentTypes': 
          filteredInvestments.map((inv) => inv.type).toSet().toList(),
      'dateRange': _getDateRange(filteredInvestments),
    };
  }

  /// Generate a formatted JSON string
  String generateJsonString(Map<String, dynamic> data, {bool pretty = true}) {
    return _fileService.generateJsonString(data, pretty: pretty);
  }

  /// Generate filename with timestamp
  String generateFilename({String prefix = 'saver_export'}) {
    return _fileService.generateFilename(prefix: prefix);
  }

  /// Save JSON data to file (for mobile/desktop)
  Future<File> saveToFile(String jsonData, String filePath) async {
    final file = File(filePath);
    await file.writeAsString(jsonData);
    return file;
  }

  Map<String, dynamic> _getDateRange(List<Investment> investments) {
    return {
      'earliest': investments
          .where((inv) => inv.startDate != null)
          .map((inv) => inv.startDate!)
          .fold<DateTime?>(
            null,
            (earliest, date) =>
                earliest == null || date.isBefore(earliest) ? date : earliest,
          )
          ?.toIso8601String(),
      'latest': investments
          .where((inv) => inv.maturityDate != null)
          .map((inv) => inv.maturityDate!)
          .fold<DateTime?>(
            null,
            (latest, date) =>
                latest == null || date.isAfter(latest) ? date : latest,
          )
          ?.toIso8601String(),
    };
  }
}
