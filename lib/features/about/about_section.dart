import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/portfolio_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/firebase_providers.dart';
import '../../utils/responsive_layout.dart';

class AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;
  const AboutSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    const info = PortfolioData.personalInfo;

    return Container(
      key: sectionKey,
      color: AppColors.bgPrimary,
      child: SectionWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('// about me', style: AppTextStyles.codeStyle),
            const SizedBox(height: 8),
            Text('Passionate Developer.\nCrafting Digital Experiences.',
                style: AppTextStyles.headlineLarge),
            const SizedBox(height: 48),
            isMobile
                ? _MobileBentoGrid(info: info)
                : _DesktopBentoGrid(info: info),
          ],
        ),
      ),
    );
  }
}

class _DesktopBentoGrid extends StatelessWidget {
  final Map<String, String> info;
  const _DesktopBentoGrid({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 2, child: _BioCard()),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const _StatsCard(),
                  const SizedBox(height: 16),
                  _AvailCard(info: info),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _SocialCard(),
      ],
    );
  }
}

class _MobileBentoGrid extends StatelessWidget {
  final Map<String, String> info;
  const _MobileBentoGrid({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _BioCard(),
        const SizedBox(height: 16),
        const _StatsCard(),
        const SizedBox(height: 16),
        _AvailCard(info: info),
        const SizedBox(height: 16),
        const _SocialCard(),
      ],
    );
  }
}

class _BioCard extends ConsumerStatefulWidget {
  const _BioCard();

  @override
  ConsumerState<_BioCard> createState() => _BioCardState();
}

class _BioCardState extends ConsumerState<_BioCard> {
  bool _hovered = false;
  Future<void> _pickAndUpload() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please update the image in assets/images/Anas.png manually.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalInfo = ref.watch(personalInfoStreamProvider).value ?? {};
    final rawPhoto = (personalInfo['photoUrl'] ?? '').toString();
    final photoUrl = rawPhoto.isEmpty ? null : rawPhoto;
    final isAdmin = ref.watch(authStateProvider).value != null;
    final bio = PortfolioData.personalInfo['bio'] ?? '';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.accentCyan.withValues(alpha: 0.4) : AppColors.border,
            width: 1.2,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.accentCyan.withValues(alpha: 0.1), blurRadius: 24)]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3), width: 2),
                    image: DecorationImage(
                      image: photoUrl != null
                          ? NetworkImage(photoUrl) as ImageProvider
                          : const AssetImage('assets/images/Anas.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isAdmin)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickAndUpload,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: AppColors.accentCyan,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 14, color: Colors.black),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Muhammad Anas', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Flutter & Dart Developer', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accentCyan)),
                  const SizedBox(height: 12),
                  Text(bio, style: AppTextStyles.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }
}

class _StatsCard extends StatefulWidget {
  const _StatsCard();

  @override
  State<_StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<_StatsCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    const info = PortfolioData.personalInfo;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.accentTeal.withValues(alpha: 0.4) : AppColors.border,
            width: 1.2,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.accentTeal.withValues(alpha: 0.1), blurRadius: 24)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.trending_up_rounded, color: AppColors.accentTeal, size: 18),
                ),
                const SizedBox(width: 12),
                Text('Stats', style: AppTextStyles.titleMedium),
              ],
            ),
            const SizedBox(height: 20),
            _BentoStat(label: 'Years Experience', value: info['yearsOfExperience'] ?? ''),
            const SizedBox(height: 16),
            _BentoStat(label: 'Projects Completed', value: info['projectsCompleted'] ?? ''),
            const SizedBox(height: 16),
            _BentoStat(label: 'Happy Clients', value: info['happyClients'] ?? ''),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0);
  }
}

