import 'package:flutter/widgets.dart';

/// Breakpoints + helpers used everywhere so layouts adapt to every device.
abstract final class Responsive {
  static const double maxContent = 1200;

  static double width(BuildContext c) => MediaQuery.sizeOf(c).width;

  static bool isMobile(BuildContext c) => width(c) < 720;
  static bool isDesktop(BuildContext c) => width(c) >= 1080;
  static bool isCompactNav(BuildContext c) => width(c) < 960;

  static T value<T>(
    BuildContext c, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final w = width(c);
    if (w < 720) return mobile;
    if (w < 1080) return tablet ?? desktop;
    return desktop;
  }

  static double hPad(BuildContext c) =>
      value<double>(c, mobile: 20, tablet: 40, desktop: 64);
}
