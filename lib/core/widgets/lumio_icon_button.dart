import 'package:flutter/material.dart';

import '../theme/lumio_colors.dart';
import '../theme/lumio_spacing.dart';
import 'lumio_action_surface.dart';

class LumioIconButton extends StatelessWidget {
  const LumioIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    excludeFromSemantics: true,
    child: LumioActionSurface(
      label: label,
      onTap: onPressed,
      background: LumioColors.surface,
      radius: BorderRadius.circular(999),
      foreground: onPressed == null
          ? LumioColors.onDisabled
          : LumioColors.textPrimary,
      padding: const EdgeInsetsDirectional.all(LumioSpacing.md),
      child: Icon(icon),
    ),
  );
}
