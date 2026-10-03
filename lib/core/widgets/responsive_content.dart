import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/lumio_spacing.dart';

enum LayoutSize { compact, medium, expanded }

abstract final class LayoutBreakpoints {
  static const medium = 600.0;
  static const expanded = 840.0;

  static LayoutSize sizeFor(double width) {
    if (width < medium) return LayoutSize.compact;
    if (width < expanded) return LayoutSize.medium;
    return LayoutSize.expanded;
  }
}

/// A bounded reading surface that scrolls at large text scales or low heights.
/// Based on available constraints, not device names or forced orientations.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = maxContentWidth,
  });

  final Widget child;
  final double maxWidth;
  static const maxContentWidth = 720.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gutter =
              LayoutBreakpoints.sizeFor(constraints.maxWidth) ==
                  LayoutSize.compact
              ? LumioSpacing.lg
              : LumioSpacing.lg + LumioSpacing.md;
          return SingleChildScrollView(
            // Shell destinations must not inherit one shared primary scroll
            // position when a child switches between Home, Adventure and
            // Rewards.
            primary: false,
            padding: EdgeInsetsDirectional.all(gutter),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: math.max(0, constraints.maxHeight - gutter * 2),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
