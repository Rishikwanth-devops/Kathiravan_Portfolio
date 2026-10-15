import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import 'reveal.dart';

void showToast(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  final w = MediaQuery.sizeOf(context).width;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        width: (w - 32).clamp(0.0, 420.0).toDouble(),
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
}

/// Centered, max-width, responsive-padded section container.
class Section extends StatelessWidget {
  const Section({super.key, required this.child, this.background});

  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final vPad = Responsive.value<double>(
      context,
      mobile: 64,
      tablet: 84,
      desktop: 104,
    );
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.symmetric(vertical: vPad),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContent),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.hPad(context)),
            child: child,
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final titleSize =
        Responsive.value<double>(context, mobile: 32, tablet: 40, desktop: 46);
    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 2,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                eyebrow.toUpperCase(),
                style: AppTheme.body(
                  12.5,
                  weight: FontWeight.w700,
                  color: AppColors.secondary,
                ).copyWith(letterSpacing: 2),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: AppTheme.heading(titleSize)),
          if (subtitle != null) ...[
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(subtitle!, style: AppTheme.body(16.5)),
            ),
          ],
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  const Tag(this.label, {super.key, this.color = AppColors.primary});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Text(
        label,
        style: AppTheme.body(
          12.5,
          weight: FontWeight.w600,
          color: AppColors.text,
          height: 1.2,
        ),
      ),
    );
  }
}

/// Card that lifts and glows on hover.
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final pad = widget.padding ??
        EdgeInsets.all(
          Responsive.value<double>(context, mobile: 20, desktop: 26),
        );
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          padding: pad,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _hover
                  ? AppColors.primary.withValues(alpha: 0.65)
                  : AppColors.border,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.22),
                      blurRadius: 32,
                      offset: const Offset(0, 14),
                    ),
                  ]
                : const [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Static (non-hover) card surface.
class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.all(
            Responsive.value<double>(context, mobile: 20, desktop: 28),
          ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

enum AppButtonVariant { primary, outline, solid }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.color,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final Color? color;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final v = widget.variant;
    final Color fg = switch (v) {
      AppButtonVariant.primary => AppColors.bg,
      AppButtonVariant.outline => AppColors.text,
      AppButtonVariant.solid => Colors.white,
    };
    final radius = BorderRadius.circular(14);
    return AnimatedScale(
      scale: _hover ? 1.03 : 1,
      duration: const Duration(milliseconds: 160),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: widget.onPressed,
          onHover: (h) => setState(() => _hover = h),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient:
                  v == AppButtonVariant.primary ? AppColors.brandGradient : null,
              color: v == AppButtonVariant.solid
                  ? widget.color
                  : (v == AppButtonVariant.outline && _hover
                      ? Colors.white.withValues(alpha: 0.06)
                      : null),
              border: v == AppButtonVariant.outline
                  ? Border.all(
                      color: _hover
                          ? AppColors.primary
                          : AppColors.borderStrong,
                    )
                  : null,
              boxShadow: v == AppButtonVariant.primary && _hover
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(color: fg, size: 18),
                    child: widget.icon!,
                  ),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.body(
                      14.5,
                      weight: FontWeight.w700,
                      color: fg,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Round icon button used for social links.
class SocialButton extends StatefulWidget {
  const SocialButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.hoverColor = AppColors.primary,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color hoverColor;

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: AnimatedScale(
        scale: _hover ? 1.1 : 1,
        duration: const Duration(milliseconds: 160),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onTap,
            onHover: (h) => setState(() => _hover = h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hover
                    ? widget.hoverColor
                    : Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: _hover ? widget.hoverColor : AppColors.border,
                ),
              ),
              child: Center(
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white, size: 19),
                  child: widget.icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bullet list that shows the first few items and expands on demand.
class ExpandableBullets extends StatefulWidget {
  const ExpandableBullets({
    super.key,
    required this.items,
    this.initial = 3,
    this.fontSize = 14.5,
  });

  final List<String> items;
  final int initial;
  final double fontSize;

  @override
  State<ExpandableBullets> createState() => _ExpandableBulletsState();
}

class _ExpandableBulletsState extends State<ExpandableBullets> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final visible = _open ? items : items.take(widget.initial).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final p in visible)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.brandGradient,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          p,
                          style: AppTheme.body(
                            widget.fontSize,
                            color: const Color(0xFFC3CBE6),
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (items.length > widget.initial)
          TextButton.icon(
            onPressed: () => setState(() => _open = !_open),
            icon: Icon(
              _open ? Icons.expand_less_rounded : Icons.expand_more_rounded,
              size: 20,
            ),
            label: Text(
              _open ? 'Show less' : 'Show ${items.length - widget.initial} more',
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            ),
          ),
      ],
    );
  }
}
