import 'package:flutter/material.dart';

import '../theme/lumio_colors.dart';
import '../theme/lumio_spacing.dart';

/// Visual container only. No profile, selection or image-fetching behavior.
class LumioAvatarFrame extends StatelessWidget {
  const LumioAvatarFrame({
    super.key,
    required this.child,
    required this.label,
    this.size = 88,
  }) : assert(size > 0);

  final Widget child;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: label,
    child: ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: LumioColors.surfaceSubtle,
            border: Border.all(color: LumioColors.primary, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(LumioSpacing.sm),
            child: ClipOval(child: child),
          ),
        ),
      ),
    ),
  );
}
