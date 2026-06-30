import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1100;
  static const double desktopMaxWidth = 1280;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileBreakpoint && w < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? desktop;
    return mobile;
  }
}

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SectionWrapper({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Responsive.desktopMaxWidth),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? 20 : 60,
                vertical: 80,
              ),
          child: child,
        ),
      ),
    );
  }
}
