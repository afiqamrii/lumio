import 'package:flutter/material.dart';

/// All durations fall within guideline v2's explicit timing ranges.
abstract final class LumioMotion {
  static const fast = Duration(milliseconds: 100);
  static const standard = Duration(milliseconds: 260);
  static const transition = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 700);
  static const reward = Duration(milliseconds: 900);
  static const easing = Curves.easeOutCubic;
  static const pressScale = 0.97;
  static const pageScale = 0.985;
  static const pageSlide = Offset(0, 0.02);

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.accessibleNavigationOf(context);

  static Duration duration(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}
