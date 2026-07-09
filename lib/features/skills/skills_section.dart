import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/constants/portfolio_data.dart';
import '../../core/models/skill_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/firebase_providers.dart';
import '../../utils/responsive_layout.dart';
import 'add_skill_dialog.dart';

// ─── Core skills (Tier 1): show proficiency bars ───────────────────────────
const _coreSkillIds = {
  'dart', 'flutter', 'riverpod', 'firebase', 'clean_arch', 'rest_api', 'getx', 'provider'
};

class SkillsSection extends ConsumerWidget {
  final GlobalKey sectionKey;
  const SkillsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final skillsAsync = ref.watch(skillsStreamProvider);

    return Container(
      key: sectionKey,
      color: AppColors.bgSurface,
      child: SectionWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: _SectionHeader(
                    label: '// my toolbox',
                    title: 'Skills & Expertise',
                    subtitle:
                        'Technologies I build with and tools that power my workflow.',
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

            skillsAsync.when(
              data: (firestoreSkills) {
                final Map<String, SkillModel> mergedSkills = {
                  for (var s in PortfolioData.skills) s.id: s
                };
                for (var s in firestoreSkills) {
                  mergedSkills[s.id] = s;
                }
                final skills = mergedSkills.values.toList();
                return _TieredSkillsLayout(skills: skills, isAdmin: authState.value != null);
              },
              loading: () => _TieredSkillsLayout(
                skills: PortfolioData.skills,
                isAdmin: authState.value != null,
              ),
              error: (e, st) => const _TieredSkillsLayout(
                skills: PortfolioData.skills,
                isAdmin: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Two-tier layout
// ─────────────────────────────────────────────────────────────────────────────

class _TieredSkillsLayout extends StatelessWidget {
  final List<SkillModel> skills;
  final bool isAdmin;

  const _TieredSkillsLayout({required this.skills, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final coreSkills = skills.where((s) => _coreSkillIds.contains(s.id)).toList();
    final toolSkills = skills.where((s) => !_coreSkillIds.contains(s.id)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tier 1: Core Skills ──────────────────────────────────────────────
        _TierHeader(
          title: 'Core Skills',
          subtitle: 'Technologies I build with every day',
          accent: AppColors.accentCyan,
        ),
        const SizedBox(height: 20),
        _CoreSkillsGrid(skills: coreSkills, isAdmin: isAdmin),

        const SizedBox(height: 48),

        // ── Tier 2: Tools & Workflow ─────────────────────────────────────────
        _TierHeader(
          title: 'Tools & Workflow',
          subtitle: 'Tools that power my development workflow',
          accent: const Color(0xFF9C6FFF),
        ),
        const SizedBox(height: 20),
        _ToolsPillGrid(skills: toolSkills, isAdmin: isAdmin),
      ],
    );
  }
}

// ─── Tier header ────────────────────────────────────────────────────────────

class _TierHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;
  const _TierHeader({
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE6EDF3),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tier 1 — Responsive grid with proficiency bars
// ─────────────────────────────────────────────────────────────────────────────

class _CoreSkillsGrid extends StatelessWidget {
  final List<SkillModel> skills;
  final bool isAdmin;
  const _CoreSkillsGrid({required this.skills, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns;
        if (width >= 1100) {
          columns = 4;
        } else if (width >= 750) {
          columns = 3;
        } else if (width >= 480) {
          columns = 2;
        } else {
          columns = 1;
        }

        const spacing = 14.0;
        final cardWidth = (width - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < skills.length; i++)
              SizedBox(
                width: cardWidth,
                child: _SkillCard(
                  skill: skills[i],
                  isAdmin: isAdmin,
                  index: i,
                ),
              ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tier 2 — Category-grouped pill badges (no percentage bars)
// ─────────────────────────────────────────────────────────────────────────────

class _ToolsPillGrid extends StatelessWidget {
  final List<SkillModel> skills;
  final bool isAdmin;
  const _ToolsPillGrid({required this.skills, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    // Group by category
    final Map<String, List<SkillModel>> grouped = {};
    for (final skill in skills) {
      grouped.putIfAbsent(skill.category, () => []).add(skill);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.indexed.map((entry) {
        final idx = entry.$1;
        final categoryEntry = entry.$2;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category label
              Text(
                categoryEntry.key,
                style: const TextStyle(
                  color: Color(0xFF8B949E),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 50 * idx),
                    duration: 400.ms,
                  ),
              const SizedBox(height: 10),
              // Pills
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categoryEntry.value.asMap().entries.map((e) {
                  return _ToolPill(
                    skill: e.value,
                    index: idx * 4 + e.key,
                    isAdmin: isAdmin,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Tool pill badge (no bar) ─────────────────────────────────────────────

class _ToolPill extends StatefulWidget {
  final SkillModel skill;
  final int index;
  final bool isAdmin;
  const _ToolPill({required this.skill, required this.index, required this.isAdmin});

  @override
  State<_ToolPill> createState() => _ToolPillState();
}

class _ToolPillState extends State<_ToolPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.skill.barColor;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered
              ? color.withValues(alpha: 0.15)
              : const Color(0xFF161B27),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _hovered
                ? color.withValues(alpha: 0.6)
                : const Color(0xFF2A3045),
            width: 1.2,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12)]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.skill.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 7),
            Text(
              widget.skill.name,
              style: TextStyle(
                color: _hovered ? color : const Color(0xFFE6EDF3),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.isAdmin) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('skills')
                      .doc(widget.skill.id)
                      .delete();
                },
                child: const Icon(Icons.close, size: 13, color: Colors.redAccent),
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 40 * (widget.index % 12)),
          duration: 450.ms,
        )
        .slideY(begin: 0.1, end: 0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Individual skill card (Tier 1) — proficiency bar
// ─────────────────────────────────────────────────────────────────────────────

class _SkillCard extends StatefulWidget {
  final SkillModel skill;
  final bool isAdmin;
  final int index;

  const _SkillCard({
    required this.skill,
    required this.isAdmin,
    required this.index,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _triggered = false;
  late AnimationController _barCtrl;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _barAnim = Tween<double>(begin: 0, end: widget.skill.proficiency)
        .animate(CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  void _onVisible() {
    if (!_triggered) {
      _triggered = true;
      Future.delayed(Duration(milliseconds: 80 * (widget.index % 4)), () {
        if (mounted) _barCtrl.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bar = widget.skill.barColor;

    return VisibilityDetector(
      key: Key('sk-${widget.skill.id}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15) _onVisible();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF1C2333)
                : const Color(0xFF161B27),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? bar.withValues(alpha: 0.50)
                  : const Color(0xFF2A3045),
              width: 1.2,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: bar.withValues(alpha: 0.14),
                      blurRadius: 22,
                      spreadRadius: 0,
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row 1: emoji + name ───────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: bar.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: bar.withValues(alpha: 0.30),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.skill.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.skill.name,
                      style: const TextStyle(
                        color: Color(0xFFE6EDF3),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ── Proficiency label + % ─────────────────────────────────────
              Row(
                children: [
                  const Text(
                    'Proficiency',
                    style: TextStyle(
                      color: Color(0xFF8B949E),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _barAnim,
                    builder: (_, __) => Text(
                      '${(_barAnim.value * 100).round()}%',
                      style: TextStyle(
                        color: bar,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // ── Animated progress bar ─────────────────────────────────────
              AnimatedBuilder(
                animation: _barAnim,
                builder: (_, __) {
                  return Stack(
                    children: [
                      Container(
                        height: 5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3045),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: _barAnim.value,
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                bar.withValues(alpha: 0.65),
                                bar,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: bar.withValues(alpha: 0.55),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // ── Admin delete ──────────────────────────────────────────────
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
                        size: 15, color: Colors.redAccent),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 60 * (widget.index % 8)),
          duration: 500.ms,
        )
        .slideY(begin: 0.15, end: 0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Section header
// ─────────────────────────────────────────────────────────────────────────────

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
