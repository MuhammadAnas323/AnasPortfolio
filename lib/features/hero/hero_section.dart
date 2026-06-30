import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/gradient_button.dart';
import '../../services/supabase_storage_service.dart';
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

class _HeroText extends ConsumerWidget {
  final VoidCallback onViewWork;
  const _HeroText({required this.onViewWork});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final projectsCount = ref.watch(projectsStreamProvider).value?.length ?? 0;
    final personalInfo = ref.watch(personalInfoStreamProvider).value ?? {};
    final authState = ref.watch(authStateProvider);
    final bool isAdmin = authState.value != null;
    final String? cvUrl = (personalInfo['cvUrl'] ?? '').toString().isEmpty
        ? null
        : personalInfo['cvUrl'].toString();

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

        const SizedBox(height: 12),

        // Fixed role
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Text('A ', style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 20 : 28,
            )),
            Text(
              'Flutter & Dart Specialist',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.accentCyan,
                fontSize: isMobile ? 20 : 28,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 700.ms),

        const SizedBox(height: 24),

        // Bio
        Text(
          'I build beautiful, performant Flutter apps that run everywhere —\nmobile, web, and desktop. Clean code. Elegant design. Real results.',
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: isMobile ? 14 : 16,
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
              onPressed: onViewWork,
            ),
            // CV button — always shown; admin can upload, visitors can view
            if (isAdmin || cvUrl != null)
              GradientButton(
                label: isAdmin && cvUrl == null
                    ? 'Upload CV'
                    : cvUrl != null
                        ? 'View CV'
                        : 'Upload CV',
                icon: isAdmin && cvUrl == null
                    ? Icons.upload_file
                    : Icons.picture_as_pdf_rounded,
                isOutlined: true,
                onPressed: () async {
                  if (isAdmin && cvUrl == null) {
                    // Admin: pick & upload CV
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx'],
                    );
                    if (result != null && result.files.single.bytes != null) {
                      final file = XFile.fromData(
                          result.files.single.bytes!,
                          name: result.files.single.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Uploading CV...')));
                      final url = await SupabaseStorageService.uploadCV(file);
                      if (url != null) {
                        await FirebaseFirestore.instance
                            .collection('settings')
                            .doc('personal_info')
                            .set({'cvUrl': url}, SetOptions(merge: true));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('CV Uploaded Successfully!')));
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('CV Upload Failed')));
                        }
                      }
                    }
                  } else if (cvUrl != null) {
                    // Everyone: open CV in browser
                    final uri = Uri.parse(cvUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  } else if (isAdmin) {
                    // Admin but no CV yet — shouldn't reach here but upload anyway
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx'],
                    );
                    if (result != null && result.files.single.bytes != null) {
                      final file = XFile.fromData(
                          result.files.single.bytes!,
                          name: result.files.single.name);
                      final url = await SupabaseStorageService.uploadCV(file);
                      if (url != null) {
                        await FirebaseFirestore.instance
                            .collection('settings')
                            .doc('personal_info')
                            .set({'cvUrl': url}, SetOptions(merge: true));
                      }
                    }
                  }
                },
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
            const _StatChip(value: '3+', label: 'Years Exp.'),
            _StatChip(value: '$projectsCount+', label: 'Projects'),
            const _StatChip(value: '15+', label: 'Clients'),
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

class _HeroIllustration extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfo = ref.watch(personalInfoStreamProvider).value ?? {};
    final photoUrl = (personalInfo['photoUrl'] ?? '').toString();
    final photoUrlOrNull = photoUrl.isEmpty ? null : photoUrl;
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
            gradient: photoUrlOrNull == null
                ? const LinearGradient(
                    colors: [Color(0xFF0A1628), Color(0xFF0D1117)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
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
            image: photoUrlOrNull != null
                ? DecorationImage(
                    image: NetworkImage(photoUrlOrNull),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: photoUrlOrNull == null
              ? ClipOval(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (b) =>
                            AppColors.accentGradient.createShader(b),
                        child: const Icon(Icons.person,
                            size: 80, color: Colors.white),
                      ),
                    ],
                  ),
                )
              : null,
        ),
        // Camera badge for admin
        if (isAdmin)
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Uploading photo...')));
                  final url =
                      await SupabaseStorageService.uploadProfilePhoto(image);
                  if (url != null) {
                    await FirebaseFirestore.instance
                        .collection('settings')
                        .doc('personal_info')
                        .set({'photoUrl': url}, SetOptions(merge: true));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Photo uploaded successfully!')));
                    }
                  }
                }
              },
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
