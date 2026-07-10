import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../utils/responsive_layout.dart';
import '../../services/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavBar extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final GlobalKey heroKey;
  final GlobalKey projectsKey;
  final GlobalKey skillsKey;
  final GlobalKey experienceKey;
  final GlobalKey aboutKey;
  final GlobalKey contactKey;

  const NavBar({
    super.key,
    required this.scrollController,
    required this.heroKey,
    required this.projectsKey,
    required this.skillsKey,
    required this.experienceKey,
    required this.aboutKey,
    required this.contactKey,
  });

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  bool _isScrolled = false;
  bool _mobileMenuOpen = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 50;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  void _scrollToSection(GlobalKey key) {
    setState(() => _mobileMenuOpen = false);
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final authState = ref.watch(authStateProvider);
    final isLoggedIn = authState.value != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isScrolled
            ? AppColors.bgSurface.withOpacity(0.95)
            : Colors.transparent,
        border: _isScrolled
            ? const Border(
                bottom: BorderSide(color: AppColors.border, width: 1))
            : null,
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                )
              ]
            : [],
      ),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: Responsive.desktopMaxWidth),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 60),
                    child: Row(
                      children: [
                        // Logo
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if (GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString() != '/') {
                                context.go('/');
                              } else {
                                _scrollToSection(widget.heroKey);
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.accentGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'A',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Muhammad Anas.',
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isMobile)
                          IconButton(
                            icon: Icon(
                              _mobileMenuOpen ? Icons.close : Icons.menu,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: () =>
                                setState(() => _mobileMenuOpen = !_mobileMenuOpen),
                          )
                        else
                          Row(
                            children: [
                              _NavLink('Home', () => _scrollToSection(widget.heroKey)),
                              _NavLink('Projects', () => _scrollToSection(widget.projectsKey)),
                              _NavLink('Skills', () => _scrollToSection(widget.skillsKey)),
                              _NavLink('Experience', () => _scrollToSection(widget.experienceKey)),
                              _NavLink('About', () => _scrollToSection(widget.aboutKey)),
                              if (isLoggedIn) ...[
                                const SizedBox(width: 4),
                                _NavLink('Admin', () => context.go('/admin')),
                                const SizedBox(width: 8),
                              ],
                              _ContactButton(() => _scrollToSection(widget.contactKey)),
                              if (isLoggedIn) ...[
                                const SizedBox(width: 8),
                                _NavLink('Sign Out', () => FirebaseAuth.instance.signOut()),
                                const SizedBox(width: 10),
                                _NavAvatar(),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Mobile Drawer
          if (isMobile && _mobileMenuOpen)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              color: AppColors.bgSurface,
              child: Column(
                children: [
                  const Divider(color: AppColors.border, height: 1),
                  _MobileNavLink('Home', () => _scrollToSection(widget.heroKey)),
                  _MobileNavLink('Projects', () => _scrollToSection(widget.projectsKey)),
                  _MobileNavLink('Skills', () => _scrollToSection(widget.skillsKey)),
                  _MobileNavLink('Experience', () => _scrollToSection(widget.experienceKey)),
                  _MobileNavLink('About', () => _scrollToSection(widget.aboutKey)),
                  if (isLoggedIn)
                    _MobileNavLink('Admin', () {
                      context.go('/admin');
                      setState(() => _mobileMenuOpen = false);
                    }),
                  _MobileNavLink('Contact', () => _scrollToSection(widget.contactKey)),
                  if (isLoggedIn)
                    _MobileNavLink('Sign Out', () {
                      FirebaseAuth.instance.signOut();
                      setState(() => _mobileMenuOpen = false);
                    }),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink(this.label, this.onTap);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.navLink.copyWith(
                  color: _hovered ? AppColors.accentCyan : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: _hovered ? 20 : 0,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ContactButton(this.onTap);

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            gradient: _hovered ? AppColors.accentGradient : null,
            border: Border.all(color: AppColors.accentCyan, width: 1.5),
            borderRadius: BorderRadius.circular(6),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.accentCyan.withOpacity(0.25), blurRadius: 12)]
                : [],
          ),
          child: Text(
            'Contact',
            style: AppTextStyles.navLink.copyWith(
              color: _hovered ? AppColors.bgPrimary : AppColors.accentCyan,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _MobileNavLink(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Text(label, style: AppTextStyles.titleMedium),
      ),
    );
  }
}

// ── Navbar Avatar ─────────────────────────────────────────────────────────────
class _NavAvatar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfo = ref.watch(personalInfoStreamProvider).value ?? {};
    final rawPhoto = (personalInfo['photoUrl'] ?? '').toString();
    final photoUrl = rawPhoto.isEmpty ? null : rawPhoto;

    final avatarImage = photoUrl != null
        ? NetworkImage(photoUrl) as ImageProvider
        : const AssetImage('assets/images/Profile.jpeg') as ImageProvider;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accentCyan, width: 2),
        image: DecorationImage(
          image: avatarImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
