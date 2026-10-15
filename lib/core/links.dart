import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

/// Every contact / social link in one place.
abstract final class Links {
  static const String name = 'Kathiravan K';
  static const String email = 'kathirkannan2002@gmail.com';
  static const String phoneDisplay = '+91 93604 91343';
  static const String phoneE164 = '+919360491343';
  static const String whatsappNumber = '919360491343';
  static const String linkedin =
      'https://www.linkedin.com/in/kathiravan-k-7897a0264';
  static const String github = 'https://github.com/kathiravankk';

  /// Where the site is hosted (GitHub Pages). Used for sharing on non-web builds.
  static const String hostedSite =
      'https://kathiravankk.github.io/Kathiravan_Portfolio/';

  static Uri whatsappChat([String? text]) => Uri.parse(
        'https://wa.me/$whatsappNumber'
        '${text == null ? '' : '?text=${Uri.encodeComponent(text)}'}',
      );

  static Uri mailto({String subject = '', String body = ''}) => Uri.parse(
        'mailto:$email?subject=${Uri.encodeComponent(subject)}'
        '&body=${Uri.encodeComponent(body)}',
      );

  static Uri gmailCompose({String subject = '', String body = ''}) =>
      Uri.https('mail.google.com', '/mail/', {
        'view': 'cm',
        'fs': '1',
        'to': email,
        'su': subject,
        'body': body,
      });

  static Uri tel() => Uri.parse('tel:$phoneE164');

  /// Public URL of this site (current origin on web, hosted URL otherwise).
  static String get siteUrl {
    if (!kIsWeb) return hostedSite;
    final b = Uri.base;
    var path = b.path;
    if (path.endsWith('.html')) {
      path = path.substring(0, path.lastIndexOf('/') + 1);
    }
    return Uri(
      scheme: b.scheme,
      host: b.host,
      port: b.hasPort ? b.port : null,
      path: path,
    ).toString();
  }

  static Future<bool> open(Uri uri) async {
    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: uri.scheme.startsWith('http') ? '_blank' : '_self',
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openString(String url) => open(Uri.parse(url));
}
