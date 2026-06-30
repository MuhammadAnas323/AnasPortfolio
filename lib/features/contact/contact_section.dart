import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/gradient_button.dart';
import '../../utils/responsive_layout.dart';

const String _myEmail = 'anasktk2125@gmail.com';
const String _myWhatsApp = '923241788391'; // international format no +

class ContactSection extends StatefulWidget {
  final GlobalKey sectionKey;
  const ContactSection({super.key, required this.sectionKey});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitted = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    // Build mailto link with pre-filled subject and body
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();
    final subject = Uri.encodeComponent('Portfolio Contact from $name');
    final body = Uri.encodeComponent('From: $name\nEmail: $email\n\n$message');
    final mailtoUri = Uri.parse('mailto:$_myEmail?subject=$subject&body=$body');

    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
    }

    setState(() {
      _loading = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      key: widget.sectionKey,
      color: AppColors.bgSurface,
      child: SectionWrapper(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Column(
              children: [
                Text('// get in touch', style: AppTextStyles.codeStyle),
                const SizedBox(height: 8),
                Text("Let's Work Together",
                    style: AppTextStyles.headlineLarge,
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(
                  "Have a project in mind or want to chat? I'm always open to new opportunities.",
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 48),

            // ── Quick contact buttons ────────────────────────────────────────
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _QuickContactCard(
                  icon: Icons.email_rounded,
                  label: 'Email Me',
                  subtitle: _myEmail,
                  color: AppColors.accentCyan,
                  onTap: () async {
                    final uri = Uri.parse('mailto:$_myEmail');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                ),
                _QuickContactCard(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  subtitle: '+92 324 1788391',
                  color: const Color(0xFF25D366),
                  onTap: () async {
                    final uri = Uri.parse(
                        'https://wa.me/$_myWhatsApp?text=${Uri.encodeComponent("Hi Anas! I saw your portfolio and I'd like to connect.")}');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 600.ms),

            const SizedBox(height: 48),

            // ── Contact form ─────────────────────────────────────────────────
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: _submitted
                  ? _SuccessState()
                  : _ContactForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      messageController: _messageController,
                      loading: _loading,
                      onSubmit: _submit,
                    ),
            ),

            const SizedBox(height: 64),

            // ── Social links row ─────────────────────────────────────────────
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _SocialLink(
                  icon: Icons.code_rounded,
                  label: 'GitHub',
                  url: 'https://github.com/anas',
                ),
                _SocialLink(
                  icon: Icons.work_rounded,
                  label: 'LinkedIn',
                  url: 'https://linkedin.com/in/anas',
                ),
                _SocialLink(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  url: 'mailto:$_myEmail',
                ),
                _SocialLink(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  url: 'https://wa.me/923241788391?text=${Uri.encodeComponent("Hi Anas! I saw your portfolio and I'd like to connect.")}',
                  color: const Color(0xFF25D366),
                ),
                _SocialLink(
                  icon: Icons.facebook_rounded,
                  label: 'Facebook',
                  url: 'https://facebook.com/anas',
                  color: const Color(0xFF1877F2),
                ),
                _SocialLink(
                  icon: Icons.music_note_rounded,
                  label: 'TikTok',
                  url: 'https://tiktok.com/@anas',
                  color: const Color(0xFFFF0050),
                ),
              ],
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

            const SizedBox(height: 48),

            // Footer
            Text(
              '© 2024 Muhammad Anas · Built with Flutter 💙',
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick Contact Card ────────────────────────────────────────────────────────

class _QuickContactCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _QuickContactCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickContactCard> createState() => _QuickContactCardState();
}

class _QuickContactCardState extends State<_QuickContactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withValues(alpha: 0.1)
                : AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? widget.color : AppColors.border,
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: widget.color.withValues(alpha: 0.2),
                        blurRadius: 20)
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.label,
                      style: AppTextStyles.titleMedium
                          .copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(widget.subtitle,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Contact Form ──────────────────────────────────────────────────────────────

class _ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final bool loading;
  final VoidCallback onSubmit;

  const _ContactForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.loading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send a Message', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Fill in the form and your email client will open automatically.',
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            if (!isMobile)
              Row(
                children: [
                  Expanded(
                      child: _Field(
                          label: 'Your Name',
                          controller: nameController,
                          validator: _requiredValidator)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _Field(
                          label: 'Your Email',
                          controller: emailController,
                          validator: _emailValidator,
                          keyboardType: TextInputType.emailAddress)),
                ],
              )
            else ...[
              _Field(
                  label: 'Your Name',
                  controller: nameController,
                  validator: _requiredValidator),
              const SizedBox(height: 16),
              _Field(
                  label: 'Your Email',
                  controller: emailController,
                  validator: _emailValidator,
                  keyboardType: TextInputType.emailAddress),
            ],
            const SizedBox(height: 16),
            _Field(
              label: 'Message',
              controller: messageController,
              validator: _requiredValidator,
              maxLines: 5,
              minLines: 4,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: loading
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    )
                  : GradientButton(
                      label: 'Send via Email',
                      icon: Icons.send_rounded,
                      onPressed: onSubmit,
                    ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  String? _requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');
    return emailRegex.hasMatch(v) ? null : 'Enter a valid email';
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;

  const _Field({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(color: AppColors.accentCyan),
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              gradient: AppColors.accentGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.black, size: 36),
          ),
          const SizedBox(height: 20),
          Text("Email Client Opened!", style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            "Your email client should have opened. Send the email and I'll get back to you within 24 hours!",
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 400.ms)
        .fadeIn(duration: 400.ms);
  }
}

// ── Social Link Button ────────────────────────────────────────────────────────

class _SocialLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final Color? color;
  const _SocialLink(
      {required this.icon, required this.label, required this.url, this.color});

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;
  final Color _defaultAccent = AppColors.accentCyan;

  Color get accent => widget.color ?? _defaultAccent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? accent.withValues(alpha: 0.1) : AppColors.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? accent : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  size: 18,
                  color: _hovered ? accent : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(widget.label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: _hovered ? accent : AppColors.textSecondary,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
