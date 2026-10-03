import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../progression/application/progression_store.dart';
import '../../progression/domain/progression_models.dart';
import '../application/child_interaction_hook.dart';
import '../data/learning_world_catalog.dart';
import '../domain/learning_world.dart';
import 'widgets/adventure_path.dart';
import 'widgets/animated_lumi.dart';
import 'widgets/lumio_world_node.dart';

class AdventureMapScreen extends ConsumerWidget {
  const AdventureMapScreen({
    super.key,
    required this.childId,
    this.onInteraction = noChildInteraction,
  });

  final String childId;
  final ChildInteractionHook onInteraction;

  void _selectWorld(
    BuildContext context,
    LearningWorld world,
    ProgressionSnapshot snapshot,
  ) {
    onInteraction(ChildInteractionEvent.worldTapped, world.id);
    if (!world.canEnter(snapshot)) {
      onInteraction(ChildInteractionEvent.lockedWorldTapped, world.id);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                const Icon(Icons.lock_rounded, color: LumioColors.surface),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(AppLocalizations.of(context).lockedWorldMessage),
                ),
              ],
            ),
          ),
        );
      return;
    }
    onInteraction(ChildInteractionEvent.worldEntered, world.id);
    context.pushNamed(
      AppRoutes.worldLanding.name,
      pathParameters: {
        ...AppRoutes.childParameters(childId),
        AppRoutes.worldIdParameter: world.id,
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final progression = ref.watch(childProgressProvider(childId));
    final snapshot = progression.value;
    if (snapshot == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ResponsiveContent(
      maxWidth: 820,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 104, child: AnimatedLumi(size: 104)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.adventureMapTitle,
                      style: LumioTypography.headingLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.adventureMapIntro,
                      style: LumioTypography.bodyMedium.copyWith(
                        color: LumioColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Semantics(
            container: true,
            label: strings.adventureMapSemantics,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textScale =
                    MediaQuery.textScalerOf(context).scale(14) / 14;
                final itemExtent = textScale > 1.4 ? 560.0 : 250.0;
                final compact = constraints.maxWidth < 520;
                return SizedBox(
                  height: itemExtent * LearningWorldCatalog.worlds.length,
                  child: AdventurePath(
                    child: Stack(
                      children: [
                        const Positioned(
                          top: 70,
                          left: 12,
                          child: _MapCloud(size: 54),
                        ),
                        const Positioned(
                          top: 420,
                          right: 8,
                          child: _MapCloud(size: 68),
                        ),
                        Column(
                          children: [
                            for (final world in LearningWorldCatalog.worlds)
                              SizedBox(
                                height: itemExtent,
                                child: Align(
                                  alignment: compact
                                      ? switch (world.sortOrder % 3) {
                                          0 => Alignment.centerLeft,
                                          1 => Alignment.centerRight,
                                          _ => Alignment.center,
                                        }
                                      : world.sortOrder.isEven
                                      ? const Alignment(-.62, 0)
                                      : const Alignment(.62, 0),
                                  child: LumioWorldNode(
                                    key: ValueKey('world-${world.id}'),
                                    world: world,
                                    unlocked: world.canEnter(snapshot),
                                    progress: snapshot.world(world.id),
                                    onPressed: () =>
                                        _selectWorld(context, world, snapshot),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          LumioCard(
            color: LumioColors.lavender,
            radius: BorderRadius.circular(22),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    strings.phaseFiveAccessNote,
                    style: LumioTypography.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapCloud extends StatelessWidget {
  const _MapCloud({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Icon(Icons.cloud_rounded, size: size, color: LumioColors.cloud),
  );
}
