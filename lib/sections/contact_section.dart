import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../widgets/common.dart';
import '../widgets/reveal.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  String get _composed {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final who = email.isEmpty ? name : '$name ($email)';
    return 'Hi Kathiravan, I\'m $who.\n\n${_message.text.trim()}';
  }

  bool _validate() => _formKey.currentState?.validate() ?? false;

  void _sendWhatsApp() {
    if (!_validate()) return;
    Links.open(Links.whatsappChat(_composed));
  }

  void _sendGmail() {
    if (!_validate()) return;
    Links.open(
      Links.gmailCompose(
        subject: 'Portfolio enquiry from ${_name.text.trim()}',
        body: _composed,
      ),
    );
  }

  Future<void> _sendLinkedIn() async {
    if (!_validate()) return;
    // LinkedIn can't be pre-filled, so copy the message for easy pasting.
    await Clipboard.setData(ClipboardData(text: _composed));
    if (!mounted) return;
    showToast(context, 'Message copied. Paste it in the LinkedIn chat.');
    await Links.openString(Links.linkedin);
  }

  @override
  Widget build(BuildContext context) {
    final desktop = Responsive.isDesktop(context);

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          eyebrow: 'Contact',
          title: 'Let\'s build something great together',
          subtitle:
              'Have a project, role or idea in mind? Reach out on whichever channel you prefer. I usually reply quickly.',
        ),
        const SizedBox(height: 30),
        Reveal(
          child: _ContactTile(
            icon: const FaIcon(FontAwesomeIcons.whatsapp),
            color: AppColors.whatsapp,
            title: 'WhatsApp',
            value: Links.phoneDisplay,
            onTap: () => Links.open(
              Links.whatsappChat('Hi Kathiravan, I saw your portfolio.'),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          delay: const Duration(milliseconds: 70),
          child: _ContactTile(
            icon: const FaIcon(FontAwesomeIcons.envelope),
            color: AppColors.gmail,
            title: 'Gmail',
            value: Links.email,
            onTap: () => Links.open(
              Links.gmailCompose(subject: 'Hello Kathiravan'),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          delay: const Duration(milliseconds: 140),
          child: _ContactTile(
            icon: const FaIcon(FontAwesomeIcons.linkedinIn),
            color: AppColors.linkedin,
            title: 'LinkedIn',
            value: 'Kathiravan K',
            onTap: () => Links.openString(Links.linkedin),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          delay: const Duration(milliseconds: 210),
          child: _ContactTile(
            icon: const FaIcon(FontAwesomeIcons.github),
            color: Colors.white,
            title: 'GitHub',
            value: 'github.com/kathiravankk',
            onTap: () => Links.openString(Links.github),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          delay: const Duration(milliseconds: 280),
          child: _ContactTile(
            icon: const Icon(Icons.call_rounded),
            color: AppColors.accent,
            title: 'Call',
            value: Links.phoneDisplay,
            onTap: () => Links.open(Links.tel()),
          ),
        ),
      ],
    );

    final form = Reveal(
      delay: const Duration(milliseconds: 120),
      child: Panel(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send a message', style: AppTheme.heading(24)),
              const SizedBox(height: 6),
              Text(
                'Fill this in, then choose how you\'d like to send it.',
                style: AppTheme.body(14.5),
              ),
              const SizedBox(height: 22),
              _fieldsRow(
                context,
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Your name'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your name'
                      : null,
                ),
                TextFormField(
                  controller: _email,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(labelText: 'Your email (optional)'),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return null;
                    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)
                        ? null
                        : 'Enter a valid email';
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _message,
                minLines: 4,
                maxLines: 7,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Your message',
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().length < 5)
                    ? 'Please write a short message'
                    : null,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  AppButton(
                    label: 'WhatsApp',
                    variant: AppButtonVariant.solid,
                    color: AppColors.whatsapp,
                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
                    onPressed: _sendWhatsApp,
                  ),
                  AppButton(
                    label: 'Gmail',
                    variant: AppButtonVariant.solid,
                    color: AppColors.gmail,
                    icon: const FaIcon(FontAwesomeIcons.envelope),
                    onPressed: _sendGmail,
                  ),
                  AppButton(
                    label: 'LinkedIn',
                    variant: AppButtonVariant.solid,
                    color: AppColors.linkedin,
                    icon: const FaIcon(FontAwesomeIcons.linkedinIn),
                    onPressed: _sendLinkedIn,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Section(
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: info),
                const SizedBox(width: 48),
                Expanded(flex: 6, child: form),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [info, const SizedBox(height: 36), form],
            ),
    );
  }

  Widget _fieldsRow(BuildContext context, Widget a, Widget b) {
    if (Responsive.isMobile(context)) {
      return Column(children: [a, const SizedBox(height: 16), b]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: 16),
        Expanded(child: b),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final Widget icon;
  final Color color;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(color: color, size: 20),
                child: icon,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.body(12.5, height: 1.2)),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.body(
                    15.5,
                    weight: FontWeight.w600,
                    color: AppColors.text,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_outward_rounded,
              size: 20, color: AppColors.muted),
        ],
      ),
    );
  }
}
