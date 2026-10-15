import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../widgets/common.dart';
import '../widgets/gradient_text.dart';
import '../widgets/reveal.dart';
import '../widgets/share_dialog.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.onContact,
    required this.onResume,
  });

  final VoidCallback onContact;
  final ValueChanged<ResumeAction> onResume;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  final ValueNotifier<String> _typed = ValueNotifier<String>('');
  Timer? _timer;
  int _role = 0;
  int _chars = 0;
  int _pause = 0;
  int _tick = 0;
  bool _deleting = false;
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce == _reduceMotion && _timer != null) return;
    _reduceMotion = reduce;
    _timer?.cancel();
    if (reduce) {
      _ctrl.stop();
      _typed.value = PortfolioData.roles.first;
    } else {
      if (!_ctrl.isAnimating) _ctrl.repeat();
      _timer = Timer.periodic(const Duration(milliseconds: 70), _step);
    }
  }

  void _step(Timer _) {
    _tick++;
    final roles = PortfolioData.roles;
    final role = roles[_role];
    if (_pause > 0) {
      _pause--;
    } else if (!_deleting) {
      if (_chars < role.length) {
        _chars++;
      } else {
        _pause = 28;
        _deleting = true;
      }
    } else {
      if (_chars > 0) {
        _chars--;
      } else {
        _deleting = false;
        _role = (_role + 1) % roles.length;
        _pause = 6;
      }
    }
    final cursor = (_tick ~/ 7).isEven ? '▍' : ' ';
    _typed.value = '${role.substring(0, math.min(_chars, role.length))}$cursor';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    _typed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final desktop = Responsive.isDesktop(context);
    final screenH = MediaQuery.sizeOf(context).height;
    final minH = math.min(math.max(560.0, screenH), 920.0);
    final hPad = Responsive.hPad(context);

    final text = _HeroText(
      typed: _typed,
      onContact: widget.onContact,
      onResume: widget.onResume,
    );
    final orb = RepaintBoundary(child: _Orb(controller: _ctrl));

    return ClipRect(
      child: Stack(
        children: [
          Positioned.fill(child: _Backdrop(controller: _ctrl)),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: minH),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: Responsive.maxContent),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 112, hPad, 56),
                  child: desktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 6, child: text),
                            const SizedBox(width: 48),
                            Expanded(flex: 5, child: Center(child: orb)),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: orb),
                            const SizedBox(height: 36),
                            text,
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({
    required this.typed,
    required this.onContact,
    required this.onResume,
  });

  final ValueNotifier<String> typed;
  final VoidCallback onContact;
  final ValueChanged<ResumeAction> onResume;

  @override
  Widget build(BuildContext context) {
    final nameSize =
        Responsive.value<double>(context, mobile: 46, tablet: 64, desktop: 80);
    final roleSize =
        Responsive.value<double>(context, mobile: 22, tablet: 28, desktop: 32);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 16, color: AppColors.secondary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Based in ${PortfolioData.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.body(
                      13,
                      weight: FontWeight.w600,
                      color: AppColors.text,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Reveal(
          delay: const Duration(milliseconds: 100),
          child: Text(
            'Hi, I\'m',
            style: AppTheme.body(
              Responsive.value<double>(context, mobile: 18, desktop: 22),
              weight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Reveal(
          delay: const Duration(milliseconds: 180),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: GradientText(
              PortfolioData.name,
              style: AppTheme.heading(nameSize, height: 1.05),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Reveal(
          delay: const Duration(milliseconds: 260),
          child: SizedBox(
            height: roleSize * 1.5,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: ValueListenableBuilder<String>(
                valueListenable: typed,
                builder: (context, value, _) => Text(
                  value,
                  maxLines: 1,
                  style: AppTheme.heading(
                    roleSize,
                    weight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Reveal(
          delay: const Duration(milliseconds: 340),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Text(
              PortfolioData.heroIntro,
              style: AppTheme.body(
                Responsive.value<double>(context, mobile: 15.5, desktop: 17.5),
                height: 1.65,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Reveal(
          delay: const Duration(milliseconds: 420),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton(
                label: 'View Resume',
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () => onResume(ResumeAction.view),
              ),
              AppButton(
                label: 'Download CV',
                variant: AppButtonVariant.outline,
                icon: const Icon(Icons.download_rounded),
                onPressed: () => onResume(ResumeAction.download),
              ),
              SocialButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Share',
                onTap: () => onResume(ResumeAction.share),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Reveal(
          delay: const Duration(milliseconds: 500),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SocialButton(
                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                tooltip: 'Chat on WhatsApp',
                hoverColor: AppColors.whatsapp,
                onTap: () => Links.open(
                  Links.whatsappChat(
                    'Hi Kathiravan, I came across your portfolio.',
                  ),
                ),
              ),
              SocialButton(
                icon: const FaIcon(FontAwesomeIcons.linkedinIn),
                tooltip: 'LinkedIn',
                hoverColor: AppColors.linkedin,
                onTap: () => Links.openString(Links.linkedin),
              ),
              SocialButton(
                icon: const FaIcon(FontAwesomeIcons.envelope),
                tooltip: 'Email via Gmail',
                hoverColor: AppColors.gmail,
                onTap: () => Links.open(Links.gmailCompose(
                  subject: 'Hello Kathiravan',
                )),
              ),
              SocialButton(
                icon: const FaIcon(FontAwesomeIcons.github),
                tooltip: 'GitHub',
                onTap: () => Links.openString(Links.github),
              ),
              SocialButton(
                icon: const Icon(Icons.arrow_downward_rounded),
                tooltip: 'Get in touch',
                hoverColor: AppColors.accent,
                onTap: onContact,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Soft drifting colour blobs + faint grid. Static grid, animated blobs,
/// isolated in a RepaintBoundary so scrolling stays smooth.
class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.controller});

  final Animation<double> controller;

  Widget _blob(Alignment alignment, Color color, double size) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.30), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: _GridPainter()),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final t = controller.value * 2 * math.pi;
              return Stack(
                fit: StackFit.expand,
                children: [
                  _blob(
                    Alignment(-0.85 + 0.12 * math.sin(t),
                        -0.6 + 0.10 * math.cos(t)),
                    AppColors.primary,
                    560,
                  ),
                  _blob(
                    Alignment(0.95 - 0.12 * math.cos(t),
                        0.4 + 0.12 * math.sin(t)),
                    AppColors.secondary,
                    480,
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 140,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00070B1A), AppColors.bg],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;
    const step = 56.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Avatar with a rotating gradient ring and floating tech chips.
class _Orb extends StatelessWidget {
  const _Orb({required this.controller});

  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    final target =
        Responsive.value<double>(context, mobile: 230, tablet: 320, desktop: 400);
    final avail = MediaQuery.sizeOf(context).width - 2 * Responsive.hPad(context);
    final size = math.max(180.0, math.min(target, avail));

    Widget chip(Alignment a, String label, IconData icon, double phase) {
      return Align(
        alignment: a,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final dy =
                math.sin(controller.value * 2 * math.pi + phase) * 7;
            return Transform.translate(offset: Offset(0, dy), child: child);
          },
          child: _FloatChip(label: label, icon: icon),
        ),
      );
    }

    final avatarSize = size * 0.74;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Transform.rotate(
              angle: controller.value * 2 * math.pi,
              child: child,
            ),
            child: Container(
              width: size * 0.86,
              height: size * 0.86,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                    AppColors.accent,
                    AppColors.primary,
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: size * 0.81,
            height: size * 0.81,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bg,
            ),
          ),
          Container(
            width: avatarSize,
            height: avatarSize,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B2347), Color(0xFF0D1330)],
              ),
            ),
            child: Image.asset(PortfolioData.profileAsset, fit: BoxFit.cover),
          ),
          chip(const Alignment(-1, -0.55), 'Flutter', Icons.flutter_dash, 0),
          chip(const Alignment(1, -0.8), 'Dart', Icons.bolt_rounded, 1.6),
          chip(const Alignment(-0.95, 0.7), 'GetX', Icons.hub_rounded, 3.1),
          chip(const Alignment(1, 0.55), 'Firebase',
              Icons.local_fire_department_rounded, 4.4),
        ],
      ),
    );
  }
}

class _FloatChip extends StatelessWidget {
  const _FloatChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.body(
              12.5,
              weight: FontWeight.w700,
              color: AppColors.text,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
