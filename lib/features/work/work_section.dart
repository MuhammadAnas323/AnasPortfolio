import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/firebase_providers.dart';
import '../../utils/responsive_layout.dart';

const _defaultExperience = [
  {
    'id': '_xove',
    'order': 0,
    'title': 'Flutter Developer',
    'company': 'XovaCraft Tech',
    'period': 'June 2026 – Present',
    'location': 'On-site',
    'type': 'Full-time',
    'description':
        'Developing and maintaining cross-platform mobile app development projects using the Flutter framework, achieving high-performance optimization across mobile, web, and desktop targets. Spearheading REST API integration and implementing clean architecture to ensure a modular, scalable codebase, successfully delivering 100% production-ready features and performant UI/UX designs.',
    'highlights': <String>[],
    'tags': ['Flutter', 'Dart', 'REST APIs', 'Clean Architecture'],
  },
  {
    'id': '_logic',
    'order': 1,
    'title': 'Flutter Developer',
    'company': 'LogicCraft Technologies',
    'period': 'July 2025 – June 2026',
    'location': 'On-site',
    'type': 'Full-time',
    'description':
        'Contributed to the design, development, and deployment of cross-platform mobile app development solutions using Dart and the Flutter framework. Managed the full application lifecycle, implementing secure Firebase authentication and database backends, optimizing REST API integrations, and collaborating on Riverpod/Provider state management to ensure a clean architecture and scalable codebases.',
    'highlights': <String>[],
    'tags': ['Flutter', 'Dart', 'Firebase', 'Riverpod'],
  },
];


// ─── Stream Provider ───────────────────────────────────────────────────────────
final experienceStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('experience')
      .orderBy('order', descending: false)
      .snapshots()
      .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
});

// ─── Section Widget ────────────────────────────────────────────────────────────
class WorkSection extends ConsumerWidget {
  final GlobalKey sectionKey;
  const WorkSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expAsync = ref.watch(experienceStreamProvider);
    final isAdmin = ref.watch(authStateProvider).value != null;

    return Container(
      key: sectionKey,
      color: AppColors.bgPrimary,
      child: SectionWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('// experience', style: AppTextStyles.codeStyle),
                    const SizedBox(height: 8),
                    Text('Work & Companies',
                        style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Text(
                        'Companies and clients I have worked with and contributed to.',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ],
                ),
                if (isAdmin)
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Experience'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      foregroundColor: AppColors.bgPrimary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 48),

            // Timeline — always show real jobs, merge with Firestore entries
            expAsync.when(
              data: (firestoreItems) {
                // Use Firestore data if available, else fall back to hardcoded jobs
                final items = firestoreItems.isNotEmpty
                    ? firestoreItems
                    : List<Map<String, dynamic>>.from(_defaultExperience);
                return Column(
                  children: items
                      .asMap()
                      .entries
                      .map((e) => _ExperienceCard(
                            item: e.value,
                            isLast: e.key == items.length - 1,
                            isAdmin: isAdmin,
                          ))
                      .toList(),
                );
              },
              loading: () => Column(
                children: _defaultExperience
                    .asMap()
                    .entries
                    .map((e) => _ExperienceCard(
                          item: Map<String, dynamic>.from(e.value),
                          isLast: e.key == _defaultExperience.length - 1,
                          isAdmin: false,
                        ))
                    .toList(),
              ),
              error: (e, _) => Column(
                children: _defaultExperience
                    .asMap()
                    .entries
                    .map((entry) => _ExperienceCard(
                          item: Map<String, dynamic>.from(entry.value),
                          isLast: entry.key == _defaultExperience.length - 1,
                          isAdmin: false,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const _AddExperienceDialog());
  }
}




// ─── Experience Card ───────────────────────────────────────────────────────────
class _ExperienceCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isLast;
  final bool isAdmin;
  const _ExperienceCard(
      {required this.item, required this.isLast, required this.isAdmin});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final String title = item['title'] ?? 'Role';
    final String company = item['company'] ?? 'Company';
    final String period = item['period'] ?? '';
    final String location = item['location'] ?? '';
    final String description = item['description'] ?? '';
    final List<String> highlights =
        List<String>.from(item['highlights'] ?? []);
    final List<String> tags = List<String>.from(item['tags'] ?? []);
    final String type = item['type'] ?? 'Full-time';

    final Color accent = AppColors.accentCyan;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28, left: 32),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── The Card Content (Determines Stack Size) ───────────────────────
          MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _hovered ? AppColors.bgCardHover : AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _hovered ? accent : AppColors.border,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                            color: accent.withValues(alpha: 0.1),
                            blurRadius: 20)
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: role + period
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                ShaderMask(
                                  shaderCallback: (b) =>
                                      AppColors.accentGradient
                                          .createShader(b),
                                  child: Text(company,
                                      style: AppTextStyles.bodyMedium
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight:
                                                  FontWeight.w600)),
                                ),
                                if (location.isNotEmpty) ...[
                                  Text(' · ',
                                      style: AppTextStyles.labelMedium),
                                  Text(location,
                                      style: AppTextStyles.labelMedium),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: accent.withValues(alpha: 0.3)),
                            ),
                            child: Text(type,
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: accent)),
                          ),
                          if (period.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(period,
                                style: AppTextStyles.labelMedium
                                    .copyWith(
                                        color: AppColors.textSecondary)),
                          ],
                        ],
                      ),
                    ],
                  ),

                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(description, style: AppTextStyles.bodyMedium),
                  ],

                  if (highlights.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...highlights.map((h) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 14, color: accent),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(h,
                                      style: AppTextStyles.bodyMedium
                                          .copyWith(fontSize: 13))),
                            ],
                          ),
                        )),
                  ],

                  // Tech tags
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: accent.withValues(alpha: 0.35)),
                                ),
                                child: Text(
                                  tag,
                                  style: AppTextStyles.labelMedium
                                      .copyWith(color: accent, fontSize: 11),
                                ),
                              ))
                          .toList(),
                    ),
                  ],

                  // Admin delete button
                  if (widget.isAdmin) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('experience')
                              .doc(item['id'])
                              .delete();
                        },
                        icon: const Icon(Icons.delete_outline,
                            size: 14, color: Colors.redAccent),
                        label: const Text('Remove',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 12)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── The Timeline Line & Dot (Positioned Left) ──────────────────────
          Positioned(
            left: -24,
            top: 0,
            bottom: -28,
            child: Column(
              children: [
                // Timeline Dot
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent,
                    boxShadow: [
                      BoxShadow(
                          color: accent.withValues(alpha: 0.5), blurRadius: 8)
                    ],
                  ),
                ),
                // Timeline vertical line connecting items
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.border,
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.05, end: 0);
  }
}

