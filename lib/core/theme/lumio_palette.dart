import 'package:flutter/material.dart';

/// Exact sRGB values from brand/05-colors/lumio-colors.json.
abstract final class LumioPalette {
  // Quiet UI surfaces; original brand colours remain intact.
  static const ink = Color(0xFF292A2E);
  static const inkPressed = Color(0xFF44454C);
  static const controlLine = Color(0xFFD8D9DF);
  static const playCream = Color(0xFFFFFCF2);
  static const cloudBlue = Color(0xFFBDEEF7);
  static const cloudMist = Color(0xFFE2F7FB);
  static const canvas = Color(0xFFF8F9F7);
  static const softLavender = Color(0xFFE5DDFC);
  static const softMint = Color(0xFFDDF2E9);
  static const softPeach = Color(0xFFFBE3DA);
  static const softSky = Color(0xFFDFECFA);
  static const violet = Color(0xFF7651D6);
  static const gold = Color(0xFFFFD34E);
  static const turquoise = Color(0xFF20C8C4);
  static const lilac = Color(0xFFB8A0F2);
  static const aqua = Color(0xFF65E1D6);
  static const coral = Color(0xFFF47B7F);
  static const leaf = Color(0xFF43C59E);
  static const plum = Color(0xFF38234F);
  static const cream = Color(0xFFFFF4D9);
  static const white = Color(0xFFFFFFFF);
  static const mist = Color(0xFFF4F0FC);
  static const slate = Color(0xFF6A6275);
  static const violetPressed = Color(0xFF5F3DB3);
  static const successInk = Color(0xFF216E53);
  static const attentionInk = Color(0xFF8A5700);
  static const errorInk = Color(0xFFA53345);
  static const values = <String, Color>{
    'violet': violet,
    'gold': gold,
    'turquoise': turquoise,
    'lilac': lilac,
    'aqua': aqua,
    'coral': coral,
    'leaf': leaf,
    'plum': plum,
    'cream': cream,
    'white': white,
    'mist': mist,
    'slate': slate,
    'violet-pressed': violetPressed,
    'success-ink': successInk,
    'attention-ink': attentionInk,
    'error-ink': errorInk,
  };
}
