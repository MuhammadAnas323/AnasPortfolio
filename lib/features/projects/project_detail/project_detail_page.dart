import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/models/project_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../services/firebase_providers.dart';
import '../../../utils/responsive_layout.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;
  const ProjectDetailPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {
  late int _currentIndex;
  final ScrollController _scroll = ScrollController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  void _initCurrentIndex(List<ProjectModel> projects) {
    if (!_initialized && projects.isNotEmpty) {
      final index = projects.indexWhere((p) => p.id == widget.projectId);
      if (index != -1) {
        _currentIndex = index;
      }
      _initialized = true;
    }
  }

  void _goTo(int index) {
    setState(() => _currentIndex = index);
    _scroll.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  void _prev(int total) => _goTo((_currentIndex - 1 + total) % total);
  void _next(int total) => _goTo((_currentIndex + 1) % total);

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsStreamProvider);

    return projectsAsync.when(
      data: (projects) {
        if (projects.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.bgPrimary,
            body: Center(child: Text('Project not found', style: AppTextStyles.titleMedium)),
          );
        }

        _initCurrentIndex(projects);
        
        // Safety clamp just in case
        _currentIndex = _currentIndex.clamp(0, projects.length - 1).toInt();
        final project = projects[_currentIndex];

        final isDesktop = Responsive.isDesktop(context);
        final isMobile = Responsive.isMobile(context);

        Color accentColor;
        try {
          final hex = project.accentColorHex.replaceAll('#', '');
          accentColor = Color(int.parse('FF$hex', radix: 16));
        } catch (_) {
          accentColor = AppColors.accentCyan;
        }

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  children: [
                    // Hero banner
                    _ProjectHeroBanner(project: project, accentColor: accentColor, isMobile: isMobile),

                    // Content area
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: Responsive.desktopMaxWidth),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 60,
                            vertical: 48,
                          ),
                          child: isDesktop
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 7, child: _ProjectBody(project: project, accentColor: accentColor)),
                                    const SizedBox(width: 40),
                                    SizedBox(
                                      width: 240,
                                      child: _ProjectSidebar(
                                        projects: projects,
                                        currentIndex: _currentIndex,
                                        onSelect: _goTo,
                                      ),
                                    ),
                                  ],
                                )
                              : _ProjectBody(project: project, accentColor: accentColor),
                        ),
                      ),
                    ),

                    // Bottom padding for switcher bar
                    const SizedBox(height: 100),
                  ],
                ),
              ),

              // Sticky top bar
              Positioned(
                top: 0, left: 0, right: 0,
                child: _DetailTopBar(project: project, accentColor: accentColor),
              ),

              // Sticky bottom switcher
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _ProjectSwitcherBar(
                  currentIndex: _currentIndex,
                  total: projects.length,
                  currentTitle: project.title,
                  prevTitle: projects[(_currentIndex - 1 + projects.length) % projects.length].title,
                  nextTitle: projects[(_currentIndex + 1) % projects.length].title,
                  onPrev: () => _prev(projects.length),
                  onNext: () => _next(projects.length),
                  onBack: () => context.go('/'),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(child: CircularProgressIndicator(color: AppColors.accentCyan)),
      ),
      error: (e, st) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(child: Text('Error loading projects', style: AppTextStyles.titleMedium)),
      ),
    );
  }
}

// ─── Hero Banner ────────────────────────────────────────────────────────────

class _ProjectHeroBanner extends StatelessWidget {
  final ProjectModel project;
  final Color accentColor;
  final bool isMobile;
  const _ProjectHeroBanner({required this.project, required this.accentColor, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isMobile ? 260 : 360,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgSurface,
            accentColor.withOpacity(0.12),
            AppColors.bgPrimary,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Grid bg
          Positioned.fill(child: CustomPaint(painter: _GridPainter(accentColor))),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 20 : 80, 80, isMobile ? 20 : 80, 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Category chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: accentColor.withOpacity(0.4)),
                  ),
                  child: Text(project.category, style: AppTextStyles.labelMedium.copyWith(color: accentColor)),
                ),
                const SizedBox(height: 12),
                Text(
                  project.title,
                  style: AppTextStyles.displayMedium.copyWith(fontSize: isMobile ? 28 : 44),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 8),
                Text(project.tagline, style: AppTextStyles.bodyLarge)
                    .animate().fadeIn(delay: 150.ms, duration: 500.ms),
              ],
            ),
          ),
          // Bottom fade
          Positioned(
            bottom: 0, left: 0, right: 0, height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.bgPrimary],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Bar ────────────────────────────────────────────────────────────────

