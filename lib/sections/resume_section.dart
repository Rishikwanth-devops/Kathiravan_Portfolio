import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../widgets/reveal.dart';
import '../widgets/share_dialog.dart';

/// Call-to-action banner: view, download or share the resume.
class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key, required this.onResume});

  final ValueChanged<ResumeAction> onResume;

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Want the full picture?',
          style: AppTheme.heading(
            Responsive.value<double>(context, mobile: 28, desktop: 38),
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'View my resume right in the browser, download a copy as a PDF, or '
          'share it with your team.',
          style: AppTheme.body(
            16,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _OnGradientButton(
              label: 'View',
              icon: Icons.visibility_outlined,
              filled: true,
              onTap: () => onResume(ResumeAction.view),
            ),
            _OnGradientButton(
              label: 'Download',
              icon: Icons.download_rounded,
              onTap: () => onResume(ResumeAction.download),
            ),
            _OnGradientButton(
              label: 'Share',
              icon: Icons.share_outlined,
              onTap: () => onResume(ResumeAction.share),
            ),
          ],
        ),
      ],
    );

    const doc = _DocPreview();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.hPad(context),
        vertical: mobile ? 8 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContent),
          child: Reveal(
            child: Container(
              padding: EdgeInsets.all(mobile ? 26 : 48),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B3FE0), Color(0xFF0E9BB8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 50,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: mobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [text],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: text),
                        const SizedBox(width: 40),
                        doc,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnGradientButton extends StatelessWidget {
  const _OnGradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    final fg = filled ? const Color(0xFF2B1B8F) : Colors.white;
    return Material(
      color: filled ? Colors.white : Colors.white.withValues(alpha: 0.12),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: filled
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 9),
              Text(
                label,
                style: AppTheme.body(
                  14.5,
                  weight: FontWeight.w700,
                  color: fg,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Little decorative "paper" illustration.
class _DocPreview extends StatelessWidget {
  const _DocPreview();

  Widget _line(double w, {double h = 8, Color? color}) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: color ?? const Color(0xFFD7DCF0),
          borderRadius: BorderRadius.circular(4),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.06,
      child: Container(
        width: 190,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(100, h: 12, color: const Color(0xFF5B3FE0)),
            const SizedBox(height: 8),
            _line(70),
            const SizedBox(height: 18),
            _line(150),
            const SizedBox(height: 7),
            _line(130),
            const SizedBox(height: 7),
            _line(140),
            const SizedBox(height: 18),
            _line(80, h: 10, color: const Color(0xFF0E9BB8)),
            const SizedBox(height: 10),
            _line(150),
            const SizedBox(height: 7),
            _line(110),
          ],
        ),
      ),
    );
  }
}
