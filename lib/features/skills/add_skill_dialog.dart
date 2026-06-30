import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/skill_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AddSkillDialog extends StatefulWidget {
  const AddSkillDialog({super.key});

  @override
  State<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends State<AddSkillDialog> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emojiController = TextEditingController(text: '🚀');
  
  String _selectedCategory = 'Core';
  double _proficiency = 0.8;
  bool _isLoading = false;

  final List<String> _categories = [
    'Core', 'State', 'Backend', 'Platform', 'Database', 'Integration', 'Navigation', 'Design', 'Tools'
  ];

  Future<void> _saveSkill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final docRef = FirebaseFirestore.instance.collection('skills').doc();
      final skill = SkillModel(
        id: docRef.id,
        name: _nameController.text.trim(),
        category: _selectedCategory,
        emoji: _emojiController.text.trim(),
        proficiency: _proficiency,
      );

      await docRef.set(skill.toMap());

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding skill: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add New Skill', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _nameController,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Skill Name (e.g., Flutter)',
                  labelStyle: AppTextStyles.bodyMedium,
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.accentCyan)),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      dropdownColor: AppColors.bgCard,
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _emojiController,
                      style: AppTextStyles.bodyLarge,
                      decoration: const InputDecoration(
                        labelText: 'Emoji',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text('Proficiency: ${(_proficiency * 100).round()}%', style: AppTextStyles.bodyMedium),
              Slider(
                value: _proficiency,
                min: 0.0,
                max: 1.0,
                divisions: 20,
                activeColor: AppColors.accentCyan,
                onChanged: (val) => setState(() => _proficiency = val),
              ),
              
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: AppTextStyles.bodyMedium),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveSkill,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      foregroundColor: AppColors.bgPrimary,
                    ),
                    child: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgPrimary))
                        : const Text('Save Skill'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
