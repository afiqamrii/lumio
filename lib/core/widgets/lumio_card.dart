import 'package:flutter/material.dart';

import '../theme/lumio_colors.dart';
import '../theme/lumio_motion.dart';
import '../theme/lumio_radius.dart';
import '../theme/lumio_shadows.dart';
import '../theme/lumio_spacing.dart';
import 'lumio_action_surface.dart';

class LumioCard extends StatelessWidget {
  const LumioCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.selected = false,
    this.elevated = false,
    this.color = LumioColors.surface,
    this.radius = LumioRadius.card,
    this.padding = const EdgeInsetsDirectional.all(LumioSpacing.md),
  }) : assert(
         onTap == null || semanticLabel != null,
         'Interactive cards need a descriptive semanticLabel.',
       );

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool selected;
  final bool elevated;
  final Color color;
  final BorderRadius radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selected)
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: LumioSpacing.sm),
            child: Icon(Icons.check_circle_rounded, color: LumioColors.primary),
          ),
        child,
      ],
    );
    if (onTap != null) {
      // Keep this a descriptive actionable card, not an unlabeled color toggle.
      if (semanticLabel == null || semanticLabel!.isEmpty) {
        throw ArgumentError('Interactive cards require a semanticLabel.');
      }
      return LumioActionSurface(
        label: semanticLabel!,
        onTap: onTap,
        selected: selected,
        background: selected ? LumioColors.primaryContainer : color,
        foreground: LumioColors.textPrimary,
        borderColor: selected ? LumioColors.primary : LumioColors.outlineSubtle,
        borderWidth: 1,
        boxShadow: elevated ? LumioShadows.card : null,
        padding: padding,
        radius: radius,
        child: content,
      );
    }
    return AnimatedContainer(
      duration: LumioMotion.duration(context, LumioMotion.standard),
      curve: LumioMotion.easing,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        border: Border.all(color: LumioColors.outlineSubtle),
        boxShadow: elevated ? LumioShadows.card : null,
      ),
      child: content,
    );
  }
}