class _BentoStat extends StatelessWidget {
  final String label;
  final String value;
  const _BentoStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        ShaderMask(
          shaderCallback: (b) => AppColors.accentGradient.createShader(b),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _AvailCard extends StatelessWidget {
  final Map<String, String> info;
  const _AvailCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.accentCyan, size: 18),
              ),
              const SizedBox(width: 12),
              Text('Availability', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 20),
          _AvailRow(icon: Icons.location_on_rounded, text: info['location'] ?? ''),
          const SizedBox(height: 12),
          _AvailRow(icon: Icons.access_time_rounded, text: 'Remote collaboration (GMT+5 / PKT)'),
          const SizedBox(height: 12),
          _AvailRow(icon: Icons.work_rounded, text: 'Open to Full-time & Freelance'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.accentCyan),
                const SizedBox(width: 6),
                Text('Available now', style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentCyan, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0);
  }
}

class _AvailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _AvailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12))),
      ],
    );
  }
}

class _SocialCard extends StatelessWidget {
  const _SocialCard();

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.alternate_email_rounded, color: AppColors.accentCyan, size: 18),
              ),
              const SizedBox(width: 12),
              Text('Connect', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SocialBadge(
                label: 'GitHub',
                icon: Icons.code_rounded,
                url: 'https://github.com/anas',
                accentColor: const Color(0xFF6E40C9),
                isPrimary: true,
              ),
              _SocialBadge(
                label: 'LinkedIn',
                icon: Icons.work_rounded,
                url: 'https://linkedin.com/in/anas',
                accentColor: const Color(0xFF0A66C2),
                isPrimary: true,
              ),
              _SocialBadge(
                label: 'Email',
                icon: Icons.email_rounded,
                url: 'mailto:anasktk2125@gmail.com',
                accentColor: AppColors.accentCyan,
                isPrimary: false,
              ),
              _SocialBadge(
                label: 'WhatsApp',
                icon: Icons.chat_rounded,
                url: 'https://wa.me/923241788391?text=${Uri.encodeComponent("Hi Anas! I saw your portfolio and I'd like to connect.")}',
                accentColor: const Color(0xFF25D366),
                isPrimary: false,
              ),
              _SocialBadge(
                label: 'Facebook',
                icon: Icons.facebook_rounded,
                url: 'https://facebook.com/anas',
                accentColor: const Color(0xFF1877F2),
                isPrimary: false,
                deEmphasized: true,
              ),
              _SocialBadge(
                label: 'TikTok',
                icon: Icons.music_note_rounded,
                url: 'https://tiktok.com/@anas',
                accentColor: const Color(0xFFFF0050),
                isPrimary: false,
                deEmphasized: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'I typically respond within a few hours during working days.',
            style: AppTextStyles.labelMedium.copyWith(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }
}

class _SocialBadge extends StatefulWidget {
  final String label;
  final IconData icon;
  final String url;
  final Color accentColor;
  final bool isPrimary;
  final bool deEmphasized;

  const _SocialBadge({
    required this.label,
    required this.icon,
    required this.url,
    required this.accentColor,
    this.isPrimary = false,
    this.deEmphasized = false,
  });

  @override
  State<_SocialBadge> createState() => _SocialBadgeState();
}

class _SocialBadgeState extends State<_SocialBadge> {
  bool _hovered = false;

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
            color: _hovered ? widget.accentColor.withValues(alpha: 0.15) : AppColors.bgSurface,
            borderRadius: BorderRadius.circular(widget.isPrimary ? 10 : 8),
            border: Border.all(
              color: _hovered ? widget.accentColor : AppColors.border,
              width: widget.isPrimary ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: iconSize, color: _hovered ? widget.accentColor : AppColors.textSecondary),
              if (widget.isPrimary || !widget.deEmphasized) ...[
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: _hovered ? widget.accentColor : AppColors.textSecondary,
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

class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.accentCyan.withValues(alpha: 0.3) : AppColors.border,
            width: 1.2,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.accentCyan.withValues(alpha: 0.08), blurRadius: 24)]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
