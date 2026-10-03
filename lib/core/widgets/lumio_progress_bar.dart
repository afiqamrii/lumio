import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/lumio_colors.dart';
import '../theme/lumio_motion.dart';
import '../theme/lumio_radius.dart';
import '../theme/lumio_spacing.dart';
import '../theme/lumio_typography.dart';

/// A presentation-only fraction. Out-of-range values clamp; non-finite input
/// safely renders zero. This widget contains no progression or reward logic.
class LumioProgressBar extends StatelessWidget {
  const LumioProgressBar({super.key, required this.value, required this.label});

  final double value;
  final String label;

  double get normalizedValue => value.isFinite ? value.clamp(0.0, 1.0) : 0;

  @override
  Widget build(BuildContext context) {
    final progress = normalizedValue;
    final percentage = NumberFormat.percentPattern(
      Localizations.localeOf(context).toString(),
    ).format(progress);
    return Semantics(
      label: label,
      value: percentage,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: LumioSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(label, style: LumioTypography.labelMedium),
                Text(percentage, style: LumioTypography.labelMedium),
                if (progress == 1)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: LumioColors.success,
                    size: LumioSpacing.lg,
                  ),
              ],
            ),
            const SizedBox(height: LumioSpacing.sm),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: progress, end: progress),
              duration: LumioMotion.duration(context, LumioMotion.standard),
              curve: LumioMotion.easing,
              builder: (context, animatedValue, child) => ClipRRect(
                borderRadius: BorderRadius.circular(LumioRadius.pill),
                child: LinearProgressIndicator(
                  value: animatedValue,
                  minHeight: LumioSpacing.md,
                  color: LumioColors.primary,
                  backgroundColor: LumioColors.surfaceSubtle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
