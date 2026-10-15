import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/links.dart';
import '../core/resume_service.dart';
import 'common.dart';

enum ResumeAction { view, download, share }

/// One handler for every "resume" button on the site.
Future<void> handleResumeAction(BuildContext context, ResumeAction action) async {
  switch (action) {
    case ResumeAction.view:
      {
        final ok = await ResumeService.view();
        if (!ok && context.mounted) {
          showToast(context, 'Could not open the resume. Try Download instead.');
        }
      }
    case ResumeAction.download:
      {
        final ok = await ResumeService.download();
        if (context.mounted) {
          showToast(
            context,
            ok ? 'Resume download started' : 'Could not download the resume.',
          );
        }
      }
    case ResumeAction.share:
      await showShareDialog(context);
  }
}

Future<void> showShareDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _ShareDialog(),
  );
}

class _ShareDialog extends StatefulWidget {
  const _ShareDialog();

  @override
  State<_ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<_ShareDialog> {
  bool _resume = false;

  String get _url => _resume ? ResumeService.url : Links.siteUrl;
  String get _message => _resume
      ? 'Kathiravan K - Flutter Developer. Here is his resume: $_url'
      : 'Take a look at Kathiravan K\'s Flutter developer portfolio: $_url';

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _url));
    if (mounted) showToast(context, 'Link copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Share', style: AppTheme.heading(24)),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: const Text('Portfolio'),
                    selected: !_resume,
                    onSelected: (_) => setState(() => _resume = false),
                  ),
                  ChoiceChip(
                    label: const Text('Resume PDF'),
                    selected: _resume,
                    onSelected: (_) => setState(() => _resume = true),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.body(13.5),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copy link',
                      visualDensity: VisualDensity.compact,
                      onPressed: _copy,
                      icon: const Icon(Icons.copy_rounded, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ShareTile(
                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
                    label: 'WhatsApp',
                    color: AppColors.whatsapp,
                    onTap: () => Links.open(
                      Uri.parse(
                        'https://wa.me/?text=${Uri.encodeComponent(_message)}',
                      ),
                    ),
                  ),
                  _ShareTile(
                    icon: const FaIcon(FontAwesomeIcons.linkedinIn),
                    label: 'LinkedIn',
                    color: AppColors.linkedin,
                    onTap: () => Links.open(
                      Uri.https('www.linkedin.com', '/sharing/share-offsite/', {
                        'url': _url,
                      }),
                    ),
                  ),
                  _ShareTile(
                    icon: const FaIcon(FontAwesomeIcons.envelope),
                    label: 'Email',
                    color: AppColors.gmail,
                    onTap: () => Links.open(
                      Uri.https('mail.google.com', '/mail/', {
                        'view': 'cm',
                        'fs': '1',
                        'su': 'Kathiravan K - Flutter Developer',
                        'body': _message,
                      }),
                    ),
                  ),
                  _ShareTile(
                    icon: const Icon(Icons.link_rounded),
                    label: 'Copy link',
                    color: AppColors.primary,
                    onTap: _copy,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareTile extends StatelessWidget {
  const _ShareTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(color: color, size: 22),
                    child: icon,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.body(12.5, color: AppColors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
