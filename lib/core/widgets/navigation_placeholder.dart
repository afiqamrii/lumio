import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../design_system.dart';
import 'lumio_scene.dart';
import 'responsive_content.dart';

/// Empty-state presentation: never fabricates learning records or rewards.
class NavigationPlaceholder extends StatelessWidget {
  const NavigationPlaceholder({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.playful = false,
  });
  final String title;
  final String description;
  final IconData icon;
  final bool playful;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return ResponsiveContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LumioSectionHeading(title: title),
          const SizedBox(height: 24),
          LumioCard(
            color: LumioColors.mint,
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LumiScene(
                  height: 220,
                  color: LumioColors.mint,
                  pose: LumiPose.curious,
                ),
                const SizedBox(height: 24),
                Text(
                  s.parentProgressTitle,
                  style: LumioTypography.headingMedium,
                ),
                const SizedBox(height: 12),
                Text(description, style: LumioTypography.bodyMedium),
                const SizedBox(height: 20),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: LumioBadge(label: s.laterPhase),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
