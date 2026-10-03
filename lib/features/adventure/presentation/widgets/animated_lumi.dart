import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

class AnimatedLumi extends StatefulWidget {
  const AnimatedLumi({
    super.key,
    this.size = 190,
    this.pose = LumiPose.welcome,
  });

  final double size;
  final LumiPose pose;

  @override
  State<AnimatedLumi> createState() => _AnimatedLumiState();
}

class _AnimatedLumiState extends State<AnimatedLumi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: LumioMotion.slow)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (LumioMotion.reduced(context)) {
      return LumiMascot(size: widget.size, pose: widget.pose);
    }
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        child: LumiMascot(size: widget.size, pose: widget.pose),
        builder: (context, child) {
          final curve = Curves.easeInOut.transform(_controller.value);
          return Transform.translate(
            offset: Offset(0, -3 + curve * 6),
            child: child,
          );
        },
      ),
    );
  }
}
