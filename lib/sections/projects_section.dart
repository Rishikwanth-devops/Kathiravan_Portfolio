import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../data/portfolio_data.dart';
import '../widgets/common.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/reveal.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      background: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Projects',
            title: 'Apps in the wild',
            subtitle:
                'Production apps I\'ve architected and shipped, with the impact they delivered.',
          ),
          const SizedBox(height: 44),
          ResponsiveGrid(
            mobile: 1,
            tablet: 1,
            desktop: 2,
            spacing: 24,
            children: [
              for (var i = 0; i < PortfolioData.projects.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 80 * (i % 2)),
                  child: _ProjectCard(project: PortfolioData.projects[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: Icon(project.icon, color: AppColors.bg, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, style: AppTheme.heading(23)),
                    const SizedBox(height: 6),
                    Text(
                      project.tagline,
                      style: AppTheme.body(14.5, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in project.metrics) Tag(m, color: AppColors.accent),
            ],
          ),
          const SizedBox(height: 20),
          ExpandableBullets(items: project.points, fontSize: 14),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in project.tags) Tag(t, color: AppColors.secondary),
            ],
          ),
          const SizedBox(height: 22),
          AppButton(
            label: project.linkLabel,
            variant: AppButtonVariant.outline,
            icon: FaIcon(project.linkIcon),
            onPressed: () => Links.openString(project.link),
          ),
        ],
      ),
    );
  }
}
