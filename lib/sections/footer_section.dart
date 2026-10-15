import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../widgets/gradient_text.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key, required this.onTop});

  final VoidCallback onTop;

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final year = DateTime.now().year;

    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientText('KK', style: AppTheme.heading(22)),
        Text('.', style: AppTheme.heading(22, color: AppColors.accent)),
      ],
    );
    final copy = Text(
      '© $year Kathiravan K. Crafted with Flutter & Dart.',
      style: AppTheme.body(13.5),
      textAlign: mobile ? TextAlign.center : TextAlign.start,
    );
    final top = TextButton.icon(
      onPressed: onTop,
      icon: const Icon(Icons.arrow_upward_rounded, size: 18),
      label: const Text('Back to top'),
      style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.hPad(context),
        vertical: 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContent),
          child: mobile
              ? Column(
                  children: [brand, const SizedBox(height: 10), copy, top],
                )
              : Row(
                  children: [
                    brand,
                    const SizedBox(width: 20),
                    Expanded(child: copy),
                    top,
                  ],
                ),
        ),
      ),
    );
  }
}
