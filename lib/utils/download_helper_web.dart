// Web implementation for download
import 'dart:convert';
import 'dart:html' as html;

String? downloadForWeb(String content, String filename) {
  try {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
    return filename;
  } catch (e) {
    print('Web download error: $e');
    rethrow;
  }
}
