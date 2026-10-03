import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/lumio_colors.dart';
import '../theme/lumio_motion.dart';
import '../theme/lumio_radius.dart';
import '../theme/lumio_typography.dart';
import 'lumio_action_surface.dart';

enum LumioButtonVariant { primary, secondary, outline, ghost }

/// Quiet, dimensional controls with a clear primary-action hierarchy.
class LumioButton extends StatelessWidget {
  const LumioButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = LumioButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.loadingLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final LumioButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final primary = variant == LumioButtonVariant.primary;
    final foreground = disabled
        ? LumioColors.onDisabled
        : primary
        ? LumioColors.onPrimary
        : LumioColors.textPrimary;
    final background = disabled
        ? LumioColors.disabled
        : switch (variant) {
            LumioButtonVariant.primary => LumioColors.action,
            LumioButtonVariant.secondary => LumioColors.surface,
            _ => LumioColors.transparent,
          };
    final border =
        variant == LumioButtonVariant.outline ||
        variant == LumioButtonVariant.secondary;
    return LumioActionSurface(
      label: label,
      semanticValue: isLoading
          ? loadingLabel ?? AppLocalizations.of(context).loadingStatus
          : null,
      liveRegion: isLoading,
      onTap: disabled || isLoading ? null : onPressed,
      background: background,
      foreground: foreground,
      radius: BorderRadius.circular(LumioRadius.medium),
      gradient: primary && !disabled
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [LumioColors.primary, LumioColors.primaryPressed],
            )
          : null,
      boxShadow: primary && !disabled
          ? [
              BoxShadow(
                color: LumioColors.primary.withValues(alpha: .20),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ]
          : null,
      borderWidth: 1,
      borderColor: border
          ? LumioColors.controlOutline
          : LumioColors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading || icon != null) ...[
            if (isLoading)
              SizedBox.square(
                dimension: 24,
                child: LumioMotion.reduced(context)
                    ? const Icon(Icons.hourglass_top_rounded, size: 24)
                    : CircularProgressIndicator(
                        strokeWidth: 2,
                        color: foreground,
                      ),
              )
            else
              Icon(icon, size: 26),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              label,
              style: LumioTypography.actionLabel.copyWith(color: foreground),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
