import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Never registered in release/profile or production builds.
class DevelopmentEntryScreen extends StatelessWidget {
  const DevelopmentEntryScreen({super.key, required this.showDesignSystem});
  final bool showDesignSystem;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return LumioScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LumioLogo(width: 280),
          const SizedBox(height: LumioSpacing.lg),
          LumioBadge(
            label: strings.developmentPreview,
            tone: LumioBadgeTone.info,
          ),
          const SizedBox(height: LumioSpacing.lg),
          Semantics(
            header: true,
            child: Text(
              strings.developmentEntryTitle,
              style: LumioTypography.headingMedium,
            ),
          ),
          const SizedBox(height: LumioSpacing.md),
          Text(
            strings.developmentEntryDescription,
            style: LumioTypography.bodyMedium,
          ),
          const SizedBox(height: LumioSpacing.xl),
          LumioCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LumioButton(
                  label: strings.openParentMode,
                  icon: Icons.family_restroom_rounded,
                  onPressed: () => context.goNamed(AppRoutes.parentHome.name),
                ),
                const SizedBox(height: LumioSpacing.md),
                LumioButton(
                  label: strings.openChildMode,
                  icon: Icons.explore_outlined,
                  variant: LumioButtonVariant.secondary,
                  onPressed: () => context.goNamed(AppRoutes.selectChild.name),
                ),
              ],
            ),
          ),
          const SizedBox(height: LumioSpacing.lg),
          if (showDesignSystem) ...[
            LumioButton(
              label: strings.openDesignSystem,
              variant: LumioButtonVariant.outline,
              onPressed: () => unawaited(
                context.pushNamed<void>(AppRoutes.designSystem.name),
              ),
            ),
            const SizedBox(height: LumioSpacing.md),
          ],
          LumioButton(
            label: strings.learningContentBrowser,
            icon: Icons.menu_book_rounded,
            variant: LumioButtonVariant.outline,
            onPressed: () => unawaited(
              context.pushNamed<void>(AppRoutes.learningContent.name),
            ),
          ),
          const SizedBox(height: LumioSpacing.md),
          LumioButton(
            label: strings.previewRouteRecovery,
            variant: LumioButtonVariant.ghost,
            onPressed: () => context.goNamed(AppRoutes.lost.name),
          ),
          const SizedBox(height: LumioSpacing.xl),
        ],
      ),
    );
  }
}
