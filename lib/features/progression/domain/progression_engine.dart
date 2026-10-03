import 'achievement_catalog.dart';
import 'progression_models.dart';

class MissionRewardPlan {
  const MissionRewardPlan({
    required this.newStars,
    required this.xp,
    required this.coins,
    required this.uniqueMissionCompleted,
  });
  final int newStars;
  final int xp;
  final int coins;
  final bool uniqueMissionCompleted;
}

/// Pure reward rules. Persistence and UI remain outside this class.
class ProgressionEngine {
  const ProgressionEngine();

  MissionRewardPlan planMission({
    required MissionCompletion completion,
    required int? previousBestStars,
  }) {
    completion.validate();
    final previous = previousBestStars ?? 0;
    final difference = completion.starsEarned > previous
        ? completion.starsEarned - previous
        : 0;
    final firstCompletion = previousBestStars == null;
    return MissionRewardPlan(
      newStars: difference,
      xp: firstCompletion ? ProgressionConfig.missionXp : 0,
      coins: firstCompletion
          ? ProgressionConfig.baseMissionCoins + completion.starsEarned
          : 0,
      uniqueMissionCompleted: firstCompletion,
    );
  }

  List<AchievementId> newlyEarned({
    required ChildProgress progress,
    required int exploredWorldCount,
    required Set<AchievementId> alreadyEarned,
  }) => [
    for (final definition in AchievementCatalog.definitions)
      if (!alreadyEarned.contains(definition.id) &&
          AchievementCatalog.isEarned(
            definition.id,
            progress: progress,
            exploredWorldCount: exploredWorldCount,
          ))
        definition.id,
  ];
}
