import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DownloadHelper {
  /// Download file - works on mobile and desktop platforms
  static Future<String?> downloadFile({
    required String content,
    required String filename,
    required BuildContext context,
  }) async {
    try {
      return await _downloadForMobile(content, filename, context);
    } catch (e) {
      debugPrint('Error downloading file: $e');
      rethrow;
    }
  }

  /// Mobile download - saves to user-selected location
  static Future<String> _downloadForMobile(
    String content,
    String filename,
    BuildContext context,
  ) async {
    try {
      // Convert string content to bytes (required for Android/iOS)
      final bytes = Uint8List.fromList(utf8.encode(content));
      
      // Let user choose save location and save directly
      final resultUri = await FilePicker.saveFile(
        dialogTitle: 'Save Export File',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );

      if (resultUri == null) {
        // User cancelled the picker
        throw Exception('Save cancelled by user');
      }

      final outputPath = resultUri.scheme == 'file'
          ? resultUri.toFilePath()
          : (resultUri.path.isNotEmpty ? resultUri.path : resultUri.toString());
      
      return outputPath;
    } catch (e) {
      debugPrint('Mobile download error: $e');
      rethrow;
    }
  }

  /// Show success message
  static void showDownloadSuccess(BuildContext context, String path) {
    // Extract just the filename for display if it's a full path
    final displayName = path.split('/').last.split('\\').last;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved to: $displayName'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  /// Show error message
  static void showDownloadError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export failed: $error'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
