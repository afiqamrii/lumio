import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design_system.dart';

/// The original Lumi character on an airy, orbital discovery stage.
class LumiScene extends StatelessWidget {
  const LumiScene({
    super.key,
    this.height = 280,
    this.color = LumioColors.lavender,
    this.pose = LumiPose.welcome,
  });
  final double height;
  final Color color;
  final LumiPose pose;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CustomPaint(painter: _OrbitalStage(color))),
          Container(
            width: height * .82,
            height: height * .82,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  LumioColors.surface,
                  color.withValues(alpha: .35),
                  color.withValues(alpha: 0),
                ],
              ),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 26,
            top: height * .20,
            child: Transform.rotate(
              angle: -.18,
              child: _OrbitTile(
                icon: Icons.auto_awesome_rounded,
                color: LumioColors.primary,
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: height * .53,
            child: Transform.rotate(
              angle: .12,
              child: const _OrbitTile(
                icon: Icons.hub_outlined,
                color: LumioColors.primaryPressed,
              ),
            ),
          ),
          LumiMascot(size: height * .84, pose: pose),
        ],
      ),
    ),
  );
}

class _OrbitTile extends StatelessWidget {
  const _OrbitTile({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: LumioColors.surface.withValues(alpha: .9),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: LumioColors.outlineSubtle),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: .06),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Icon(icon, size: 22, color: color),
  );
}

class _OrbitalStage extends CustomPainter {
  const _OrbitalStage(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width * .42, size.height * .47);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: .7),
            LumioColors.aurora.withValues(alpha: .4),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = LumioColors.primary.withValues(alpha: .12);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-.3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: radius * 2.08,
        height: radius * 1.58,
      ),
      ring,
    );
    canvas.rotate(.7);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: radius * 2.2,
        height: radius * 1.56,
      ),
      ring,
    );
    canvas.restore();
    final dots = Paint()..color = LumioColors.primary.withValues(alpha: .2);
    for (var i = 0; i < 9; i++) {
      final angle = i * math.pi * 2 / 9;
      canvas.drawCircle(
        center +
            Offset(math.cos(angle) * radius, math.sin(angle) * radius * .85),
        i % 3 == 0 ? 3 : 1.5,
        dots,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitalStage oldDelegate) =>
      oldDelegate.color != color;
}

class LumioSectionHeading extends StatelessWidget {
  const LumioSectionHeading({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        header: true,
        child: Text(title, style: LumioTypography.headingLarge),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 8),
        Text(
          subtitle!,
          style: LumioTypography.bodyMedium.copyWith(
            color: LumioColors.textSecondary,
          ),
        ),
      ],
    ],
  );
}

/// Natural-height cards wrap to one column with large accessibility text.
class LumioTileGrid extends StatelessWidget {
  const LumioTileGrid({
    super.key,
    required this.children,
    this.minimumTileWidth = 240,
  });
  final List<Widget> children;
  final double minimumTileWidth;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final scaledMinimum =
          minimumTileWidth * MediaQuery.textScalerOf(context).scale(14) / 14;
      final columns = bounds.maxWidth >= scaledMinimum * 2 + 16 ? 2 : 1;
      final width = (bounds.maxWidth - (columns - 1) * 16) / columns;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}

class LumioInfoTile extends StatelessWidget {
  const LumioInfoTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.color = LumioColors.surface,
    this.onTap,
  });
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => LumioCard(
    color: color,
    padding: const EdgeInsets.all(20),
    semanticLabel: onTap == null ? null : title,
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LumioColors.surface.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 28, color: LumioColors.textPrimary),
            ),
            const Spacer(),
            if (onTap != null) const Icon(Icons.arrow_forward_rounded),
          ],
        ),
        const SizedBox(height: 16),
        Text(title, style: LumioTypography.headingSmall),
        const SizedBox(height: 8),
        Text(description, style: LumioTypography.bodySmall),
      ],
    ),
  );
}
