import 'package:flutter/material.dart';

import '../constants/brand_assets.dart';

enum LumiPose { happy, curious, welcome, celebrating }

/// Static official reactions. No animation rig, recoloring, crop or logic.
class LumiMascot extends StatelessWidget {
  const LumiMascot({
    super.key,
    this.pose = LumiPose.happy,
    this.size = 160,
    this.semanticLabel = 'Lumi',
  }) : assert(size > 0);

  final LumiPose pose;
  final double size;
  final String semanticLabel;

  String get asset => switch (pose) {
    LumiPose.welcome => BrandAssets.lumiWelcome,
    LumiPose.celebrating => BrandAssets.lumiCelebrating,
    LumiPose.happy => BrandAssets.lumiHappy,
    LumiPose.curious => BrandAssets.lumiCurious,
  };

  @override
  Widget build(BuildContext context) => Image.asset(
    asset,
    width: size,
    height: size,
    fit: BoxFit.contain,
    semanticLabel: semanticLabel,
    matchTextDirection: false,
    cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).ceil(),
  );
}
