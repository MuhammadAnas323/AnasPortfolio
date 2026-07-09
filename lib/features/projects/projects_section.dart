import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/portfolio_data.dart';
import '../../core/models/project_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../utils/responsive_layout.dart';
import '../../services/firebase_providers.dart';
import '../../core/widgets/gradient_button.dart';
import 'add_project_dialog.dart';

class ProjectsSection extends ConsumerWidget {
  final GlobalKey sectionKey;
  const ProjectsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final projectsAsync = ref.watch(projectsStreamProvider);
    final authState = ref.watch(authStateProvider);
    final isLoggedIn = authState.value != null;

    return Container(
      key: sectionKey,
      color: AppColors.bgPrimary,
      child: SectionWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: _SectionHeader(
                    label: '// my work',
                    title: 'Projects',
                    subtitle: 'A selection of projects that showcase my skills in Flutter development, system design, and UX thinking.',
                  ),
                ),
                if (isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GradientButton(
                      label: 'Add Project',
                      icon: Icons.add,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddProjectDialog(),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 48),
            projectsAsync.when(
              data: (projectsList) {
                final displayProjects = projectsList.isEmpty ? PortfolioData.projects : projectsList;
                return _buildGrid(context, displayProjects, isLoggedIn, isMobile, isTablet);
              },
              loading: () => _buildGrid(context, PortfolioData.projects, isLoggedIn, isMobile, isTablet),
              error: (err, stack) => _buildGrid(context, PortfolioData.projects, isLoggedIn, isMobile, isTablet),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<ProjectModel> displayProjects, bool isLoggedIn, bool isMobile, bool isTablet) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
        crossAxisSpacing: 17,
        mainAxisSpacing: 17,
        mainAxisExtent: 266,
      ),
      itemCount: displayProjects.length,
      itemBuilder: (ctx, i) => _ProjectCard(
        project: displayProjects[i],
        isAdmin: isLoggedIn,
        onTap: () => context.push('/project/${displayProjects[i].id}'),
        onEdit: isLoggedIn
            ? () => showDialog(
                  context: context,
                  builder: (_) => AddProjectDialog(
                    project: displayProjects[i],
                  ),
                )
            : null,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Project Card
// ─────────────────────────────────────────────────────────────────────────────

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final bool isAdmin;
  const _ProjectCard({
    required this.project,
    required this.onTap,
    this.onEdit,
    this.isAdmin = false,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;
  // _visible resets to false when card fully leaves viewport so the
  // enter-animation fires symmetrically on BOTH scroll directions.
  bool _visible = false;

  Color get _accentColor {
    try {
      final hex = widget.project.accentColorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.accentCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('project-${widget.project.id}'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.1 && !_visible) {
          // Card entered viewport — trigger the enter animation
          setState(() => _visible = true);
        } else if (info.visibleFraction == 0 && _visible) {
          // Card fully left viewport — reset so animation re-fires on re-entry
          setState(() => _visible = false);
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: _visible ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 400),
          offset: _visible ? Offset.zero : const Offset(0, 0.08),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hovered ? _accentColor.withValues(alpha: 0.6) : AppColors.border,
                    width: 1,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: _accentColor.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 8),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top image / accent bar ────────────────────────────
                    if (widget.project.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                        child: widget.project.imageUrl.startsWith('http')
                            ? Image.network(
                                widget.project.imageUrl,
                                width: double.infinity,
                                height: 84,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [_accentColor, _accentColor.withValues(alpha: 0.4)],
                                    ),
                                  ),
                                ),
                              )
                            : Image.asset(
                                widget.project.imageUrl,
                                width: double.infinity,
                                height: 84,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 84,
                                  color: _accentColor.withValues(alpha: 0.08),
                                  child: Center(child: Icon(Icons.image_rounded, color: _accentColor, size: 28)),
                                ),
                              ),
                      )
                    else
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          gradient: LinearGradient(
                            colors: [_accentColor, _accentColor.withValues(alpha: 0.4)],
                          ),
                        ),
                      ),

                    // ── Card body ─────────────────────────────────────────
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 31,
                                  height: 31,
                                  decoration: BoxDecoration(
                                    color: _accentColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: _accentColor.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Icon(
                                    _getIcon(widget.project.category),
                                    color: _accentColor,
                                    size: 15,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgPrimary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(widget.project.category, style: AppTextStyles.labelMedium),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),

                            // Title
                            Text(
                              widget.project.title,
                              style: AppTextStyles.headlineSmall.copyWith(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),

                            // Tagline
                            Text(
                              widget.project.tagline,
                              style: AppTextStyles.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const Spacer(),

                            // Tech chip row
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: (widget.project.tools.isNotEmpty
                                      ? widget.project.tools
                                      : widget.project.techStack)
                                  .take(3)
                                  .map((t) => _TechChip(label: t, color: _accentColor))
                                  .toList(),
                            ),

                            const SizedBox(height: 7),

                            // View Details row
                            Row(
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: _hovered ? _accentColor : AppColors.textSecondary,
                                  ),
                                  child: const Text('View Details'),
                                ),
                                const SizedBox(width: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  transform: Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                    color: _hovered ? _accentColor : AppColors.textSecondary,
                                  ),
                                ),
                                if (widget.isAdmin) ...[
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: widget.onEdit,
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: _hovered
                                              ? _accentColor.withValues(alpha: 0.15)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: _hovered ? _accentColor : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category) {
      case 'Enterprise':
        return Icons.business_rounded;
      case 'Mobile App':
        return Icons.smartphone_rounded;
      case 'E-Commerce':
        return Icons.shopping_bag_rounded;
      case 'Health & Fitness':
        return Icons.fitness_center_rounded;
      case 'Productivity':
        return Icons.task_alt_rounded;
      default:
        return Icons.code_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tech Chip
// ─────────────────────────────────────────────────────────────────────────────

class _TechChip extends StatelessWidget {
  final String label;
  final Color color;
  const _TechChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: color.withValues(alpha: 0.9),
          fontSize: 8,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String subtitle;
  const _SectionHeader({required this.label, required this.title, required this.subtitle});

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
