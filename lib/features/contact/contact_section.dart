import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/gradient_button.dart';
import '../../utils/responsive_layout.dart';

// ── Replace with your Formspree form ID from https://formspree.io ──────────
const _formspreeEndpoint = 'https://formspree.io/f/YOUR_FORM_ID';

// ── Optional: Replace with your Calendly scheduling link ───────────────────
const _calendlyUrl = 'https://calendly.com/YOUR_USERNAME';

const String _myEmail = 'anasktk2125@gmail.com';
const String _myWhatsApp = '923241788391';

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

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    bool success = false;
    try {
      final response = await http.post(
        Uri.parse(_formspreeEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'message': message,
        }),
      );
      success = response.statusCode == 200;
    } catch (_) {
      success = false;
    }

    if (mounted) {
      setState(() {
        _loading = false;
        _submitted = success;
      });
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message could not be sent. Please try emailing directly.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.sectionKey,
      color: AppColors.bgSurface,
      child: SectionWrapper(
        child: Column(
          children: [
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
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.15)),
                  ),
                  child: Text(
                    'I typically respond within 24 hours',
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentCyan, fontSize: 11),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 600.ms),

            const SizedBox(height: 48),

            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _ContactCard(
                  icon: Icons.email_rounded,
                  label: 'Email Me',
                  subtitle: _myEmail,
                  color: AppColors.accentCyan,
                  onTap: () async {
                    final uri = Uri.parse('mailto:$_myEmail');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                ),
                _ContactCard(
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
                _ContactCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Schedule a Call',
                  subtitle: 'Pick a time that works',
                  color: const Color(0xFF9C6FFF),
                  onTap: () async {
                    final uri = Uri.parse(_calendlyUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 600.ms),

            const SizedBox(height: 48),

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

            Column(
              children: [
                Text('Find me on', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _SocialLink(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      url: 'https://github.com/anas',
                      isPrimary: true,
                    ),
                    _SocialLink(
                      label: 'LinkedIn',
                      icon: Icons.work_rounded,
                      url: 'https://linkedin.com/in/anas',
                      isPrimary: true,
                    ),
                    _SocialLink(
                      label: 'Email',
                      icon: Icons.email_rounded,
                      url: 'mailto:$_myEmail',
                    ),
                    _SocialLink(
                      label: 'WhatsApp',
                      icon: Icons.chat_rounded,
                      url: 'https://wa.me/923241788391?text=${Uri.encodeComponent("Hi Anas! I saw your portfolio and I'd like to connect.")}',
                      color: const Color(0xFF25D366),
                    ),
                    _SocialLink(
                      label: 'Facebook',
                      icon: Icons.facebook_rounded,
                      url: 'https://facebook.com/anas',
                      color: const Color(0xFF1877F2),
                      deEmphasized: true,
                    ),
                    _SocialLink(
                      label: 'TikTok',
                      icon: Icons.music_note_rounded,
                      url: 'https://tiktok.com/@anas',
                      color: const Color(0xFFFF0050),
                      deEmphasized: true,
                    ),
                  ],
                ),
              ],
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

            const SizedBox(height: 48),

            Text(
              '© 2024 Muhammad Anas · Built with Flutter',
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ContactCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
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
            gradient: _hovered
                ? LinearGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.08),
                      AppColors.bgCard,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? widget.color : AppColors.border,
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: widget.color.withValues(alpha: 0.15), blurRadius: 20)]
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
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(widget.subtitle,
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        gradient: AppColors.cardGradient,
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
              'Fill in the form and I\'ll get back to you within 24 hours.',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
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
                      label: 'Send Message',
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
        gradient: AppColors.cardGradient,
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
          Text('Message Sent!', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            "Thanks for reaching out! I'll get back to you within 24 hours.",
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms)
        .fadeIn(duration: 400.ms);
  }
}

class _SocialLink extends StatefulWidget {
  final String label;
  final IconData icon;
  final String url;
  final Color? color;
  final bool isPrimary;
  final bool deEmphasized;

  const _SocialLink({
    required this.label,
    required this.icon,
    required this.url,
    this.color,
    this.isPrimary = false,
    this.deEmphasized = false,
  });

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;
  final Color _defaultAccent = AppColors.accentCyan;

  Color get accent => widget.color ?? _defaultAccent;

  @override
  Widget build(BuildContext context) {
    final double height = widget.isPrimary ? 44 : (widget.deEmphasized ? 32 : 38);
    final double iconSize = widget.isPrimary ? 20 : (widget.deEmphasized ? 14 : 16);

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
          height: height,
          padding: EdgeInsets.symmetric(horizontal: widget.isPrimary ? 18 : (widget.deEmphasized ? 10 : 14)),
          decoration: BoxDecoration(
            color: _hovered ? accent.withValues(alpha: 0.1) : AppColors.bgCard,
            borderRadius: BorderRadius.circular(widget.isPrimary ? 10 : 8),
            border: Border.all(
              color: _hovered ? accent : AppColors.border,
              width: widget.isPrimary ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: iconSize, color: _hovered ? accent : AppColors.textSecondary),
              if (widget.isPrimary || !widget.deEmphasized) ...[
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: _hovered ? accent : AppColors.textSecondary,
                    fontWeight: widget.isPrimary ? FontWeight.w600 : FontWeight.w500,
                    fontSize: widget.isPrimary ? 12 : 10,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
