import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/common.dart';
import '../widgets/reveal.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = PortfolioData.experience;
    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Experience',
            title: 'Where I\'ve shipped',
            subtitle:
                'From first internship to leading Flutter delivery on live, store-published products.',
          ),
          const SizedBox(height: 44),
          for (var i = 0; i < items.length; i++)
            Reveal(
              child: _TimelineItem(
                exp: items[i],
                isLast: i == items.length - 1,
                isCurrent: i == 0,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.exp,
    required this.isLast,
    required this.isCurrent,
  });

  final Experience exp;
  final bool isLast;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.brandGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withValues(alpha: isCurrent ? 0.7 : 0.3),
                        blurRadius: isCurrent ? 16 : 8,
                        spreadRadius: isCurrent ? 2 : 0,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLast
                      ? const SizedBox.shrink()
                      : Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.6),
                                AppColors.primary.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          SizedBox(width: mobile ? 14 : 28),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
              child: HoverCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exp.role, style: AppTheme.heading(mobile ? 21 : 25)),
                    const SizedBox(height: 6),
                    Text(
                      exp.company,
                      style: AppTheme.body(
                        15.5,
                        weight: FontWeight.w600,
                        color: AppColors.secondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        _Meta(Icons.calendar_today_outlined, exp.period),
                        _Meta(Icons.place_outlined, exp.location),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ExpandableBullets(items: exp.points),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.muted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(text, style: AppTheme.body(13.5, height: 1.3)),
        ),
      ],
    );
  }
}
