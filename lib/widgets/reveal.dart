import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'gradient_text.dart';

/// Reports when its position first enters the viewport. Re-checks on scroll,
/// resize and a few delayed frames (to catch layout shifts, e.g. web fonts).
class OnVisible extends StatefulWidget {
  const OnVisible({
    super.key,
    required this.builder,
    this.delay = Duration.zero,
    this.threshold = 0.92,
  });

  final Widget Function(BuildContext context, bool visible) builder;
  final Duration delay;
  final double threshold;

  @override
  State<OnVisible> createState() => _OnVisibleState();
}

class _OnVisibleState extends State<OnVisible> with WidgetsBindingObserver {
  bool _visible = false;
  bool _scheduled = false;
  ScrollPosition? _position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    for (final ms in const [250, 800, 1800]) {
      Future<void>.delayed(Duration(milliseconds: ms), _check);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = Scrollable.maybeOf(context)?.position;
    if (next != _position) {
      _position?.removeListener(_check);
      _position = next;
      _position?.addListener(_check);
    }
  }

  @override
  void didChangeMetrics() => _check();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _position?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (!mounted || _visible || _scheduled) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _reveal();
      return;
    }
    final ro = context.findRenderObject();
    if (ro is! RenderBox || !ro.attached || !ro.hasSize) return;
    final top = ro.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    if (top < viewport * widget.threshold) _reveal();
  }

  void _reveal() {
    _scheduled = true;
    _position?.removeListener(_check);
    if (widget.delay == Duration.zero) {
      if (mounted) setState(() => _visible = true);
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _visible);
}

/// Fade + slide-up when scrolled into view.
class Reveal extends StatelessWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.06),
    this.duration = const Duration(milliseconds: 650),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return OnVisible(
      delay: delay,
      builder: (context, visible) => AnimatedSlide(
        offset: visible ? Offset.zero : offset,
        duration: duration,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: duration,
          curve: Curves.easeOut,
          child: child,
        ),
      ),
    );
  }
}

/// Animated number that counts up once it scrolls into view.
class CountUp extends StatelessWidget {
  const CountUp({
    super.key,
    required this.value,
    this.decimals = 0,
    this.suffix = '',
    this.size = 40,
  });

  final double value;
  final int decimals;
  final String suffix;
  final double size;

  @override
  Widget build(BuildContext context) {
    return OnVisible(
      builder: (context, visible) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: visible ? value : 0),
        duration: const Duration(milliseconds: 1600),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: GradientText(
            '${v.toStringAsFixed(decimals)}$suffix',
            style: AppTheme.heading(size),
          ),
        ),
      ),
    );
  }
}
