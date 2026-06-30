import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/portfolio_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/firebase_providers.dart';
import '../../services/supabase_storage_service.dart';
import '../../utils/responsive_layout.dart';

class AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;
  const AboutSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final info = PortfolioData.personalInfo;

    return Container(
      key: sectionKey,
      color: AppColors.bgPrimary,
      child: SectionWrapper(
        child: isMobile
            ? _MobileAbout(info: info)
            : _DesktopAbout(info: info),
      ),
    );
  }
}

class _DesktopAbout extends StatelessWidget {
  final Map<String, String> info;
  const _DesktopAbout({required this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _AboutText(info: info)),
        const SizedBox(width: 80),
        Expanded(flex: 4, child: _AboutIllustration()),
      ],
    );
  }
}

class _MobileAbout extends StatelessWidget {
  final Map<String, String> info;
  const _MobileAbout({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AboutIllustration(),
        const SizedBox(height: 40),
        _AboutText(info: info),
      ],
    );
  }
}

class _AboutText extends StatelessWidget {
  final Map<String, String> info;
  const _AboutText({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// about me', style: AppTextStyles.codeStyle),
        const SizedBox(height: 8),
        Text('Passionate Developer.\nCrafting Digital Experiences.',
            style: AppTextStyles.headlineLarge),
        const SizedBox(height: 24),
        Text(
          info['bio'] ?? '',
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 32),
        _InfoRow(icon: Icons.location_on_rounded, label: info['location'] ?? ''),
        const SizedBox(height: 12),
        _InfoRow(icon: Icons.email_rounded, label: info['email'] ?? ''),
        const SizedBox(height: 12),
        _InfoRow(icon: Icons.chat_rounded, label: '+92 324 1788391 (WhatsApp)'),
        const SizedBox(height: 12),
        _InfoRow(icon: Icons.work_rounded, label: 'Open to Full-time & Freelance'),
        const SizedBox(height: 32),
        Row(
          children: [
            _BigStat(value: info['yearsOfExperience'] ?? '', label: 'Years of\nExperience'),
            const SizedBox(width: 32),
            _BigStat(value: info['projectsCompleted'] ?? '', label: 'Projects\nCompleted'),
            const SizedBox(width: 32),
            _BigStat(value: info['happyClients'] ?? '', label: 'Happy\nClients'),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accentCyan, size: 18),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value;
  final String label;
  const _BigStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (b) => AppColors.accentGradient.createShader(b),
          child: Text(value,
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
        Text(label,
            style: AppTextStyles.labelMedium.copyWith(height: 1.4)),
      ],
    );
  }
}

// ─── About Illustration Card ─────────────────────────────────────────────────

class _AboutIllustration extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfo = ref.watch(personalInfoStreamProvider).value ?? {};
    final _rawPhoto = (personalInfo['photoUrl'] ?? '').toString();
    final photoUrl = _rawPhoto.isEmpty ? null : _rawPhoto;
    final isAdmin = ref.watch(authStateProvider).value != null;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // ── Avatar ──────────────────────────────────────────
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  // Circle avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: photoUrl == null
                          ? const LinearGradient(
                              colors: [Color(0xFF0A1628), Color(0xFF0D1117)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      image: photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(photoUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: photoUrl == null
                        ? ShaderMask(
                            shaderCallback: (b) =>
                                AppColors.accentGradient.createShader(b),
                            child: const Icon(Icons.person,
                                size: 44, color: Colors.white),
                          )
                        : null,
                  ),
                  // Upload button (admin only) — small icon badge
                  if (isAdmin)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image =
                              await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Uploading photo...')));
                            final url = await SupabaseStorageService
                                .uploadProfilePhoto(image);
                            if (url != null) {
                              await FirebaseFirestore.instance
                                  .collection('settings')
                                  .doc('personal_info')
                                  .set({'photoUrl': url},
                                      SetOptions(merge: true));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Photo uploaded successfully!')));
                              }
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: AppColors.accentCyan,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 14, color: Colors.black),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Muhammad Anas', style: AppTextStyles.headlineSmall),
              Text('Flutter & Dart Developer', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              // Social icons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(icon: Icons.code_rounded, label: 'GitHub'),
                  const SizedBox(width: 12),
                  _SocialIcon(icon: Icons.work_outline_rounded, label: 'LinkedIn'),
                  const SizedBox(width: 12),
                  _SocialIcon(icon: Icons.email_outlined, label: 'Email'),
                  const SizedBox(width: 12),
                  _SocialIcon(
                    icon: Icons.chat_rounded,
                    label: 'WhatsApp',
                    color: const Color(0xFF25D366),
                  ),
                  const SizedBox(width: 12),
                  _SocialIcon(icon: Icons.facebook_rounded, label: 'Facebook', color: const Color(0xFF1877F2)),
                  const SizedBox(width: 12),
                  _SocialIcon(icon: Icons.music_note_rounded, label: 'TikTok', color: const Color(0xFFFF0050)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Tech tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            'Flutter', 'Dart', 'Firebase', 'Riverpod', 'Go Router',
            'REST APIs', 'Git', 'Figma',
          ].map((t) => _Tag(label: t)).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0);
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: AppTextStyles.labelMedium),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _SocialIcon({required this.icon, required this.label, this.color});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  String get _url {
    switch (widget.label) {
      case 'GitHub':
        return 'https://github.com/anas';
      case 'LinkedIn':
        return 'https://linkedin.com/in/anas';
      case 'Email':
        return 'mailto:anasktk2125@gmail.com';
      case 'WhatsApp':
        return 'https://wa.me/923241788391?text=${Uri.encodeComponent("Hi Anas! I saw your portfolio and I\'d like to connect.")}';
      case 'Facebook':
        return 'https://facebook.com/anas';
      case 'TikTok':
        return 'https://tiktok.com/@anas';
      default:
        return '';
    }
  }

  Color get _accent => widget.color ?? AppColors.accentCyan;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(_url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Tooltip(
          message: widget.label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _hovered
                  ? _accent.withValues(alpha: 0.15)
                  : AppColors.bgPrimary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _hovered ? _accent : AppColors.border,
              ),
            ),
            child: Icon(widget.icon,
                size: 20,
                color: _hovered ? _accent : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

