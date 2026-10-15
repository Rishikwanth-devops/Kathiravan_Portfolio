import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/app_colors.dart';
import '../core/links.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/footer_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/resume_section.dart';
import '../sections/skills_section.dart';
import '../widgets/nav_bar.dart';
import '../widgets/share_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _items = [
    'Home',
    'About',
    'Skills',
    'Experience',
    'Projects',
    'Contact',
  ];

  final _scroll = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _keys = List<GlobalKey>.generate(_items.length, (_) => GlobalKey());

  final _active = ValueNotifier<int>(0);
  final _scrolled = ValueNotifier<bool>(false);
  final _progress = ValueNotifier<double>(0);
  final _showTop = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _active.dispose();
    _scrolled.dispose();
    _progress.dispose();
    _showTop.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final p = _scroll.position;
    final o = p.pixels;
    _scrolled.value = o > 8;
    _showTop.value = o > 600;
    _progress.value =
        p.maxScrollExtent > 0 ? (o / p.maxScrollExtent).clamp(0.0, 1.0).toDouble() : 0;

    var a = 0;
    for (var i = 0; i < _keys.length; i++) {
      final box = _keys[i].currentContext?.findRenderObject();
      if (box is RenderBox && box.attached && box.hasSize) {
        if (box.localToGlobal(Offset.zero).dy <= 160) a = i;
      }
    }
    if (p.maxScrollExtent - o < 40) a = _keys.length - 1;
    if (_active.value != a) _active.value = a;
  }

  void _goTo(int i) {
    if (i == 0) {
      _toTop();
      return;
    }
    final box = _keys[i].currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !_scroll.hasClients) return;
    // Land just below the fixed 72px nav bar.
    final top = box.localToGlobal(Offset.zero).dy;
    final target = (_scroll.offset + top - 64)
        .clamp(0.0, _scroll.position.maxScrollExtent)
        .toDouble();
    _scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _toTop() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _resume(ResumeAction a) => handleResumeAction(context, a);

  Widget _section(int index, Widget child) => RepaintBoundary(
        child: KeyedSubtree(key: _keys[index], child: child),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bg,
      endDrawer: AppDrawer(
        items: _items,
        active: _active,
        onNavigate: _goTo,
        onResume: _resume,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                children: [
                  _section(
                    0,
                    HeroSection(
                      onContact: () => _goTo(5),
                      onResume: _resume,
                    ),
                  ),
                  _section(1, const AboutSection()),
                  _section(2, const SkillsSection()),
                  _section(3, const ExperienceSection()),
                  _section(4, const ProjectsSection()),
                  RepaintBoundary(child: ResumeSection(onResume: _resume)),
                  _section(5, const ContactSection()),
                  RepaintBoundary(child: FooterSection(onTop: _toTop)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              items: _items,
              active: _active,
              scrolled: _scrolled,
              onNavigate: _goTo,
              onMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
              onResume: _resume,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: ValueListenableBuilder<double>(
                valueListenable: _progress,
                builder: (context, v, _) => SizedBox(
                  height: 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: v,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                        ),
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _showTop,
                    builder: (context, show, _) => IgnorePointer(
                      ignoring: !show,
                      child: AnimatedScale(
                        scale: show ? 1 : 0,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        child: _RoundFab(
                          tooltip: 'Back to top',
                          color: AppColors.card,
                          borderColor: AppColors.borderStrong,
                          icon: const Icon(Icons.arrow_upward_rounded),
                          onTap: _toTop,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _RoundFab(
                    tooltip: 'Chat on WhatsApp',
                    color: AppColors.whatsapp,
                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
                    onTap: () => Links.open(
                      Links.whatsappChat(
                        'Hi Kathiravan, I visited your portfolio.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundFab extends StatelessWidget {
  const _RoundFab({
    required this.tooltip,
    required this.color,
    required this.icon,
    required this.onTap,
    this.borderColor,
  });

  final String tooltip;
  final Color color;
  final Color? borderColor;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color,
        elevation: 6,
        shadowColor: Colors.black54,
        shape: CircleBorder(
          side: borderColor == null
              ? BorderSide.none
              : BorderSide(color: borderColor!),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: IconTheme(
                data: const IconThemeData(color: Colors.white, size: 24),
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
