import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/lumio_motion.dart';

enum LumioRouteMotion { public, parent, child }

/// Native Flutter transitions, sharing Phase 1 timing and reduced-motion policy.
CustomTransitionPage<void> lumioRoutePage({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  LumioRouteMotion motion = LumioRouteMotion.public,
}) => CustomTransitionPage<void>(
  key: state.pageKey,
  name: state.name,
  transitionDuration: LumioMotion.duration(context, LumioMotion.transition),
  reverseTransitionDuration: LumioMotion.duration(
    context,
    LumioMotion.transition,
  ),
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    if (LumioMotion.reduced(context)) return child;
    final eased = animation.drive(CurveTween(curve: LumioMotion.easing));
    final faded = FadeTransition(opacity: eased, child: child);
    return switch (motion) {
      LumioRouteMotion.public => faded,
      LumioRouteMotion.parent => SlideTransition(
        position: Tween<Offset>(
          begin: LumioMotion.pageSlide,
          end: Offset.zero,
        ).animate(eased),
        child: faded,
      ),
      LumioRouteMotion.child => ScaleTransition(
        scale: Tween<double>(
          begin: LumioMotion.pageScale,
          end: 1,
        ).animate(eased),
        child: faded,
      ),
    };
  },
);
