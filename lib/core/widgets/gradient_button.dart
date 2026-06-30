import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isOutlined;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isOutlined = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: widget.isOutlined
                ? null
                : (LinearGradient(
                    colors: _hovered
                        ? [AppColors.accentTeal, AppColors.accentCyan]
                        : [AppColors.accentCyan, AppColors.accentTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
            border: widget.isOutlined
                ? Border.all(
                    color: _hovered ? AppColors.accentTeal : AppColors.accentCyan,
                    width: 1.5,
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _hovered && !widget.isOutlined
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isOutlined ? AppColors.accentCyan : AppColors.bgPrimary,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: AppTextStyles.titleMedium.copyWith(
                  color: widget.isOutlined ? AppColors.accentCyan : AppColors.bgPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
