import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../data/portfolio_data.dart';
import '../widgets/common.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/reveal.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      background: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Skills',
            title: 'The toolkit behind the apps',
            subtitle:
                'Technologies I use to design, build, ship and maintain production-grade mobile apps.',
          ),
          const SizedBox(height: 44),
          ResponsiveGrid(
            mobile: 1,
            tablet: 2,
            desktop: 3,
            children: [
              for (var i = 0; i < PortfolioData.skills.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 70 * (i % 3)),
                  child: _SkillCard(group: PortfolioData.skills[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: AppColors.brandGradient,
                ),
                child: Icon(group.icon, color: AppColors.bg, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  group.title,
                  style: AppTheme.heading(19),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final s in group.items) Tag(s)],
          ),
        ],
      ),
    );
  }
}
