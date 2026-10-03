import 'package:flutter/material.dart';

import 'lumio_colors.dart';
import 'lumio_spacing.dart';

/// Restrained UI elevation derived from Ink Plum; no new palette colors.
abstract final class LumioShadows {
  static final List<BoxShadow> card = List.unmodifiable([
    BoxShadow(
      color: LumioColors.textPrimary.withValues(alpha: 0.06),
      blurRadius: LumioSpacing.md,
      offset: const Offset(0, LumioSpacing.xs),
    ),
  ]);
  static final List<BoxShadow> floating = List.unmodifiable([
    BoxShadow(
      color: LumioColors.textPrimary.withValues(alpha: 0.05),
      blurRadius: LumioSpacing.lg,
      offset: const Offset(0, LumioSpacing.sm),
    ),
  ]);
}
