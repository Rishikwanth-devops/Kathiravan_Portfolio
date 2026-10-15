import 'package:web/web.dart' as web;

/// Triggers a real browser download (not just opening a tab).
void downloadFile(String url, String fileName) {
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = fileName
    ..style.display = 'none';
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
