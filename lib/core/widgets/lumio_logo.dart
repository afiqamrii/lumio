import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/brand_assets.dart';

enum LumioLogoVariant { primary, wordmark, compactReverse, colorWordmark }

/// Uses the original paths/colors, never recolors or mirrors the brand mark.
class LumioLogo extends StatelessWidget {
  const LumioLogo({
    super.key,
    this.variant = LumioLogoVariant.primary,
    this.width,
    this.semanticLabel = 'Lumio',
  }) : assert(width == null || width > 0);

  final LumioLogoVariant variant;
  final double? width;
  final String semanticLabel;

  String get asset => switch (variant) {
    LumioLogoVariant.colorWordmark => BrandAssets.wordmarkColor,
    LumioLogoVariant.primary => BrandAssets.primaryLogo,
    LumioLogoVariant.wordmark => BrandAssets.wordmarkLogo,
    LumioLogoVariant.compactReverse => BrandAssets.compactLogo,
  };

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: semanticLabel,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final preferred =
            width ??
            switch (variant) {
              LumioLogoVariant.colorWordmark => 140.0,
              LumioLogoVariant.primary => 240.0,
              LumioLogoVariant.wordmark => 140.0,
              LumioLogoVariant.compactReverse => 96.0,
            };
        // 6% on each edge exceeds 0.25 x o-height for all selected SVGs.
        final paintedWidth = constraints.hasBoundedWidth
            ? math.min(preferred, constraints.maxWidth / 1.12)
            : preferred;
        return Padding(
          padding: EdgeInsets.all(paintedWidth * 0.06),
          child: SvgPicture.asset(
            asset,
            width: paintedWidth,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
            matchTextDirection: false,
          ),
        );
      },
    ),
  );
}
