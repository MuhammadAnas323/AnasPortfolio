import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/gradient_button.dart';
import '../../services/firebase_providers.dart';

class AdminPanel extends ConsumerStatefulWidget {
  const AdminPanel({super.key});

  @override
  ConsumerState<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends ConsumerState<AdminPanel> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  bool _isUploadingPhoto = false;
  double _uploadPhotoProgress = 0.0;

  Future<void> _pickAndUploadCv() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please update the CV in assets/CV/Muhammad_Anas_Flutter_Developer_CV(1).pdf manually.')),
      );
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please update the image in assets/images/Anas.png manually.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalInfo = ref.watch(personalInfoStreamProvider).value ?? {};
    final cvUrl = (personalInfo['cvUrl'] ?? '').toString();
    final cvFileName = (personalInfo['cvFileName'] ?? '').toString();
    final hasCv = cvUrl.isNotEmpty || true; // Using local asset always

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        title: Text('Admin Panel', style: AppTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile Management', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Update your profile photo and CV.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                // Profile Photo Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle_rounded,
                            color: AppColors.accentCyan,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile Photo',
                                  style: AppTextStyles.titleMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Upload a new profile picture (JPG, PNG, max 5MB)',
                                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_isUploadingPhoto) ...[
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: _uploadPhotoProgress > 0.0 && _uploadPhotoProgress < 1.0
                              ? _uploadPhotoProgress
                              : null,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _uploadPhotoProgress > 0.0 && _uploadPhotoProgress < 1.0
                              ? 'Uploading Photo... ${(_uploadPhotoProgress * 100).round()}%'
                              : 'Uploading Photo...',
                          style: AppTextStyles.labelMedium,
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GradientButton(
                              label: _isUploadingPhoto ? 'Uploading...' : 'Upload Photo',
                              icon: _isUploadingPhoto ? Icons.hourglass_top : Icons.add_a_photo,
                              onPressed: _isUploadingPhoto ? null : _pickAndUploadPhoto,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // CV Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            hasCv ? Icons.picture_as_pdf_rounded : Icons.upload_file,
                            color: hasCv ? AppColors.accentCyan : AppColors.textSecondary,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hasCv ? cvFileName : 'No CV uploaded',
                                  style: AppTextStyles.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hasCv ? 'PDF file ready for download' : 'Upload a PDF to get started',
                                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_isUploading) ...[
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: _uploadProgress > 0.0 && _uploadProgress < 1.0
                              ? _uploadProgress
                              : null,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _uploadProgress > 0.0 && _uploadProgress < 1.0
                              ? 'Uploading... ${(_uploadProgress * 100).round()}%'
                              : 'Uploading...',
                          style: AppTextStyles.labelMedium,
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          if (hasCv) ...[
                            Expanded(
                              child: GradientButton(
                                label: 'View CV',
                                icon: Icons.visibility,
                                isOutlined: true,
                                onPressed: () async {
                                  final uri = Uri.parse(cvUrl);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: GradientButton(
                              label: _isUploading
                                  ? 'Uploading...'
                                  : hasCv
                                      ? 'Replace CV'
                                      : 'Upload CV',
                              icon: _isUploading
                                  ? Icons.hourglass_top
                                  : Icons.upload_file,
                              onPressed: _isUploading ? null : _pickAndUploadCv,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
