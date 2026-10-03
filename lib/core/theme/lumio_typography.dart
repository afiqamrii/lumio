import 'package:flutter/material.dart';

import 'lumio_colors.dart';

/// Sizes/line heights begin with guideline v2; extended roles are UI decisions.
/// Explicit variable-font axes prevent accidental synthetic display weights.
abstract final class LumioTypography {
  static const fallback = ['NotoSansArabic'];

  static TextStyle _display(double size, double lineHeight, double weight) =>
      TextStyle(
        fontFamily: 'Sora',
        fontFamilyFallback: fallback,
        fontSize: size,
        height: lineHeight / size,
        letterSpacing: size >= 28 ? -1.1 : -.4,
        fontWeight: weight >= 700 ? FontWeight.w700 : FontWeight.w600,
        fontVariations: [FontVariation('wght', weight)],
        color: LumioColors.textPrimary,
      );

  static TextStyle _body(double size, double lineHeight, double weight) =>
      TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontFamilyFallback: fallback,
        fontSize: size,
        height: lineHeight / size,
        fontWeight: switch (weight) {
          600 => FontWeight.w600,
          500 => FontWeight.w500,
          _ => FontWeight.w400,
        },
        fontVariations: [FontVariation('wght', weight)],
        color: LumioColors.textPrimary,
      );

  static final displayLarge = _display(38, 48, 600);
  static final displayMedium = _display(28, 36, 600);
  static final headingLarge = _display(28, 36, 600);
  static final headingMedium = _display(22, 30, 600);
  static final headingSmall = _display(18, 26, 600);
  static final bodyLarge = _body(20, 30, 400);
  static final bodyMedium = _body(16, 24, 400);
  static final bodySmall = _body(14, 20, 400);
  static final actionLabel = _body(16, 24, 600);
  static final labelLarge = _body(18, 26, 600);
  static final labelMedium = _body(14, 20, 500);
  static final numberLarge = _body(
    48,
    56,
    600,
  ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
  static const arabicBody = TextStyle(
    fontFamily: 'NotoSansArabic',
    fontSize: 22,
    height: 36 / 22,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
    color: LumioColors.textPrimary,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: headingLarge,
    headlineLarge: headingLarge,
    headlineMedium: headingMedium,
    headlineSmall: headingSmall,
    titleLarge: headingSmall,
    titleMedium: labelLarge,
    titleSmall: labelMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelMedium,
  );
}
