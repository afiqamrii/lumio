import 'package:flutter/material.dart';

import '../../../core/design_system.dart';
import '../../../l10n/generated/app_localizations.dart';

class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key, required this.onReturn});
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return LumioScaffold(
      child: LumioCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: LumiMascot(
                pose: LumiPose.curious,
                size: 140,
                semanticLabel: strings.mascotCurious,
              ),
            ),
            const SizedBox(height: LumioSpacing.lg),
            Semantics(
              header: true,
              child: Text(
                strings.routeLostTitle,
                style: LumioTypography.headingMedium,
              ),
            ),
            const SizedBox(height: LumioSpacing.md),
            Text(strings.pageNotFound, style: LumioTypography.bodyMedium),
            const SizedBox(height: LumioSpacing.lg),
            LumioButton(label: strings.returnToFoundation, onPressed: onReturn),
          ],
        ),
      ),
    );
  }
}
