import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/adaptive_shell_frame.dart';
import '../../../core/widgets/lumio_scene.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../profiles/application/profile_store.dart';
import '../../profiles/presentation/profile_widgets.dart';

class ChildShell extends ConsumerWidget {
  const ChildShell({
    super.key,
    required this.childId,
    required this.section,
    required this.currentPath,
    required this.child,
    this.onExitPreview,
  });
  final String childId;
  final ChildSection section;
  final String currentPath;
  final Widget child;

  /// Exit to selector. A future coordinator must apply a parental gate
  /// before replacing child routes. This callback is not an authorization check.
  final VoidCallback? onExitPreview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeChildProvider(childId)).value;
    if (profile == null) return const SizedBox.shrink();
    return _buildShell(
      context,
      lookupAppLocalizations(Locale(profile.language)),
      profile.language,
    );
  }

  Widget _buildShell(
    BuildContext context,
    AppLocalizations strings,
    String language,
  ) {
    final worldLanding =
        currentPath.contains('/adventure/') &&
        !currentPath.endsWith('/adventure');
    final back = worldLanding
        ? () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(
                AppRoutes.childAdventure.name,
                pathParameters: AppRoutes.childParameters(childId),
              );
            }
          }
        : section != ChildSection.home
        ? () => context.goNamed(
            AppRoutes.childHome.name,
            pathParameters: AppRoutes.childParameters(childId),
          )
        : onExitPreview;
    return AdaptiveShellFrame(
      title: strings.childMode,
      navigationLabel: strings.childNavigation,
      playful: true,
      destinations: [
        for (final section in ChildSection.values)
          ShellDestination(
            id: section.route.name,
            label: section.label(strings),
            icon: section.icon,
          ),
      ],
      selectedIndex: section.index,
      onSelected: (index) => context.goNamed(
        ChildSection.values[index].route.name,
        pathParameters: AppRoutes.childParameters(childId),
      ),
      onBack: back,
      backLabel: worldLanding
          ? strings.backToAdventure
          : section == ChildSection.home
          ? strings.exitChildMode
          : strings.backToChildHome,
      child: Localizations.override(
        context: context,
        locale: Locale(language),
        child: child,
      ),
    );
  }
}

class ChildPlaceholderScreen extends ConsumerWidget {
  const ChildPlaceholderScreen({
    super.key,
    required this.section,
    required this.childId,
  });
  final String childId;
  final ChildSection section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final child = ref.watch(activeChildProvider(childId)).value;
    if (child == null) return const SizedBox.shrink();

    final home = section == ChildSection.home;
    return ResponsiveContent(
      maxWidth: 920,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        strings.greetChild(child.displayName),
                        style: LumioTypography.headingLarge,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ProfileAvatarView(avatar: child.avatar, size: 60),
            ],
          ),
          const SizedBox(height: 24),
          if (home) ...[
            _ChildWelcome(strings: strings, childId: childId),
            const SizedBox(height: 28),
            Text(
              strings.discoverDestination,
              style: LumioTypography.headingMedium,
            ),
            const SizedBox(height: 16),
            LumioTileGrid(
              minimumTileWidth: 140,
              children: [
                LumioInfoTile(
                  title: strings.worldsDestination,
                  description: strings.worldsIntro,
                  icon: Icons.explore_rounded,
                  color: LumioColors.mint,
                  onTap: () => context.goNamed(
                    AppRoutes.childWorlds.name,
                    pathParameters: AppRoutes.childParameters(childId),
                  ),
                ),
                LumioInfoTile(
                  title: strings.rewardsDestination,
                  description: strings.rewardsTeaser,
                  icon: Icons.auto_awesome_rounded,
                  color: LumioColors.butter,
                  onTap: () => context.goNamed(
                    AppRoutes.childRewards.name,
                    pathParameters: AppRoutes.childParameters(childId),
                  ),
                ),
              ],
            ),
          ] else if (section == ChildSection.worlds) ...[
            LumioSectionHeading(
              title: strings.worldsIntro,
              subtitle: strings.worldsPlaceholder,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: LumioBadge(label: strings.laterPhase),
            ),
            const SizedBox(height: 24),
            LumioTileGrid(
              minimumTileWidth: 140,
              children: [
                LumioInfoTile(
                  title: strings.numberWorld,
                  description: strings.numberWorldInfo,
                  icon: Icons.calculate_outlined,
                  color: LumioColors.lavender,
                ),
                LumioInfoTile(
                  title: strings.wordWorld,
                  description: strings.wordWorldInfo,
                  icon: Icons.auto_stories_outlined,
                  color: LumioColors.mint,
                ),
                LumioInfoTile(
                  title: strings.languageWorld,
                  description: strings.languageWorldInfo,
                  icon: Icons.holiday_village_outlined,
                  color: LumioColors.peach,
                ),
                LumioInfoTile(
                  title: strings.arabicWorld,
                  description: strings.arabicWorldInfo,
                  icon: Icons.nights_stay_outlined,
                  color: LumioColors.butter,
                ),
                LumioInfoTile(
                  title: strings.logicWorld,
                  description: strings.logicWorldInfo,
                  icon: Icons.extension_outlined,
                  color: LumioColors.sky,
                ),
                LumioInfoTile(
                  title: strings.discoveryWorld,
                  description: strings.discoveryWorldInfo,
                  icon: Icons.park_outlined,
                  color: LumioColors.mint,
                ),
              ],
            ),
          ] else ...[
            const LumiScene(
              height: 280,
              color: LumioColors.butter,
              pose: LumiPose.celebrating,
            ),
            const SizedBox(height: 24),
            LumioSectionHeading(
              title: strings.rewardsHeading,
              subtitle: strings.rewardsIntro,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: LumioBadge(label: strings.laterPhase),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChildWelcome extends StatelessWidget {
  const _ChildWelcome({required this.strings, required this.childId});
  final AppLocalizations strings;
  final String childId;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: Text(
          strings.childHomeTitle,
          style: LumioTypography.displayMedium,
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        strings.adventureSubtitle,
        style: LumioTypography.bodyMedium,
        textAlign: TextAlign.center,
      ),
      const LumiScene(height: 240),
      LumioCard(
        color: LumioColors.surface,
        radius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(strings.yourAdventure, style: LumioTypography.headingSmall),
            const SizedBox(height: 8),
            Text(
              strings.childHomePlaceholder,
              style: LumioTypography.bodySmall,
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      LumioButton(
        label: strings.exploreWorlds,
        icon: Icons.play_arrow_rounded,
        onPressed: () => context.goNamed(
          AppRoutes.childWorlds.name,
          pathParameters: AppRoutes.childParameters(childId),
        ),
      ),
    ],
  );
}

extension on ChildSection {
  String label(AppLocalizations strings) => switch (this) {
    ChildSection.home => strings.homeDestination,
    ChildSection.worlds => strings.adventureDestination,
    ChildSection.rewards => strings.rewardsDestination,
  };
  IconData get icon => switch (this) {
    ChildSection.home => Icons.home_rounded,
    ChildSection.worlds => Icons.map_rounded,
    ChildSection.rewards => Icons.auto_awesome_rounded,
  };
}
