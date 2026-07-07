import 'package:flutter/material.dart';
import '../constants/theme.dart';

/// Frosted-glass style card — white background with soft orange shadow
/// and an optional subtle orange border accent.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final bool showBorder;
  final Color? color;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 20,
    this.showBorder = true,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(radius),
        border: showBorder
            ? Border.all(
                color: ThemeColors.primary.withValues(alpha: 0.12),
                width: 1.2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primary.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 7),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      );
    }
    return card;
  }
}
