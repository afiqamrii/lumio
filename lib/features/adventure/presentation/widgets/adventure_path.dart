import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/design_system.dart';

class AdventurePath extends StatelessWidget {
  const AdventurePath({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = LumioMotion.reduced(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: reducedMotion ? Duration.zero : LumioMotion.slow,
      curve: LumioMotion.easing,
      child: child,
      builder: (context, value, child) => CustomPaint(
        painter: _AdventurePathPainter(progress: value),
        child: child,
      ),
    );
  }
}

class _AdventurePathPainter extends CustomPainter {
  const _AdventurePathPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(size.width * .31, 38);
    final spacing = size.height / 6;
    for (var index = 1; index < 6; index++) {
      final fromRight = index.isOdd;
      path.cubicTo(
        fromRight ? size.width * .72 : size.width * .28,
        spacing * (index - .65),
        fromRight ? size.width * .72 : size.width * .28,
        spacing * (index - .35),
        fromRight ? size.width * .69 : size.width * .31,
        spacing * index + 38,
      );
    }

    final metric = path.computeMetrics().first;
    final visible = metric.extractPath(0, metric.length * progress);
    canvas.drawPath(
      visible,
      Paint()
        ..color = LumioColors.lavender
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      visible,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(size.width, size.height),
          [LumioColors.primary, LumioColors.secondary],
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _AdventurePathPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
