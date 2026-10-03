import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/design_system.dart';
import '../../../l10n/generated/app_localizations.dart';

/// A finite visual introduction, not network/session/onboarding initialization.
class BootstrapScreen extends StatefulWidget {
  const BootstrapScreen({super.key, required this.onReady});
  final VoidCallback onReady;

  @override
  State<BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends State<BootstrapScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  bool _active = true;
  bool _firstFrameShown = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _active = lifecycle == null || lifecycle == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _firstFrameShown = true;
      _schedule();
    });
  }

  void _schedule() {
    if (!_active || !_firstFrameShown || _completed || _timer != null) return;
    _timer = Timer(LumioMotion.slow, () {
      _timer = null;
      if (!mounted || !_active || _completed) return;
      _completed = true;
      widget.onReady();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    if (_active) {
      _schedule();
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return LumioScaffold(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: LumioMotion.duration(context, LumioMotion.standard),
        curve: LumioMotion.easing,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.scale(
            scale: LumioMotion.pageScale + value * (1 - LumioMotion.pageScale),
            child: child,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LumioLogo(width: 280, semanticLabel: strings.appName),
            const SizedBox(height: LumioSpacing.lg),
            Text(
              strings.tagline,
              style: LumioTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LumioSpacing.xl),
            LumiMascot(size: 140, semanticLabel: strings.mascotHappy),
          ],
        ),
      ),
    );
  }
}
