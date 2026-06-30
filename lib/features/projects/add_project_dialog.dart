import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/models/project_model.dart';
import '../../services/supabase_storage_service.dart';
import '../../services/firebase_providers.dart';

class AddProjectDialog extends ConsumerStatefulWidget {
  const AddProjectDialog({super.key});

  @override
  ConsumerState<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends ConsumerState<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _problemController = TextEditingController();
  final _solutionController = TextEditingController();
  final _linkController = TextEditingController();
  
  final _skillInputController = TextEditingController();
  final _toolInputController = TextEditingController();

  XFile? _selectedImage;
  String _selectedCategory = 'Mobile App';
  String _selectedAccentColor = '#00D4FF'; // Default Cyan

  final List<String> _skills = ['Flutter', 'Dart'];
  final List<String> _tools = ['Figma', 'VS Code'];

  final List<String> _categories = [
    'Mobile App',
    'Enterprise',
    'E-Commerce',
    'Health & Fitness',
    'Productivity',
    'UI/UX Design',
  ];

  final Map<String, Color> _accentColors = {
    'Cyan (#00D4FF)': const Color(0xFF00D4FF),
    'Teal (#00BFA5)': const Color(0xFF00BFA5),
    'Red (#FF6B6B)': const Color(0xFFFF6B6B),
    'Green (#34D399)': const Color(0xFF34D399),
    'Purple (#A78BFA)': const Color(0xFFA78BFA),
    'Yellow (#F59E0B)': const Color(0xFFF59E0B),
    'Blue (#60A5FA)': const Color(0xFF60A5FA),
  };

  @override
  void dispose() {
    _titleController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    _problemController.dispose();
    _solutionController.dispose();
    _linkController.dispose();
    _skillInputController.dispose();
    _toolInputController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await SupabaseStorageService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _addSkill() {
    final tag = _skillInputController.text.trim();
    if (tag.isNotEmpty && !_skills.contains(tag)) {
      setState(() {
        _skills.add(tag);
        _skillInputController.clear();
      });
    }
  }

  void _addTool() {
    final tag = _toolInputController.text.trim();
    if (tag.isNotEmpty && !_tools.contains(tag)) {
      setState(() {
        _tools.add(tag);
        _toolInputController.clear();
      });
    }
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a project image.')),
      );
      return;
    }

    ref.read(isUploadingProvider.notifier).state = true;

