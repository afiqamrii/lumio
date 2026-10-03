import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/design_system.dart';
import '../../../core/widgets/lumio_scene.dart';
import '../../../core/widgets/responsive_content.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../adventure/data/learning_world_catalog.dart';
import '../../adventure/presentation/world_presentation.dart';
import '../../progression/application/progression_store.dart';
import '../../progression/application/reward_interaction_hook.dart';
import '../../progression/domain/progression_models.dart';
import '../../progression/presentation/reward_presentation.dart';

class ChildRewardsScreen extends ConsumerWidget {
  const ChildRewardsScreen({
    super.key,
    required this.childId,
    required this.debugTools,
    this.onRewardInteraction = noRewardInteraction,
  });

  final String childId;
  final bool debugTools;
  final RewardInteractionHook onRewardInteraction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(childProgressProvider(childId));
    return ResponsiveContent(
      maxWidth: 900,
      child: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _RewardsError(
          onRetry: () => ref.invalidate(childProgressProvider(childId)),
        ),
        data: (snapshot) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RewardsHero(progress: snapshot.progress),
            const SizedBox(height: 22),
            _RewardTotals(progress: snapshot.progress),
            const SizedBox(height: 22),
            Text(
              AppLocalizations.of(context).achievementsTitle,
              style: LumioTypography.headingMedium,
            ),
            const SizedBox(height: 12),
            _Achievements(achievements: snapshot.achievements),
            if (debugTools) ...[
              const SizedBox(height: 28),
              DebugProgressionSimulator(
                childId: childId,
                onRewardInteraction: onRewardInteraction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({required this.progress});
  final ChildProgress progress;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return LumioCard(
      color: LumioColors.lavender,
      radius: BorderRadius.circular(32),
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: LumioBadge(label: strings.levelValue(progress.level)),
              ),
              const SizedBox(height: 12),
              Text(strings.rewardsHeading, style: LumioTypography.headingLarge),
              const SizedBox(height: 6),
              Text(strings.rewardsPhaseFiveIntro),
              const SizedBox(height: 18),
              LumioProgressBar(
                value: progress.levelProgress,
                label: strings.xpToNextLevel(
                  progress.xpWithinLevel,
                  progress.xpForNextLevel,
                ),
              ),
            ],
          );
          if (constraints.maxWidth >= 620) {
            return Row(
              children: [
                const SizedBox(
                  width: 230,
                  child: LumiScene(
                    height: 220,
                    color: LumioColors.transparent,
                    pose: LumiPose.celebrating,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(child: copy),
              ],
            );
          }
          return Column(
            children: [
              const LumiScene(
                height: 210,
                color: LumioColors.transparent,
                pose: LumiPose.celebrating,
              ),
              copy,
            ],
          );
        },
      ),
    );
  }
}

class _RewardTotals extends StatelessWidget {
  const _RewardTotals({required this.progress});
  final ChildProgress progress;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _RewardTotal(
            icon: Icons.star_rounded,
            color: LumioColors.warning,
            value: progress.stars,
            label: strings.starsLabel,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RewardTotal(
            icon: Icons.monetization_on_rounded,
            color: LumioColors.primary,
            value: progress.coins,
            label: strings.coinsLabel,
          ),
        ),
      ],
    );
  }
}

class _RewardTotal extends StatelessWidget {
  const _RewardTotal({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value',
    child: ExcludeSemantics(
      child: LumioCard(
        child: Column(
          children: [
            Icon(icon, color: color, size: 34),
            const SizedBox(height: 6),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value.toDouble()),
              duration: LumioMotion.duration(context, LumioMotion.reward),
              builder: (_, animated, _) => Text(
                animated.round().toString(),
                style: LumioTypography.headingLarge,
              ),
            ),
            Text(label, style: LumioTypography.labelMedium),
          ],
        ),
      ),
    ),
  );
}