class _DetailTopBar extends StatelessWidget {
  final ProjectModel project;
  final Color accentColor;
  const _DetailTopBar({required this.project, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.95),
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
            onPressed: () => context.go('/'),
            tooltip: 'Back to Portfolio',
          ),
          const SizedBox(width: 8),
          Container(width: 2, height: 20, color: AppColors.border),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              project.title,
              style: AppTextStyles.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: accentColor.withOpacity(0.4)),
            ),
            child: Text(project.category,
                style: AppTextStyles.labelMedium.copyWith(color: accentColor, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

// ─── Project Body ───────────────────────────────────────────────────────────

class _ProjectBody extends StatelessWidget {
  final ProjectModel project;
  final Color accentColor;
  const _ProjectBody({required this.project, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        _Section(
          title: 'Overview',
          accentColor: accentColor,
          child: Text(project.description, style: AppTextStyles.bodyLarge),
        ),

        // Problem / Solution
        _TwoColSection(
          accentColor: accentColor,
          leftTitle: '🧩 The Problem',
          leftContent: project.problemStatement,
          rightTitle: '✅ The Solution',
          rightContent: project.solution,
        ),

        // Features
        _Section(
          title: 'Key Features',
          accentColor: accentColor,
          child: Column(
            children: project.features.map((f) => _FeatureRow(text: f, color: accentColor)).toList(),
          ),
        ),

        // Tech stack
        _Section(
          title: 'Tech Stack',
          accentColor: accentColor,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: project.techStack.map((t) => _TechBadge(label: t, color: accentColor)).toList(),
          ),
        ),

        // Action buttons
        _Section(
          title: 'Links',
          accentColor: accentColor,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (project.githubUrl != null)
                _ActionButton(label: 'View on GitHub', icon: Icons.code_rounded, color: accentColor),
              if (project.liveUrl != null)
                _ActionButton(label: 'Live Demo', icon: Icons.open_in_new_rounded, color: accentColor, filled: true),
              if (project.githubUrl == null && project.liveUrl == null)
                Text('Source code available on request.',
                    style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Widget child;
  const _Section({required this.title, required this.accentColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 20, color: accentColor, margin: const EdgeInsets.only(right: 10)),
              Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _TwoColSection extends StatelessWidget {
  final Color accentColor;
  final String leftTitle, leftContent, rightTitle, rightContent;
  const _TwoColSection({
    required this.accentColor,
    required this.leftTitle,
    required this.leftContent,
    required this.rightTitle,
    required this.rightContent,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final children = [
      Expanded(
        child: _InfoCard(title: leftTitle, content: leftContent, color: accentColor),
      ),
      if (!isMobile) const SizedBox(width: 20),
      Expanded(
        child: _InfoCard(title: rightTitle, content: rightContent, color: AppColors.accentTeal),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: isMobile
          ? Column(children: [
              _InfoCard(title: leftTitle, content: leftContent, color: accentColor),
              const SizedBox(height: 16),
              _InfoCard(title: rightTitle, content: rightContent, color: AppColors.accentTeal),
            ])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title, content;
  final Color color;
  const _InfoCard({required this.title, required this.content, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium.copyWith(color: color)),
          const SizedBox(height: 10),
          Text(content, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final Color color;
  const _FeatureRow({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

class _TechBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _TechBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: AppTextStyles.codeStyle.copyWith(color: color, fontSize: 13)),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  const _ActionButton({required this.label, required this.icon, required this.color, this.filled = false});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: widget.filled
              ? (_hovered ? widget.color.withOpacity(0.85) : widget.color)
              : (_hovered ? widget.color.withOpacity(0.1) : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: widget.color),
          boxShadow: _hovered
              ? [BoxShadow(color: widget.color.withOpacity(0.25), blurRadius: 12)]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 18,
                color: widget.filled ? AppColors.bgPrimary : widget.color),
            const SizedBox(width: 8),
            Text(widget.label,
                style: AppTextStyles.titleMedium.copyWith(
                  color: widget.filled ? AppColors.bgPrimary : widget.color,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Sidebar ─────────────────────────────────────────────────────────────────

class _ProjectSidebar extends StatelessWidget {
  final List<ProjectModel> projects;
  final int currentIndex;
  final void Function(int) onSelect;
  const _ProjectSidebar({required this.projects, required this.currentIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('All Projects', style: AppTextStyles.labelLarge),
          ),
          const Divider(color: AppColors.border, height: 1),
          ...projects.asMap().entries.map((e) {
            final i = e.key;
            final p = e.value;
            final isActive = i == currentIndex;
            Color accent;
            try {
              final hex = p.accentColorHex.replaceAll('#', '');
              accent = Color(int.parse('FF$hex', radix: 16));
            } catch (_) {
              accent = AppColors.accentCyan;
            }
            return _SidebarItem(
              title: p.title,
              category: p.category,
              accent: accent,
              isActive: isActive,
              onTap: () => onSelect(i),
            );
          }),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final String title, category;
  final Color accent;
  final bool isActive;
  final VoidCallback onTap;
  const _SidebarItem({
    required this.title, required this.category,
    required this.accent, required this.isActive, required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.accent.withOpacity(0.1)
                : (_hovered ? AppColors.bgCardHover : Colors.transparent),
            border: Border(
              left: BorderSide(
                color: widget.isActive ? widget.accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: widget.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(_categoryIcon(widget.category), color: widget.accent, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: widget.isActive ? AppColors.textPrimary : AppColors.textSecondary,
                          fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 12,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(widget.category, style: AppTextStyles.labelMedium.copyWith(fontSize: 10)),
                  ],
                ),
              ),
              if (widget.isActive)
                Icon(Icons.circle, color: widget.accent, size: 8),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Enterprise': return Icons.business_rounded;
      case 'Mobile App': return Icons.smartphone_rounded;
      case 'E-Commerce': return Icons.shopping_bag_rounded;
      case 'Health & Fitness': return Icons.fitness_center_rounded;
      case 'Productivity': return Icons.task_alt_rounded;
      default: return Icons.code_rounded;
    }
  }
}

// ─── Switcher Bar ────────────────────────────────────────────────────────────

class _ProjectSwitcherBar extends StatelessWidget {
  final int currentIndex, total;
  final String currentTitle, prevTitle, nextTitle;
  final VoidCallback onPrev, onNext, onBack;
  const _ProjectSwitcherBar({
    required this.currentIndex, required this.total,
    required this.currentTitle, required this.prevTitle, required this.nextTitle,
    required this.onPrev, required this.onNext, required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.97),
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 12),
      child: Row(
        children: [
          // Prev
          Expanded(
            child: _SwitcherButton(
              label: isMobile ? 'Prev' : prevTitle,
              icon: Icons.arrow_back_rounded,
              iconFirst: true,
              onTap: onPrev,
            ),
          ),

          // Center: back + progress
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onBack,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.grid_view_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text('Gallery', style: AppTextStyles.labelMedium),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text('${currentIndex + 1} / $total',
                  style: AppTextStyles.labelMedium.copyWith(fontSize: 10)),
            ],
          ),

          // Next
          Expanded(
            child: _SwitcherButton(
              label: isMobile ? 'Next' : nextTitle,
              icon: Icons.arrow_forward_rounded,
              iconFirst: false,
              onTap: onNext,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitcherButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool iconFirst;
  final VoidCallback onTap;
  const _SwitcherButton({
    required this.label, required this.icon,
    required this.iconFirst, required this.onTap,
  });

  @override
  State<_SwitcherButton> createState() => _SwitcherButtonState();
}

class _SwitcherButtonState extends State<_SwitcherButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.iconFirst ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: widget.iconFirst
          ? [
              Icon(widget.icon, size: 18, color: _hovered ? AppColors.accentCyan : AppColors.textSecondary),
              const SizedBox(width: 8),
              Flexible(child: Text(widget.label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _hovered ? AppColors.accentCyan : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis)),
            ]
          : [
              Flexible(child: Text(widget.label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _hovered ? AppColors.accentCyan : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              Icon(widget.icon, size: 18, color: _hovered ? AppColors.accentCyan : AppColors.textSecondary),
            ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accentCyan.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: content,
        ),
      ),
    );
  }
}

// ─── Grid Painter ────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  final Color color;
  const _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.06)..strokeWidth = 1;
    const spacing = 50.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
