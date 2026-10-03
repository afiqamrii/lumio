import 'package:flutter/material.dart';

import '../theme/lumio_colors.dart';
import '../theme/lumio_motion.dart';
import '../theme/lumio_radius.dart';
import '../theme/lumio_spacing.dart';

/// Internal interaction primitive. The InkWell/semantics target never scales;
/// only its painted child compresses. Keyboard and assistive activation agree.
class LumioActionSurface extends StatefulWidget {
  const LumioActionSurface({
    super.key,
    required this.label,
    required this.child,
    required this.background,
    required this.foreground,
    this.onTap,
    this.borderColor = LumioColors.transparent,
    this.borderWidth = 2,
    this.gradient,
    this.boxShadow,
    this.padding = const EdgeInsetsDirectional.symmetric(
      horizontal: LumioSpacing.lg,
      vertical: LumioSpacing.md,
    ),
    this.semanticValue,
    this.selected,
    this.liveRegion = false,
    this.excludeChildSemantics = true,
    this.radius = LumioRadius.button,
  });

  final String label;
  final Widget child;
  final Color background;
  final Color foreground;
  final Color borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final String? semanticValue;
  final bool? selected;
  final bool liveRegion;
  final bool excludeChildSemantics;
  final BorderRadius radius;

  @override
  State<LumioActionSurface> createState() => _LumioActionSurfaceState();
}

class _LumioActionSurfaceState extends State<LumioActionSurface> {
  bool _pressed = false;
  bool _focused = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final pressed = enabled && _pressed;
    final duration = LumioMotion.duration(context, LumioMotion.fast);
    final border = enabled && _focused
        ? LumioColors.focusRing
        : widget.borderColor;
    final color = pressed && widget.background == LumioColors.primary
        ? LumioColors.primaryPressed
        : pressed && widget.background == LumioColors.action
        ? LumioColors.actionPressed
        : widget.background;
    final painted = AnimatedScale(
      scale: pressed && !LumioMotion.reduced(context)
          ? LumioMotion.pressScale
          : 1,
      duration: duration,
      curve: LumioMotion.easing,
      child: AnimatedContainer(
        duration: duration,
        curve: LumioMotion.easing,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: color,
          gradient: pressed ? null : widget.gradient,
          boxShadow: pressed ? null : widget.boxShadow,
          borderRadius: widget.radius,
          // A constant stroke width prevents focus from changing layout.
          border: Border.all(
            color: enabled && _hovered && border == LumioColors.transparent
                ? LumioColors.primary
                : border,
            width: widget.borderWidth,
          ),
        ),
        child: IconTheme(
          data: IconThemeData(color: widget.foreground, size: LumioSpacing.lg),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: widget.foreground),
            child: widget.excludeChildSemantics
                ? ExcludeSemantics(child: widget.child)
                : widget.child,
          ),
        ),
      ),
    );
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      value: widget.semanticValue,
      selected: widget.selected,
      liveRegion: widget.liveRegion,
      onTap: widget.onTap,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          canRequestFocus: enabled,
          excludeFromSemantics: true,
          onHighlightChanged: (value) => setState(() => _pressed = value),
          onFocusChange: (value) => setState(() => _focused = value),
          onHover: (value) => setState(() => _hovered = value),
          customBorder: RoundedRectangleBorder(borderRadius: widget.radius),
          splashFactory: NoSplash.splashFactory,
          highlightColor: LumioColors.transparent,
          hoverColor: LumioColors.transparent,
          focusColor: LumioColors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: LumioSpacing.childTouchTarget,
              minWidth: LumioSpacing.childTouchTarget,
            ),
            child: painted,
          ),
        ),
      ),
    );
  }
}
