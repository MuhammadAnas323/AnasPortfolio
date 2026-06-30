import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/models/skill_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/firebase_providers.dart';
import '../../utils/responsive_layout.dart';
import 'add_skill_dialog.dart';

class SkillsSection extends ConsumerWidget {
  final GlobalKey sectionKey;
  const SkillsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final authState = ref.watch(authStateProvider);
    final skillsAsync = ref.watch(skillsStreamProvider);

    return Container(
      key: sectionKey,
      color: AppColors.bgSurface,
      child: SectionWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: _SectionHeader(
                    label: '// my toolbox',
                    title: 'Skills & Expertise',
                    subtitle:
                        'Technologies and tools I use to bring ideas to life — from pixel-perfect UIs to production-ready backends.',
                  ),
                ),
                if (authState.value != null)
                  ElevatedButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const AddSkillDialog(),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Skill'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentTeal,
                      foregroundColor: AppColors.bgPrimary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 48),

            // Category groups
            skillsAsync.when(
              data: (skills) {
                if (skills.isEmpty) {
                  return Center(
                    child: Text('No skills added yet.', style: AppTextStyles.bodyLarge),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ['Core', 'State', 'Backend', 'Platform', 'Database', 'Integration', 'Navigation', 'Design', 'Tools']
                    .map((cat) {
                      final categorySkills = skills
                          .where((s) => s.category == cat)
                          .toList();
                      if (categorySkills.isEmpty) return const SizedBox.shrink();
                      return _SkillCategory(
                        category: cat,
                        skills: categorySkills,
                        isMobile: isMobile,
                        isAdmin: authState.value != null,
                      );
                    }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error loading skills: $e')),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCategory extends StatelessWidget {
  final String category;
  final List<SkillModel> skills;
  final bool isMobile;
  final bool isAdmin;
  const _SkillCategory({
    required this.category,
    required this.skills,
    required this.isMobile,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.toUpperCase(),
            style: AppTextStyles.labelLarge.copyWith(fontSize: 11, letterSpacing: 2),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: skills.map((s) => _SkillCard(skill: s, isAdmin: isAdmin)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final SkillModel skill;
  final bool isAdmin;
  const _SkillCard({required this.skill, required this.isAdmin});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _visible = false;
  late AnimationController _barController;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _barAnim = Tween<double>(begin: 0, end: widget.skill.proficiency)
        .animate(CurvedAnimation(parent: _barController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  void _onVisible() {
    if (!_visible) {
      setState(() => _visible = true);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _barController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('skill-${widget.skill.name}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) _onVisible();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.bgCardHover : AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppColors.accentCyan.withOpacity(0.4)
                  : AppColors.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withOpacity(0.08),
                      blurRadius: 20,
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.skill.emoji,
                      style: const TextStyle(fontSize: 22)),
                  const Spacer(),
                  Text(
                    '${(widget.skill.proficiency * 100).round()}%',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.accentCyan,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.skill.name, style: AppTextStyles.titleMedium),
              const SizedBox(height: 10),
              // Animated proficiency bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AnimatedBuilder(
                  animation: _barAnim,
                  builder: (_, __) => Container(
                    height: 4,
                    child: Stack(
                      children: [
                        Container(color: AppColors.bgPrimary),
                        FractionallySizedBox(
                          widthFactor: _barAnim.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.accentGradient,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.isAdmin) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('skills')
                          .doc(widget.skill.id)
                          .delete();
                    },
                    child: const Icon(Icons.delete_outline,
                        size: 16, color: Colors.redAccent),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
    .animate(target: _visible ? 1 : 0)
    .fadeIn(duration: 500.ms)
    .slideY(begin: 0.2, end: 0);
  }
}

// Re-export _SectionHeader so other sections can use it
class _SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String subtitle;
  const _SectionHeader({
    required this.label,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.codeStyle),
        const SizedBox(height: 8),
        Text(title, style: AppTextStyles.headlineLarge),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(subtitle, style: AppTextStyles.bodyLarge),
        ),
      ],
    );
  }
}
