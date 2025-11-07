import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../constants/ui_constants.dart';
import '../../providers/portfolio_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/data_export_service.dart';
import '../../utils/download_helper.dart';
import '../../models/user.dart';
import 'info_section.dart';

class ExportDataSection extends StatefulWidget {
  const ExportDataSection({super.key});

  @override
  State<ExportDataSection> createState() => _ExportDataSectionState();
}

class _ExportDataSectionState extends State<ExportDataSection> {
  bool _isExporting = false;

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);

      // Create User object from UserProvider data
      final user = User.create(
        firstName: userProvider.firstName,
        lastName: userProvider.lastName,
        email: userProvider.email,
        phone: userProvider.phone,
        address: userProvider.address,
        dateOfBirth: userProvider.dateOfBirth,
      );

      // Generate export data
      final exportData = DataExportService.exportUserData(
        user: user,
        investments: portfolioProvider.investments,
        featureFlags: AppConstants.featureFlags,
      );

      // Convert to JSON string
      final jsonString = DataExportService.generateJsonString(exportData, pretty: true);

      // Generate filename
      final filename = DataExportService.generateFilename();

      // Download file
      final result = await DownloadHelper.downloadFile(
        content: jsonString,
        filename: filename,
        context: context,
      );

      if (result != null && mounted) {
        DownloadHelper.showDownloadSuccess(
          context,
          result,
        );
      }
    } catch (e) {
      if (mounted) {
        // Don't show error if user cancelled
        if (!e.toString().contains('cancelled')) {
          DownloadHelper.showDownloadError(
            context,
            e.toString(),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _showExportPreview() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);

    // Create User object from UserProvider data
    final user = User.create(
      firstName: userProvider.firstName,
      lastName: userProvider.lastName,
      email: userProvider.email,
      phone: userProvider.phone,
      address: userProvider.address,
      dateOfBirth: userProvider.dateOfBirth,
    );

    final preview = DataExportService.getExportPreview(
      user: user,
      investments: portfolioProvider.investments,
      featureFlags: AppConstants.featureFlags,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Preview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPreviewItem('User', preview['userName'] ?? 'Unknown'),
              _buildPreviewItem('Email', preview['email'] ?? 'N/A'),
              const SizedBox(height: UIConstants.spacing16),
              _buildPreviewItem(
                'Total Investments',
                '${preview['totalInvestments']}',
              ),
              if (preview['investmentTypes'] != null)
                _buildPreviewItem(
                  'Investment Types',
                  (preview['investmentTypes'] as List).join(', '),
                ),
              const SizedBox(height: UIConstants.spacing16),
              const Text(
                'This will export all your investment data including:\n'
                '• Personal information\n'
                '• All investment records\n'
                '• Calculated values and returns\n'
                '• Summary statistics',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _handleExport();
            },
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: 'Data Export',
      children: [
        ListTile(
          leading: Icon(
            Icons.download,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('Export Investment Data'),
          subtitle: const Text(
            'Choose location and download your data as JSON',
          ),
          trailing: _isExporting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
          onTap: _isExporting ? null : _showExportPreview,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            UIConstants.spacing16,
            0,
            UIConstants.spacing16,
            UIConstants.spacing8,
          ),
          child: Text(
            'Export includes all investment records, personal information, '
            'and calculated values in a structured JSON format.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
