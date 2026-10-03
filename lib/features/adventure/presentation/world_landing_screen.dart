import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../progression/application/progression_store.dart';
import '../application/child_interaction_hook.dart';
import '../data/learning_world_catalog.dart';
import 'widgets/animated_lumi.dart';
import 'world_presentation.dart';

class WorldLandingScreen extends ConsumerWidget {
  const WorldLandingScreen({
    super.key,
    required this.childId,
    required this.worldId,
    this.onInteraction = noChildInteraction,
  });

  final String childId;
  final String worldId;
  final ChildInteractionHook onInteraction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final world = LearningWorldCatalog.byId(worldId);
    if (world == null) {
      return ResponsiveContent(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.explore_off_rounded,
              size: 72,
              color: LumioColors.primary,
            ),
            const SizedBox(height: 20),
            Text(
              strings.worldNotFound,
              textAlign: TextAlign.center,
              style: LumioTypography.headingLarge,
            ),
            const SizedBox(height: 20),
            LumioButton(
              label: strings.backToAdventure,
              onPressed: () => context.goNamed(
                AppRoutes.childAdventure.name,
                pathParameters: AppRoutes.childParameters(childId),
              ),
            ),
          ],
        ),
      );
    }

    final progression = ref.watch(childProgressProvider(childId)).value;
    if (progression == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!world.canEnter(progression)) {
      return ResponsiveContent(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_rounded, size: 72, color: world.accent),
            const SizedBox(height: 20),
            Text(
              strings.lockedWorldMessage,
              textAlign: TextAlign.center,
              style: LumioTypography.headingMedium,
            ),
            const SizedBox(height: 20),
            LumioButton(
              label: strings.backToAdventure,
              onPressed: () => context.goNamed(
                AppRoutes.childAdventure.name,
                pathParameters: AppRoutes.childParameters(childId),
              ),
            ),
          ],
        ),
      );
    }

    return ResponsiveContent(
      maxWidth: 900,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 700;
          final identity = _WorldIdentity(
            icon: world.icon,
            color: world.color,
            accent: world.accent,
          );
          final copy = _WorldLandingCopy(
            title: world.title(strings),
            subject: world.subject(strings),
            description: world.description(strings),
            onStart: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(strings.gamesComingMessage),
                  ),
                );
            },
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: identity),
                const SizedBox(width: 36),
                Expanded(child: copy),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [identity, const SizedBox(height: 22), copy],
          );
        },
      ),
    );
  }
}

class _WorldIdentity extends StatelessWidget {
  const _WorldIdentity({
    required this.icon,
    required this.color,
    required this.accent,
  });

  final IconData icon;
  final Color color;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 310),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(36),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 24,
          right: 24,
          child: Icon(Icons.auto_awesome_rounded, color: accent, size: 30),
        ),
        Positioned(
          bottom: 8,
          left: 6,
          child: Icon(
            Icons.cloud_rounded,
            color: LumioColors.surface,
            size: 92,
          ),
        ),
        const Positioned(bottom: 12, right: 10, child: AnimatedLumi(size: 142)),
        Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            color: LumioColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 4),
          ),
          child: Icon(icon, size: 68, color: accent),
        ),
      ],
    ),
  );
}

class _WorldLandingCopy extends StatelessWidget {
  const _WorldLandingCopy({
    required this.title,
    required this.subject,
    required this.description,
    required this.onStart,
  });

  final String title;
  final String subject;
  final String description;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: LumioBadge(label: subject),
        ),
        const SizedBox(height: 14),
        Text(title, style: LumioTypography.displayMedium),
        const SizedBox(height: 12),
        Text(description, style: LumioTypography.bodyLarge),
        const SizedBox(height: 24),
        LumioButton(
          label: strings.startAdventure,
          icon: Icons.play_arrow_rounded,
          onPressed: onStart,
        ),
        const SizedBox(height: 10),
        Text(
          strings.phaseFiveGameNote,
          textAlign: TextAlign.center,
          style: LumioTypography.bodySmall.copyWith(
            color: LumioColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
