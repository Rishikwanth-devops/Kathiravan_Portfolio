import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/common.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/reveal.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop = Responsive.isDesktop(context);

    final story = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          eyebrow: 'About me',
          title: 'Turning ideas into apps people love to use',
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < PortfolioData.aboutParagraphs.length; i++)
          Reveal(
            delay: Duration(milliseconds: 80 * (i + 1)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                PortfolioData.aboutParagraphs[i],
                style: AppTheme.body(16.5, height: 1.7),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Reveal(
          delay: const Duration(milliseconds: 320),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final t in PortfolioData.aboutHighlights) Tag(t),
            ],
          ),
        ),
      ],
    );

    final stats = ResponsiveGrid(
      mobile: 2,
      tablet: 2,
      desktop: 2,
      spacing: 16,
      children: [
        for (var i = 0; i < PortfolioData.stats.length; i++)
          Reveal(
            delay: Duration(milliseconds: 100 * i),
            child: _StatCard(stat: PortfolioData.stats[i]),
          ),
      ],
    );

    final education = Reveal(
      delay: const Duration(milliseconds: 200),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _IconTitle(
              icon: Icons.school_outlined,
              title: 'Education',
            ),
            const SizedBox(height: 14),
            Text(
              PortfolioData.degree,
              style: AppTheme.body(
                16,
                weight: FontWeight.w700,
                color: AppColors.text,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Text(PortfolioData.college, style: AppTheme.body(14.5)),
            const SizedBox(height: 2),
            Text(
              PortfolioData.degreeMeta,
              style: AppTheme.body(13.5, color: AppColors.secondary),
            ),
            const SizedBox(height: 22),
            const _IconTitle(
              icon: Icons.verified_outlined,
              title: 'Certifications',
            ),
            const SizedBox(height: 14),
            for (final c in PortfolioData.certifications)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c[0],
                      style: AppTheme.body(
                        15,
                        weight: FontWeight.w600,
                        color: AppColors.text,
                        height: 1.35,
                      ),
                    ),
                    Text(c[1], style: AppTheme.body(13.5)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    final side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [stats, const SizedBox(height: 16), education],
    );

    return Section(
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: story),
                const SizedBox(width: 56),
                Expanded(flex: 5, child: side),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [story, const SizedBox(height: 40), side],
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final Stat stat;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CountUp(
            value: stat.value,
            decimals: stat.decimals,
            suffix: stat.suffix,
            size: Responsive.value<double>(context, mobile: 34, desktop: 42),
          ),
          const SizedBox(height: 6),
          Text(stat.label, style: AppTheme.body(13.5, height: 1.35)),
        ],
      ),
    );
  }
}

class _IconTitle extends StatelessWidget {
  const _IconTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 22),
        const SizedBox(width: 10),
        Text(title, style: AppTheme.heading(18)),
      ],
    );
  }
}
