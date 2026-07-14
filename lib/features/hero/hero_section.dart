import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/gradient_button.dart';
import '../../services/firebase_providers.dart';
import '../../utils/responsive_layout.dart';

class HeroSection extends ConsumerWidget {
  final GlobalKey sectionKey;
  final VoidCallback onViewWork;

  const HeroSection({
    super.key,
    required this.sectionKey,
    required this.onViewWork,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      key: sectionKey,
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Stack(
        children: [
          const _GridBackground(),
          SectionWrapper(
            padding: EdgeInsets.only(
              left: isMobile ? 20 : 60,
              right: isMobile ? 20 : 60,
              top: 76,
              bottom: 60,
            ),
            child: isMobile
                ? _MobileHeroContent(onViewWork: onViewWork)
                : _DesktopHeroContent(onViewWork: onViewWork),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.bgPrimary.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHeroContent extends StatelessWidget {
  final VoidCallback onViewWork;
  const _DesktopHeroContent({required this.onViewWork});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _HeroTextColumn(onViewWork: onViewWork),
        ),
        const SizedBox(width: 80),
        _HeroPhoto(size: 280),
      ],
    );
  }
}

class _MobileHeroContent extends StatelessWidget {
  final VoidCallback onViewWork;
  const _MobileHeroContent({required this.onViewWork});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeroPhoto(size: 180),
        const SizedBox(height: 40),
        _HeroTextColumn(onViewWork: onViewWork),
      ],
    );
  }
}

class _HeroTextColumn extends ConsumerStatefulWidget {
  final VoidCallback onViewWork;
  const _HeroTextColumn({required this.onViewWork});

  @override
  ConsumerState<_HeroTextColumn> createState() => _HeroTextColumnState();
}

class _HeroTextColumnState extends ConsumerState<_HeroTextColumn> {
  String? _cvFileName;

  Future<void> _handleCvAction(BuildContext context, String? cvUrl) async {
    if (cvUrl != null && cvUrl.isNotEmpty && cvUrl.startsWith('http')) {
      final uri = Uri.parse(cvUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    if (kIsWeb) {
      final base = Uri.base;
      final cvUri = Uri(
        scheme: base.scheme,
        host: base.host,
        port: base.port,
        path: '${base.path.endsWith('/') ? base.path : '${base.path}/'}assets/CV/Muhammad_Anas_Flutter_Developer_CV(1).pdf',
      );
      try {
        await launchUrl(cvUri, mode: LaunchMode.externalApplication);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open CV. Try again later.')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CV is only viewable on the web version.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final personalInfo = ref.watch(personalInfoStreamProvider).value ?? {};
    final String? cvUrl = (personalInfo['cvUrl'] ?? '').toString().isEmpty
        ? null
        : personalInfo['cvUrl'].toString();
    final String storedCvFileName =
        (personalInfo['cvFileName'] ?? '').toString();
    final String displayCvName =
        _cvFileName ?? (storedCvFileName.isNotEmpty ? storedCvFileName : '');
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _AvailableBadge(),
        const SizedBox(height: 24),
        Text(
          "Hi, I'm Muhammad Anas",
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: isMobile ? 32 : 52,
          ),
        ).animate(target: reducedMotion ? 1 : null).fadeIn(
          delay: 400.ms, duration: 700.ms,
        ).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 8),
        Text(
          "Every successful app starts with an idea. I transform those ideas into fast, scalable, and impactful mobile applications.",
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: isMobile ? 14 : 17,
            height: 1.5,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate(target: reducedMotion ? 1 : null).fadeIn(
          delay: 500.ms, duration: 700.ms,
        ).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 12),
        _RotatingRoleText(),
        const SizedBox(height: 20),
        Text(
          'Flutter Developer | Cross-Platform Mobile Apps for iOS & Android',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.accentCyan,
            fontSize: isMobile ? 16 : 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate(target: reducedMotion ? 1 : null).fadeIn(
          delay: 600.ms, duration: 700.ms,
        ),
        const SizedBox(height: 12),
        Text(
          'Turning ideas into fast, scalable, production-ready apps.',
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: isMobile ? 14 : 16,
            height: 1.5,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate(target: reducedMotion ? 1 : null).fadeIn(
          delay: 800.ms, duration: 700.ms,
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            GradientButton(
              label: 'View My Work',
              icon: Icons.arrow_downward_rounded,
              onPressed: widget.onViewWork,
            ),
            GradientButton(
              label: displayCvName.isNotEmpty ? displayCvName : 'View CV',
              icon: Icons.picture_as_pdf_rounded,
              isOutlined: true,
              onPressed: () => _handleCvAction(context, cvUrl),
            ),
          ],
        ).animate(target: reducedMotion ? 1 : null).fadeIn(
          delay: 1000.ms, duration: 700.ms,
        ),
        const SizedBox(height: 32),
        _StatRow(),
        const SizedBox(height: 24),
        _TagRow(),
      ],
    );
  }
}

class _AvailableBadge extends StatefulWidget {
  @override
  State<_AvailableBadge> createState() => _AvailableBadgeState();
}

class _AvailableBadgeState extends State<_AvailableBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(_pulseCtrl);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accentCyan.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
        color: AppColors.accentCyan.withOpacity(0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          reducedMotion
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                )
              : AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentCyan.withOpacity(_pulseAnim.value * 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(width: 8),
          Text(
            'Available for opportunities',
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentCyan),
          ),
        ],
      ),
    );
  }
}

class _RotatingRoleText extends StatefulWidget {
  @override
  State<_RotatingRoleText> createState() => _RotatingRoleTextState();
}

class _RotatingRoleTextState extends State<_RotatingRoleText> {
  final _roles = [
    'Flutter Developer',
    'Cross-Platform App Engineer',
    'Firebase & REST API Specialist',
  ];
  int _index = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() => _index = (_index + 1) % _roles.length);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    return AnimatedSwitcher(
      duration: reducedMotion ? Duration.zero : const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(anim),
        ),
      ),
      child: Text(
        _roles[_index],
        key: ValueKey(_index),
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textSecondary,
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return Wrap(
      spacing: 40,
      runSpacing: 16,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        _HeroStat(value: '1+', label: 'Years Experience'),
        _HeroStat(value: '10+', label: 'Projects Delivered'),
        _HeroStat(value: '5+', label: 'Happy Clients'),
      ],
    ).animate(target: reducedMotion ? 1 : null).fadeIn(
      delay: 1200.ms, duration: 700.ms,
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppColors.accentGradient.createShader(bounds),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelMedium.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _TagRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.accentCyan.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accentCyan.withOpacity(0.15)),
      ),
      child: Text(
        'Startups  •  Agencies  •  Enterprises  •  Individual Founders',
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
        textAlign: isMobile ? TextAlign.center : TextAlign.left,
      ),
    ).animate(target: reducedMotion ? 1 : null).fadeIn(
      delay: 1400.ms, duration: 700.ms,
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  final double size;
  const _HeroPhoto({required this.size});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size,
        maxHeight: size,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentCyan.withValues(alpha: 0.15),
              blurRadius: 60,
              spreadRadius: 10,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/Anas.png',
            fit: BoxFit.cover,
            width: size,
            height: size,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 800.ms).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
    );
  }
}

class _GridBackground extends StatelessWidget {
  const _GridBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GridPainter(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentCyan.withOpacity(0.04)
      ..strokeWidth = 1;

    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
