import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'download_helper_web.dart' if (dart.library.io) 'download_helper_stub.dart' as web_impl;

class DownloadHelper {
  /// Download file - works on both web and mobile platforms
  static Future<String?> downloadFile({
    required String content,
    required String filename,
    required BuildContext context,
  }) async {
    try {
      if (kIsWeb) {
        return web_impl.downloadForWeb(content, filename);
      } else {
        return await _downloadForMobile(content, filename, context);
      }
    } catch (e) {
      debugPrint('Error downloading file: $e');
      rethrow;
    }
  }

  /// Mobile/Desktop download - saves to user-selected location
  static Future<String> _downloadForMobile(
    String content,
    String filename,
    BuildContext context,
  ) async {
    try {
      // Convert string content to bytes (required for Android/iOS)
      final bytes = Uint8List.fromList(utf8.encode(content));
      
      // Let user choose save location and save directly
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Export File',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: ['json'],
        lockParentWindow: true,
        bytes: bytes, // Required for Android/iOS
      );

      if (outputPath == null) {
        // User cancelled the picker
        throw Exception('Save cancelled by user');
      }

      // File is already saved by file_picker on mobile
      // On desktop, we need to write the file ourselves
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        // Ensure .json extension for desktop
        if (!outputPath.endsWith('.json')) {
          outputPath = '$outputPath.json';
        }
        final file = File(outputPath);
        await file.writeAsString(content);
      }
      
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
