import 'package:flutter/material.dart';

import '../theme/lumio_colors.dart';
import 'responsive_content.dart';

class LumioScaffold extends StatelessWidget {
  const LumioScaffold({
    super.key,
    required this.child,
    this.maxContentWidth = ResponsiveContent.maxContentWidth,
  });

  final Widget child;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: LumioColors.background,
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, .4, 1],
          colors: [
            LumioColors.primaryContainer,
            LumioColors.background,
            LumioColors.background,
          ],
        ),
      ),
      child: ResponsiveContent(maxWidth: maxContentWidth, child: child),
    ),
  );
}