// ─── Add Experience Dialog ─────────────────────────────────────────────────────
class _AddExperienceDialog extends StatefulWidget {
  const _AddExperienceDialog();

  @override
  State<_AddExperienceDialog> createState() => _AddExperienceDialogState();
}

class _AddExperienceDialogState extends State<_AddExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _periodCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _highlightCtrl = TextEditingController();
  final List<String> _highlights = [];
  String _type = 'Full-time';
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _periodCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    _highlightCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.labelMedium,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.accentCyan)),
      );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final snap = await FirebaseFirestore.instance.collection('experience').get();
    await FirebaseFirestore.instance.collection('experience').add({
      'title': _titleCtrl.text.trim(),
      'company': _companyCtrl.text.trim(),
      'period': _periodCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'highlights': _highlights,
      'type': _type,
      'order': snap.docs.length,
    });
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 560,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85),
        padding: const EdgeInsets.all(24),
        child: _saving
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.accentCyan))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Add Experience',
                              style: AppTextStyles.headlineSmall),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.textSecondary),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: _dec('Job Title (e.g. Flutter Developer)'),
                        validator: (v) =>
                            v!.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _companyCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: _dec('Company Name'),
                        validator: (v) =>
                            v!.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _periodCtrl,
                              style: const TextStyle(
                                  color: AppColors.textPrimary),
                              decoration: _dec('Period (e.g. Jan 2023 – Present)'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _locationCtrl,
                              style: const TextStyle(
                                  color: AppColors.textPrimary),
                              decoration: _dec('Location (e.g. Remote)'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _type,
                        dropdownColor: AppColors.bgSurface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: _dec('Employment Type'),
                        items: [
                          'Full-time',
                          'Part-time',
                          'Freelance',
                          'Contract',
                          'Internship'
                        ]
                            .map((t) =>
                                DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _type = v ?? 'Full-time'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: _dec('Brief description of your role'),
                      ),
                      const SizedBox(height: 12),
                      Text('Key Highlights',
                          style: AppTextStyles.titleMedium),
                      const SizedBox(height: 8),
                      ..._highlights.map((h) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text('• $h',
                                        style: AppTextStyles.bodyMedium)),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      size: 14, color: Colors.redAccent),
                                  onPressed: () => setState(
                                      () => _highlights.remove(h)),
                                ),
                              ],
                            ),
                          )),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _highlightCtrl,
                              style: const TextStyle(
                                  color: AppColors.textPrimary),
                              decoration:
                                  _dec('Add highlight (e.g. Reduced load time by 40%)'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: AppColors.accentCyan),
                            onPressed: () {
                              final h = _highlightCtrl.text.trim();
                              if (h.isNotEmpty) {
                                setState(() {
                                  _highlights.add(h);
                                  _highlightCtrl.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('Cancel',
                                style: TextStyle(
                                    color: AppColors.textSecondary)),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentCyan,
                              foregroundColor: AppColors.bgPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            onPressed: _save,
                            child: const Text('Save',
                                style: TextStyle(fontWeight: FontWeight.w700)),
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
}
