import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';

class ChildUnavailableScreen extends StatelessWidget {
  const ChildUnavailableScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return LumioScaffold(
      child: LumioCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LumiMascot(
              pose: LumiPose.curious,
              size: 120,
              semanticLabel: s.mascotCurious,
            ),
            const SizedBox(height: LumioSpacing.lg),
            Text(s.childMissingTitle, style: LumioTypography.headingMedium),
            const SizedBox(height: LumioSpacing.md),
            Text(s.childMissingInfo, style: LumioTypography.bodyMedium),
            const SizedBox(height: LumioSpacing.lg),
            LumioButton(
              label: s.selectChild,
              onPressed: () => context.goNamed(AppRoutes.selectChild.name),
            ),
          ],
        ),
      ),
    );
  }
}
