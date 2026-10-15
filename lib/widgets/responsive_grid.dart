import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/responsive.dart';

/// Equal-height responsive grid. Column count follows the screen breakpoint,
/// each row stretches its cards to the tallest one, nothing can overflow.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobile = 1,
    this.tablet = 2,
    this.desktop = 3,
    this.spacing = 20,
  });

  final List<Widget> children;
  final int mobile;
  final int tablet;
  final int desktop;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.value<int>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final end = math.min(i + cols, children.length);
      final slice = children.sublist(i, end);
      final cells = <Widget>[];
      for (var j = 0; j < cols; j++) {
        if (j > 0) cells.add(SizedBox(width: spacing));
        cells.add(
          Expanded(
            child: j < slice.length ? slice[j] : const SizedBox.shrink(),
          ),
        );
      }
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cells,
          ),
        ),
      );
      if (end < children.length) rows.add(SizedBox(height: spacing));
    }
    return Column(children: rows);
  }
}