    try {
      // 1. Upload to Supabase Storage
      final uploadResult = await SupabaseStorageService.uploadProjectImage(_selectedImage!);
      if (uploadResult == null) {
        throw Exception('Failed to upload image to Supabase.');
      }

      // 2. Save metadata to Firestore
      final docRef = FirebaseFirestore.instance.collection('projects').doc();
      final String tagline = _taglineController.text.trim().isNotEmpty
          ? _taglineController.text.trim()
          : 'A ${_selectedCategory.toLowerCase()} built using ${_skills.join(", ")}';

      final project = ProjectModel(
        id: docRef.id,
        title: _titleController.text.trim(),
        tagline: tagline,
        description: _descriptionController.text.trim(),
        problemStatement: _problemController.text.trim().isNotEmpty
            ? _problemController.text.trim()
            : 'Designing a highly functional user experience.',
        solution: _solutionController.text.trim().isNotEmpty
            ? _solutionController.text.trim()
            : 'Developed a robust application with integrated Supabase & Firebase features.',
        techStack: _skills,
        features: [
          'Responsive design layouts',
          'Dynamic data retrieval',
          'High performance optimization',
        ],
        tools: _tools,
        githubUrl: _linkController.text.trim().contains('github') ? _linkController.text.trim() : null,
        liveUrl: !_linkController.text.trim().contains('github') && _linkController.text.trim().isNotEmpty 
            ? _linkController.text.trim() 
            : null,
        category: _selectedCategory,
        accentColorHex: _selectedAccentColor,
        imageUrl: uploadResult,
        imagePath: '',
      );

      await docRef.set(project.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project saved successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      ref.read(isUploadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUploading = ref.watch(isUploadingProvider);

    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 650,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        padding: const EdgeInsets.all(24),
        child: isUploading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentCyan)),
                    SizedBox(height: 24),
                    Text(
                      'Uploading Image & Saving Project...',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                    ),
                  ],
                ),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Add New Project', style: AppTextStyles.headlineSmall),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.textSecondary),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Title
                      TextFormField(
                        controller: _titleController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: _inputDecoration('Project Title (e.g. FitTrack)'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 12),

                      // Tagline
                      TextFormField(
                        controller: _taglineController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: _inputDecoration('Tagline / Subtitle (optional)'),
                      ),
                      const SizedBox(height: 12),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: _inputDecoration('Project Description'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Description is required' : null,
                      ),
                      const SizedBox(height: 12),

                      // Category and Accent color selection
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              dropdownColor: AppColors.bgSurface,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: _inputDecoration('Category'),
                              items: _categories.map((c) {
                                return DropdownMenuItem(value: c, child: Text(c));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCategory = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _accentColors.keys.firstWhere(
                                (k) => '#${_accentColors[k]!.value.toRadixString(16).substring(2).toUpperCase()}' == _selectedAccentColor,
                                orElse: () => _accentColors.keys.first,
                              ),
                              dropdownColor: AppColors.bgSurface,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: _inputDecoration('Accent Color'),
                              items: _accentColors.keys.map((k) {
                                return DropdownMenuItem(
                                  value: k,
                                  child: Row(
                                    children: [
                                      Container(width: 12, height: 12, color: _accentColors[k]),
                                      const SizedBox(width: 8),
                                      Text(k.split(' ')[0]),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  final colorHex = '#${_accentColors[val]!.value.toRadixString(16).substring(2).toUpperCase()}';
                                  setState(() => _selectedAccentColor = colorHex);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Image picker
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedImage == null ? 'No image selected' : _selectedImage!.name,
                                    style: AppTextStyles.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Upload project screenshot or design',
                                    style: AppTextStyles.labelMedium.copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (_selectedImage != null)
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    _selectedImage!.path,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image, color: AppColors.textSecondary),
                                  ),
                                ),
                              ),
                            GradientButton(
                              label: 'Pick File',
                              icon: Icons.upload_file,
                              isOutlined: true,
                              onPressed: _pickImage,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Skills (chips dynamic list)
                      Text('Skills Used', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _skills.map((s) {
                          return Chip(
                            label: Text(s, style: const TextStyle(color: AppColors.textPrimary)),
                            backgroundColor: AppColors.bgCard,
                            deleteIcon: const Icon(Icons.close, size: 14, color: Colors.redAccent),
                            onDeleted: () => setState(() => _skills.remove(s)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _skillInputController,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: _inputDecoration('Add custom skill...'),
                              onFieldSubmitted: (_) => _addSkill(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: AppColors.accentCyan),
                            onPressed: _addSkill,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tools (chips dynamic list)
                      Text('Tools Used', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _tools.map((t) {
                          return Chip(
                            label: Text(t, style: const TextStyle(color: AppColors.textPrimary)),
                            backgroundColor: AppColors.bgCard,
                            deleteIcon: const Icon(Icons.close, size: 14, color: Colors.redAccent),
                            onDeleted: () => setState(() => _tools.remove(t)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _toolInputController,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: _inputDecoration('Add custom tool...'),
                              onFieldSubmitted: (_) => _addTool(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: AppColors.accentCyan),
                            onPressed: _addTool,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Project link
                      TextFormField(
                        controller: _linkController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: _inputDecoration('Live Demo / GitHub Link (optional)'),
                      ),
                      const SizedBox(height: 24),

                      // Submit & cancel buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 16),
                          GradientButton(
                            label: 'Save Project',
                            icon: Icons.save_rounded,
                            onPressed: _saveProject,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.labelMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.accentCyan),
      ),
    );
  }
}
