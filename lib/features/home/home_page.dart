import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../nav/nav_bar.dart';
import '../hero/hero_section.dart';
import '../projects/projects_section.dart';
import '../skills/skills_section.dart';
import '../about/about_section.dart';
import '../contact/contact_section.dart';
import '../work/work_section.dart';
import '../../core/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TransformationController _transformationController = TransformationController();

  final GlobalKey _heroKey       = GlobalKey();
  final GlobalKey _projectsKey   = GlobalKey();
  final GlobalKey _skillsKey     = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _aboutKey      = GlobalKey();
  final GlobalKey _contactKey    = GlobalKey();

  // ── Zoom state ─────────────────────────────────────────────────────────────
  double _scale = 1.0;
  static const double _minScale = 0.5;
  static const double _maxScale = 2.0;
  static const double _zoomStep = 0.1;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(() {
      final double currentScale = _transformationController.value.getMaxScaleOnAxis();
      if ((currentScale - _scale).abs() > 0.01) {
        setState(() {
          _scale = currentScale;
        });
      }
    });
    _scrollController.addListener(() {
      if (_scale != 1.0) {
        _zoomReset();
      }
    });
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }
  void _handleZoom(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      // Ctrl + scroll → zoom; plain scroll → handled by scroll view
      final isCtrl = event.kind == PointerDeviceKind.mouse &&
          HardwareKeyboard.instance.isControlPressed;

      if (isCtrl) {
        final double zoomFactor = event.scrollDelta.dy < 0 ? 1.1 : 0.9;
        final double currentScale = _transformationController.value.getMaxScaleOnAxis();
        final double newScale = (currentScale * zoomFactor).clamp(_minScale, _maxScale);

        final Offset localOffset = event.localPosition;
        final Matrix4 matrix = _transformationController.value;
        final double tx = matrix.entry(0, 3);
        final double ty = matrix.entry(1, 3);

        final double scaleRatio = newScale / currentScale;
        final double newTx = localOffset.dx - (localOffset.dx - tx) * scaleRatio;
        final double newTy = localOffset.dy - (localOffset.dy - ty) * scaleRatio;

        setState(() {
          _scale = newScale;
          _transformationController.value = Matrix4.identity()
            ..setEntry(0, 3, newTx)
            ..setEntry(1, 3, newTy)
            ..setEntry(0, 0, newScale)
            ..setEntry(1, 1, newScale)
            ..setEntry(2, 2, newScale);
        });
      }
    }
  }

  void _zoomIn() {
    final double currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < _maxScale) {
      final double newScale = (currentScale + _zoomStep).clamp(_minScale, _maxScale);
      _updateScale(newScale);
    }
  }

  void _zoomOut() {
    final double currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > _minScale) {
      final double newScale = (currentScale - _zoomStep).clamp(_minScale, _maxScale);
      _updateScale(newScale);
    }
  }

  void _zoomReset() {
    setState(() {
      _scale = 1.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  void _updateScale(double newScale) {
    setState(() {
      _scale = newScale;
      _transformationController.value = Matrix4.identity()
        ..setEntry(0, 0, newScale)
        ..setEntry(1, 1, newScale)
        ..setEntry(2, 2, newScale);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Listener(
        onPointerSignal: _handleZoom,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: _minScale,
                maxScale: _maxScale,
                panEnabled: _scale > 1.0,
                scaleEnabled: false,
                constrained: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 64),
                      HeroSection(
                        sectionKey: _heroKey,
                        onViewWork: () => _scrollTo(_projectsKey),
                      ),
                      ProjectsSection(sectionKey: _projectsKey),
                      SkillsSection(sectionKey: _skillsKey),
                      WorkSection(sectionKey: _experienceKey),
                      AboutSection(sectionKey: _aboutKey),
                      ContactSection(sectionKey: _contactKey),
                    ],
                  ),
                ),
              ),
            ),

            // ── Nav bar (always on top, not zoomed) ─────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: NavBar(
                scrollController: _scrollController,
                heroKey: _heroKey,
                projectsKey: _projectsKey,
                skillsKey: _skillsKey,
                experienceKey: _experienceKey,
                aboutKey: _aboutKey,
                contactKey: _contactKey,
              ),
            ),

            // ── Zoom control buttons (bottom-right corner) ──────────────────
            Positioned(
              bottom: 24,
              right: 24,
              child: _ZoomControls(
                scale: _scale,
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
                onReset: _zoomReset,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Zoom control widget
// ─────────────────────────────────────────────────────────────────────────────

class _ZoomControls extends StatelessWidget {
  final double scale;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  const _ZoomControls({
    required this.scale,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF21262D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomBtn(
            icon: Icons.remove,
            tooltip: 'Zoom Out',
            onTap: onZoomOut,
            isLeftmost: true,
          ),
          // Scale indicator
          GestureDetector(
            onTap: onReset,
            child: Tooltip(
              message: 'Reset Zoom',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide(color: Color(0xFF30363D)),
                  ),
                ),
                child: Text(
                  '${(scale * 100).round()}%',
                  style: const TextStyle(
                    color: Color(0xFF00D4FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),
          _ZoomBtn(
            icon: Icons.add,
            tooltip: 'Zoom In',
            onTap: onZoomIn,
            isLeftmost: false,
          ),
        ],
      ),
    );
  }
}

class _ZoomBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isLeftmost;

  const _ZoomBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.isLeftmost,
  });

  @override
  State<_ZoomBtn> createState() => _ZoomBtnState();
}

class _ZoomBtnState extends State<_ZoomBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _hovered
                  ? const Color(0xFF00D4FF).withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.horizontal(
                left: widget.isLeftmost
                    ? const Radius.circular(12)
                    : Radius.zero,
                right: widget.isLeftmost
                    ? Radius.zero
                    : const Radius.circular(12),
              ),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _hovered
                  ? const Color(0xFF00D4FF)
                  : const Color(0xFF8B949E),
            ),
          ),
        ),
      ),
    );
  }
}
