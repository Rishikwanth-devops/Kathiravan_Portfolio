import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import 'common.dart';
import 'gradient_text.dart';
import 'share_dialog.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.items,
    required this.active,
    required this.scrolled,
    required this.onNavigate,
    required this.onMenu,
    required this.onResume,
  });

  final List<String> items;
  final ValueNotifier<int> active;
  final ValueNotifier<bool> scrolled;
  final ValueChanged<int> onNavigate;
  final VoidCallback onMenu;
  final ValueChanged<ResumeAction> onResume;

  @override
  Widget build(BuildContext context) {
    final compact = Responsive.isCompactNav(context);
    return ValueListenableBuilder<bool>(
      valueListenable: scrolled,
      builder: (context, isScrolled, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.bg.withValues(alpha: isScrolled ? 0.94 : 0),
            border: Border(
              bottom: BorderSide(
                color: isScrolled ? AppColors.border : Colors.transparent,
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: Responsive.maxContent),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Responsive.hPad(context)),
                child: Row(
                  children: [
                    _Logo(onTap: () => onNavigate(0)),
                    const Spacer(),
                    if (compact)
                      IconButton(
                        tooltip: 'Menu',
                        onPressed: onMenu,
                        icon: const Icon(Icons.menu_rounded, size: 28),
                      )
                    else ...[
                      for (var i = 0; i < items.length; i++)
                        _NavLink(
                          label: items[i],
                          index: i,
                          active: active,
                          onTap: () => onNavigate(i),
                        ),
                      const SizedBox(width: 20),
                      _ResumeMenu(onSelected: onResume),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GradientText('KK', style: AppTheme.heading(26)),
            Text('.', style: AppTheme.heading(26, color: AppColors.accent)),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.index,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int index;
  final ValueNotifier<int> active;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.active,
      builder: (context, current, _) {
        final isActive = current == widget.index;
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.onTap,
          onHover: (h) => setState(() => _hover = h),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: AppTheme.body(
                    14.5,
                    weight: FontWeight.w600,
                    color: isActive || _hover
                        ? AppColors.text
                        : AppColors.muted,
                    height: 1.2,
                  ),
                  child: Text(widget.label),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  height: 2,
                  width: isActive ? 22 : 0,
                  decoration: const BoxDecoration(
                    gradient: AppColors.brandGradient,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResumeMenu extends StatelessWidget {
  const _ResumeMenu({required this.onSelected});

  final ValueChanged<ResumeAction> onSelected;

  PopupMenuItem<ResumeAction> _item(
    ResumeAction value,
    IconData icon,
    String label,
  ) {
    return PopupMenuItem<ResumeAction>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppColors.secondary),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ResumeAction>(
      tooltip: 'Resume',
      offset: const Offset(0, 52),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      onSelected: onSelected,
      itemBuilder: (_) => [
        _item(ResumeAction.view, Icons.visibility_outlined, 'View resume'),
        _item(ResumeAction.download, Icons.download_rounded, 'Download PDF'),
        _item(ResumeAction.share, Icons.share_outlined, 'Share'),
      ],
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_outlined,
                size: 18, color: AppColors.bg),
            const SizedBox(width: 8),
            Text(
              'Resume',
              style: AppTheme.body(
                14,
                weight: FontWeight.w700,
                color: AppColors.bg,
                height: 1.2,
              ),
            ),
            const Icon(Icons.arrow_drop_down_rounded, color: AppColors.bg),
          ],
        ),
      ),
    );
  }
}

/// Slide-in menu used on phones and tablets.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.items,
    required this.active,
    required this.onNavigate,
    required this.onResume,
  });

  final List<String> items;
  final ValueNotifier<int> active;
  final ValueChanged<int> onNavigate;
  final ValueChanged<ResumeAction> onResume;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Drawer(
      width: (w * 0.86).clamp(0.0, 340.0).toDouble(),
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
              child: Row(
                children: [
                  GradientText('KK', style: AppTheme.heading(28)),
                  Text('.',
                      style: AppTheme.heading(28, color: AppColors.accent)),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: active,
                builder: (context, current, _) => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final isActive = i == current;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      selected: isActive,
                      selectedTileColor:
                          AppColors.primary.withValues(alpha: 0.14),
                      title: Text(
                        items[i],
                        style: AppTheme.body(
                          17,
                          weight: FontWeight.w600,
                          color: isActive ? AppColors.text : AppColors.muted,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        onNavigate(i);
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  AppButton(
                    label: 'View',
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onResume(ResumeAction.view);
                    },
                  ),
                  AppButton(
                    label: 'Download',
                    variant: AppButtonVariant.outline,
                    icon: const Icon(Icons.download_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onResume(ResumeAction.download);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Wrap(
                spacing: 10,
                children: [
                  SocialButton(
                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
                    tooltip: 'WhatsApp',
                    hoverColor: AppColors.whatsapp,
                    onTap: () => Links.open(Links.whatsappChat()),
                  ),
                  SocialButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedinIn),
                    tooltip: 'LinkedIn',
                    hoverColor: AppColors.linkedin,
                    onTap: () => Links.openString(Links.linkedin),
                  ),
                  SocialButton(
                    icon: const FaIcon(FontAwesomeIcons.envelope),
                    tooltip: 'Gmail',
                    hoverColor: AppColors.gmail,
                    onTap: () => Links.open(Links.gmailCompose()),
                  ),
                  SocialButton(
                    icon: const FaIcon(FontAwesomeIcons.github),
                    tooltip: 'GitHub',
                    onTap: () => Links.openString(Links.github),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
