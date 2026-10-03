import 'progression_models.dart';

class AchievementDefinition {
  const AchievementDefinition({required this.id, required this.iconName});
  final AchievementId id;
  final String iconName;
}

abstract final class AchievementCatalog {
  static const definitions = <AchievementDefinition>[
    AchievementDefinition(id: AchievementId.firstGlow, iconName: 'spark'),
    AchievementDefinition(id: AchievementId.starCollector, iconName: 'star'),
    AchievementDefinition(
      id: AchievementId.curiousExplorer,
      iconName: 'compass',
    ),
    AchievementDefinition(id: AchievementId.brightBeginning, iconName: 'sun'),
  ];

  static bool isEarned(
    AchievementId id, {
    required ChildProgress progress,
    required int exploredWorldCount,
  }) => switch (id) {
    AchievementId.firstGlow => progress.totalLearningActivitiesCompleted >= 1,
    AchievementId.starCollector => progress.stars >= 10,
    AchievementId.curiousExplorer => exploredWorldCount >= 3,
    AchievementId.brightBeginning => progress.level >= 2,
  };
}
