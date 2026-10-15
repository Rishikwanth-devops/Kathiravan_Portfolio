import 'package:flutter/foundation.dart' show kIsWeb;

import 'download_stub.dart'
    if (dart.library.js_interop) 'download_web.dart' as dl;
import 'links.dart';

/// View / download the resume PDF that ships as a Flutter asset.
abstract final class ResumeService {
  static const String assetPath = 'assets/resume/Kathiravan_K_Resume.pdf';
  static const String fileName = 'Kathiravan_K_Resume.pdf';

  /// Flutter web serves bundled assets under `assets/<asset path>`.
  static String get url => kIsWeb
      ? Uri.base.resolve('assets/$assetPath').toString()
      : '${Links.hostedSite}assets/$assetPath';

  static Future<bool> view() => Links.openString(url);

  static Future<bool> download() async {
    if (kIsWeb) {
      try {
        dl.downloadFile(url, fileName);
        return true;
      } catch (_) {
        // fall through to opening the file instead
      }
    }
    return Links.openString(url);
  }
}
