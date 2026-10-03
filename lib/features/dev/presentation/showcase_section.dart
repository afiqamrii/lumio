import 'package:flutter/material.dart';

import '../../../core/design_system.dart';

class ShowcaseSection extends StatelessWidget {
  const ShowcaseSection({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.child,
  });

  final String number;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(top: LumioSpacing.xxl),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: LumioSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ExcludeSemantics(child: LumioBadge(label: number)),
            Semantics(
              header: true,
              child: Text(title, style: LumioTypography.headingMedium),
            ),
          ],
        ),
        const SizedBox(height: LumioSpacing.sm),
        Text(
          description,
          style: LumioTypography.bodyMedium.copyWith(
            color: LumioColors.textSecondary,
          ),
        ),
        const SizedBox(height: LumioSpacing.lg),
        child,
      ],
    ),
  );
}

/// Natural-height tiles preserve large-text content rather than clipping it to
/// a fixed aspect ratio. Column count follows available width.
class ShowcaseGrid extends StatelessWidget {
  const ShowcaseGrid({
    super.key,
    required this.children,
    this.minTileWidth = 280,
    this.maxColumns = 3,
  });

  final List<Widget> children;
  final double minTileWidth;
  final int maxColumns;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns =
          ((constraints.maxWidth + LumioSpacing.md) /
                  (minTileWidth + LumioSpacing.md))
              .floor()
              .clamp(1, maxColumns);
      final width =
          (constraints.maxWidth - LumioSpacing.md * (columns - 1)) / columns;
      return Wrap(
        spacing: LumioSpacing.md,
        runSpacing: LumioSpacing.md,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}
