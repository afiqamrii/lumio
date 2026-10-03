import 'package:flutter/material.dart';

import '../theme/lumio_colors.dart';
import '../theme/lumio_radius.dart';
import '../theme/lumio_spacing.dart';
import '../theme/lumio_typography.dart';

enum LumioBadgeTone { neutral, info, success, warning, error, glow }

class LumioBadge extends StatelessWidget {
  const LumioBadge({
    super.key,
    required this.label,
    this.tone = LumioBadgeTone.neutral,
  });

  final String label;
  final LumioBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, icon) = switch (tone) {
      LumioBadgeTone.neutral => (
        LumioColors.surfaceSubtle,
        LumioColors.textSecondary,
        Icons.circle_outlined,
      ),
      LumioBadgeTone.info => (
        LumioColors.infoContainer,
        LumioColors.info,
        Icons.info_outline_rounded,
      ),
      LumioBadgeTone.success => (
        LumioColors.surface,
        LumioColors.success,
        Icons.check_circle_outline_rounded,
      ),
      LumioBadgeTone.warning => (
        LumioColors.background,
        LumioColors.warning,
        Icons.warning_amber_rounded,
      ),
      LumioBadgeTone.error => (
        LumioColors.surface,
        LumioColors.error,
        Icons.error_outline_rounded,
      ),
      LumioBadgeTone.glow => (
        LumioColors.glow,
        LumioColors.onGlow,
        Icons.auto_awesome_rounded,
      ),
    };
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(LumioRadius.small),
            border: Border.all(color: foreground.withValues(alpha: 0.25)),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: LumioSpacing.sm,
              vertical: LumioSpacing.xs,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: LumioSpacing.xs,
              runSpacing: LumioSpacing.xs,
              children: [
                Icon(icon, size: LumioSpacing.md, color: foreground),
                Text(
                  label,
                  style: LumioTypography.labelMedium.copyWith(
                    color: foreground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
