import 'package:flutter/material.dart';

import 'lumio_palette.dart';

/// Interface colors are independent of the preserved original brand palette.
abstract final class LumioColors {
  static const primary = Color(0xFF5653D9);
  static const onPrimary = LumioPalette.white;
  static const primaryContainer = Color(0xFFEEEDFF);
  static const primaryPressed = Color(0xFF3C39AD);
  static const secondary = LumioPalette.turquoise;
  static const onSecondary = LumioPalette.plum;
  static const secondaryContainer = LumioPalette.aqua;
  static const accent = LumioPalette.gold;
  static const glow = LumioPalette.gold;
  static const onGlow = LumioPalette.plum;
  static const surface = LumioPalette.white;
  static const surfaceElevated = LumioPalette.white;
  static const surfaceSubtle = Color(0xFFF0F2F8);
  static const background = Color(0xFFF7F8FC);
  static const lavender = Color(0xFFEEEDFD);
  static const mint = Color(0xFFE4F5EF);
  static const peach = Color(0xFFFBECE6);
  static const butter = LumioPalette.cream;
  static const sky = Color(0xFFE9F2FF);
  static const cloud = LumioPalette.cloudBlue;
  static const cloudSoft = LumioPalette.cloudMist;
  static const navigation = LumioPalette.white;
  static const action = primary;
  static const actionPressed = primaryPressed;
  static const controlOutline = Color(0xFFCDD1E4);
  static const success = LumioPalette.successInk;
  static const warning = LumioPalette.attentionInk;
  static const error = LumioPalette.errorInk;
  static const info = LumioPalette.plum;
  static const infoContainer = LumioPalette.turquoise;
  static const textPrimary = Color(0xFF20253D);
  static const textSecondary = Color(0xFF646B80);
  static const textMuted = textSecondary;
  static const outline = Color(0xFF777F98);
  static const outlineSubtle = Color(0xFFE5E8F1);
  static const disabled = surfaceSubtle;
  static const onDisabled = textSecondary;
  static const focusRing = primaryPressed;
  static const midnight = Color(0xFF20233F);
  static const aurora = Color(0xFFDDF6F5);
  static const transparent = Colors.transparent;
}