class _Achievements extends StatelessWidget {
  const _Achievements({required this.achievements});
  final List<ChildAchievement> achievements;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    if (achievements.isEmpty) {
      return LumioCard(
        color: LumioColors.mint,
        child: Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 34),
            const SizedBox(width: 14),
            Expanded(child: Text(strings.noAchievementsYet)),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (final achievement in achievements)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Semantics(
              label: strings.earnedAchievement(
                achievement.achievementId.title(strings),
              ),
              child: LumioCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: LumioColors.butter,
                      child: Icon(achievement.achievementId.icon),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.achievementId.title(strings),
                            style: LumioTypography.headingSmall,
                          ),
                          Text(
                            achievement.achievementId.description(strings),
                            style: LumioTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.check_circle_rounded,
                      color: LumioColors.success,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class DebugProgressionSimulator extends ConsumerStatefulWidget {
  const DebugProgressionSimulator({
    super.key,
    required this.childId,
    this.onRewardInteraction = noRewardInteraction,
  });
  final String childId;
  final RewardInteractionHook onRewardInteraction;

  @override
  ConsumerState<DebugProgressionSimulator> createState() =>
      _DebugProgressionSimulatorState();
}

class _DebugProgressionSimulatorState
    extends ConsumerState<DebugProgressionSimulator> {
  static const _uuid = Uuid();
  String _worldId = LearningWorldCatalog.worlds.first.id;
  int _stars = 1;
  bool _busy = false;
  String? _lastEventId;
  ProgressionResult? _result;

  Future<void> _complete({bool duplicate = false}) async {
    if (_busy) return;
    setState(() => _busy = true);
    final eventId = duplicate && _lastEventId != null
        ? _lastEventId!
        : _uuid.v4();
    try {
      final result = await ref
          .read(progressionControllerProvider)
          .completeMission(
            MissionCompletion(
              eventId: eventId,
              childId: widget.childId,
              missionId: 'debug_${_worldId.replaceAll('-', '_')}_001',
              worldId: _worldId,
              starsEarned: _stars,
              score: _stars * 30,
              completedAt: DateTime.now().toUtc(),
            ),
          );
      if (!duplicate) _lastEventId = eventId;
      widget.onRewardInteraction(
        RewardInteractionEvent.starEarned,
        result.newStarsAdded,
      );
      if (result.coinsAwarded > 0) {
        widget.onRewardInteraction(
          RewardInteractionEvent.coinEarned,
          result.coinsAwarded,
        );
      }
      if (result.xpAwarded > 0) {
        widget.onRewardInteraction(
          RewardInteractionEvent.xpProgress,
          result.xpAwarded,
        );
      }
      if (!mounted) return;
      setState(() => _result = result);
      if (result.levelUp || result.newlyUnlockedAchievements.isNotEmpty) {
        if (result.levelUp) {
          widget.onRewardInteraction(
            RewardInteractionEvent.levelUp,
            result.newLevel,
          );
        }
        if (result.newlyUnlockedAchievements.isNotEmpty) {
          widget.onRewardInteraction(
            RewardInteractionEvent.achievementUnlocked,
            result.newlyUnlockedAchievements.length,
          );
        }
        await showDialog<void>(
          context: context,
          builder: (_) => _RewardCelebrationDialog(result: result),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return LumioCard(
      color: LumioColors.surfaceSubtle,
      radius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.science_rounded, color: LumioColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.debugProgressionSimulator,
                      style: LumioTypography.headingSmall,
                    ),
                    const SizedBox(height: 6),
                    LumioBadge(label: strings.debugOnly),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _worldId,
            isExpanded: true,
            decoration: InputDecoration(labelText: strings.worldLabel),
            items: [
              for (final world in LearningWorldCatalog.worlds)
                DropdownMenuItem(
                  value: world.id,
                  child: Text(
                    world.title(strings),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() => _worldId = value ?? _worldId),
          ),
          const SizedBox(height: 14),
          Text(strings.starsEarnedLabel, style: LumioTypography.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (var value = 1; value <= 3; value++)
                ChoiceChip(
                  label: Text('$value ★'),
                  selected: _stars == value,
                  onSelected: _busy
                      ? null
                      : (_) => setState(() => _stars = value),
                ),
            ],
          ),
          const SizedBox(height: 16),
          LumioButton(
            label: strings.completeDebugMission,
            icon: Icons.play_arrow_rounded,
            onPressed: _busy ? null : _complete,
          ),
          if (_lastEventId != null) ...[
            const SizedBox(height: 8),
            LumioButton(
              label: strings.retrySameEvent,
              variant: LumioButtonVariant.outline,
              onPressed: _busy ? null : () => _complete(duplicate: true),
            ),
          ],
          if (_result case final result?) ...[
            const SizedBox(height: 14),
            Text(
              result.duplicateEvent
                  ? strings.duplicateEventIgnored
                  : strings.progressionResultSummary(
                      result.newStarsAdded,
                      result.xpAwarded,
                      result.coinsAwarded,
                    ),
              key: const ValueKey('progression-result'),
              style: LumioTypography.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardCelebrationDialog extends StatelessWidget {
  const _RewardCelebrationDialog({required this.result});
  final ProgressionResult result;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final achievement = result.newlyUnlockedAchievements.firstOrNull;
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LumiScene(
              height: 180,
              color: LumioColors.lavender,
              pose: LumiPose.celebrating,
            ),
            const SizedBox(height: 16),
            Icon(
              result.levelUp ? Icons.auto_awesome_rounded : achievement?.icon,
              color: LumioColors.primary,
              size: 44,
            ),
            const SizedBox(height: 10),
            Text(
              result.levelUp
                  ? strings.levelUpTitle(result.newLevel)
                  : strings.newAchievementTitle,
              textAlign: TextAlign.center,
              style: LumioTypography.headingLarge,
            ),
            if (achievement != null) ...[
              const SizedBox(height: 8),
              Text(
                achievement.title(strings),
                textAlign: TextAlign.center,
                style: LumioTypography.headingSmall,
              ),
            ],
          ],
        ),
      ),
      actions: [
        LumioButton(
          label: strings.continueAction,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _RewardsError extends StatelessWidget {
  const _RewardsError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_off_rounded, size: 64),
        const SizedBox(height: 12),
        Text(strings.progressLoadError, textAlign: TextAlign.center),
        const SizedBox(height: 18),
        LumioButton(label: strings.retryAction, onPressed: onRetry),
      ],
    );
  }
}
