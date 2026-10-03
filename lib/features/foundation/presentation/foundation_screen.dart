import 'package:flutter/material.dart';

import '../../../core/theme/lumio_spacing.dart';
import '../../../core/widgets/lumio_logo.dart';
import '../../../core/widgets/lumio_scaffold.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Preserved Phase 0 shell, used when the development showcase is disabled.
class FoundationScreen extends StatelessWidget {
  const FoundationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return LumioScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LumioLogo(width: 320, semanticLabel: strings.appName),
          const SizedBox(height: LumioSpacing.lg),
          Text(
            strings.tagline,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LumioSpacing.xl),
          Semantics(
            header: true,
            child: Text(
              strings.foundationTitle,
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: LumioSpacing.md),
          Text(
            strings.foundationDescription,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LumioSpacing.xl),
        ],
      ),
    );
  }
}
