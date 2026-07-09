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
          // Animated background grid
          const _GridBackground(),
          // Content
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
          // Bottom gradient fade
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
          child: _HeroText(onViewWork: onViewWork),
        ),
        const SizedBox(width: 80),
        _HeroIllustration(),
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
        _HeroIllustration(),
        const SizedBox(height: 40),
        _HeroText(onViewWork: onViewWork),
      ],
    );
  }
}

class _HeroText extends ConsumerStatefulWidget {
  final VoidCallback onViewWork;
  const _HeroText({required this.onViewWork});

  @override
  ConsumerState<_HeroText> createState() => _HeroTextState();
}

class _HeroTextState extends ConsumerState<_HeroText> {
  String? _cvFileName;

  Future<void> _handleCvAction(BuildContext context, String? cvUrl) async {
    // If there's a remote URL, launch it
    if (cvUrl != null && cvUrl.isNotEmpty && cvUrl.startsWith('http')) {
      final uri = Uri.parse(cvUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    // Open the bundled local asset PDF
    if (kIsWeb) {
      // Build absolute URL from the current page base so browser can open it
      final base = Uri.base;
      final cvUri = Uri(
        scheme: base.scheme,
        host: base.host,
        port: base.port,
        path: '${base.path.endsWith('/') ? base.path : '${base.path}/'}assets/CV/Flutter_CV.pdf',
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

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accentCyan.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(20),
            color: AppColors.accentCyan.withOpacity(0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.accentCyan.withOpacity(0.6), blurRadius: 6),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('Available for opportunities', style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentCyan)),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 24),

        // Name
        Text(
          "Hi, I'm Muhammad Anas",
          style: AppTextStyles.displayLarge.copyWith(
            fontSize: isMobile ? 32 : 52,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 700.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 12),        // Tagline / Role
        Text(
          'Flutter Developer | Cross-Platform Mobile App Developer',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.accentCyan,
            fontSize: isMobile ? 18 : 26,
            fontWeight: FontWeight.w600,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate().fadeIn(delay: 600.ms, duration: 700.ms),

        const SizedBox(height: 24),

        // Subtext / Bio
        Text(
          'Developing high-performance cross-platform mobile app development solutions using Dart and the Flutter framework. Specialized in state management (Riverpod/Provider), Firebase backend systems, and REST API integration, focusing on UI/UX excellence, clean architecture, and performance optimization.',
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: isMobile ? 14 : 16,
            height: 1.5,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ).animate().fadeIn(delay: 800.ms, duration: 700.ms),
        const SizedBox(height: 40),

        // CTAs
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientButton(
                  label: displayCvName.isNotEmpty ? displayCvName : 'View CV',
                  icon: Icons.picture_as_pdf_rounded,
                  isOutlined: true,
                  onPressed: () => _handleCvAction(context, cvUrl),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(delay: 1000.ms, duration: 700.ms),

        const SizedBox(height: 48),

        // Stats
        Wrap(
          spacing: 40,
          runSpacing: 20,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _StatChip(value: '1+', label: 'Years Exp.'),
            _StatChip(value: '10+', label: 'Projects'),
            const _StatChip(value: '5+', label: 'Clients'),
          ],
        ).animate().fadeIn(delay: 1200.ms, duration: 700.ms),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppColors.accentGradient.createShader(bounds),
          child: Text(value,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
        Text(label, style: AppTextStyles.labelMedium),
      ],
    );
  }
}

class _HeroIllustration extends ConsumerStatefulWidget {
  @override
  ConsumerState<_HeroIllustration> createState() => _HeroIllustrationState();
}

class _HeroIllustrationState extends ConsumerState<_HeroIllustration> {
  bool _isUploadingPhoto = false;
  double _photoUploadProgress = 0.0;

  Future<void> _pickAndUploadPhoto() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please update the image in assets/images/Profile.jpeg manually.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(authStateProvider).value != null;
    final size = Responsive.isMobile(context) ? 180.0 : 260.0;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
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
            image: const DecorationImage(
              image: AssetImage('assets/images/Profile.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        if (_isUploadingPhoto)
          Positioned(
            bottom: 50,
            right: 8,
            left: 8,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _photoUploadProgress > 0.0 && _photoUploadProgress < 1.0
                      ? _photoUploadProgress
                      : null,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.accentCyan),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(_photoUploadProgress * 100).round()}%',
                  style: AppTextStyles.labelMedium.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        if (isAdmin && !_isUploadingPhoto)
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: _pickAndUploadPhoto,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bgPrimary, width: 2),
                ),
                child: const Icon(Icons.camera_alt,
                    size: 18, color: Colors.black),
              ),
            ),
          ),
      ],
    )
    .animate()
    .fadeIn(delay: 300.ms, duration: 800.ms)
    .scale(
        begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
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
