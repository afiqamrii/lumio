import 'package:flutter/foundation.dart';

abstract final class ProgressionConfig {
  static const missionXp = 20;
  static const baseMissionCoins = 2;
  static const maxStarsPerMission = 3;

  /// Cumulative XP for a level: 25 × (level - 1) × (level + 2).
  /// Levels 1–4 therefore begin at 0, 100, 250 and 450 XP.
  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    return 25 * (level - 1) * (level + 2);
  }

  static int levelForXp(int xp) {
    var level = 1;
    final safeXp = xp < 0 ? 0 : xp;
    while (xpRequiredForLevel(level + 1) <= safeXp) {
      level++;
    }
    return level;
  }
}

@immutable
class ChildProgress {
  const ChildProgress({
    required this.childId,
    required this.experiencePoints,
    required this.stars,
    required this.coins,
    required this.totalLearningActivitiesCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildProgress.initial(String childId, DateTime now) => ChildProgress(
    childId: childId,
    experiencePoints: 0,
    stars: 0,
    coins: 0,
    totalLearningActivitiesCompleted: 0,
    createdAt: now.toUtc(),
    updatedAt: now.toUtc(),
  );

  final String childId;
  final int experiencePoints;
  final int stars;
  final int coins;
  final int totalLearningActivitiesCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  int get level => ProgressionConfig.levelForXp(experiencePoints);
  int get currentLevelStartXp => ProgressionConfig.xpRequiredForLevel(level);
  int get nextLevelXp => ProgressionConfig.xpRequiredForLevel(level + 1);
  int get xpWithinLevel => experiencePoints - currentLevelStartXp;
  int get xpForNextLevel => nextLevelXp - currentLevelStartXp;
  double get levelProgress =>
      xpForNextLevel == 0 ? 0 : (xpWithinLevel / xpForNextLevel).clamp(0, 1);

  ChildProgress copyWith({
    int? experiencePoints,
    int? stars,
    int? coins,
    int? totalLearningActivitiesCompleted,
    DateTime? updatedAt,
  }) => ChildProgress(
    childId: childId,
    experiencePoints: experiencePoints ?? this.experiencePoints,
    stars: stars ?? this.stars,
    coins: coins ?? this.coins,
    totalLearningActivitiesCompleted:
        totalLearningActivitiesCompleted ??
        this.totalLearningActivitiesCompleted,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

@immutable
class MissionCompletion {
  const MissionCompletion({
    required this.eventId,
    required this.childId,
    required this.missionId,
    required this.worldId,
    required this.starsEarned,
    required this.completedAt,
    this.score,
  });

  final String eventId;
  final String childId;
  final String missionId;
  final String worldId;
  final int? score;
  final int starsEarned;
  final DateTime completedAt;

  void validate() {
    if (eventId.trim().isEmpty ||
        childId.trim().isEmpty ||
        missionId.trim().isEmpty ||
        worldId.trim().isEmpty ||
        starsEarned < 1 ||
        starsEarned > ProgressionConfig.maxStarsPerMission ||
        (score != null && (score! < 0 || score! > 100))) {
      throw const ProgressionValidationException();
    }
  }
}

enum RewardTransactionType { coinEarned, coinSpent }

@immutable
class RewardTransaction {
  const RewardTransaction({
    required this.id,
    required this.childId,
    required this.type,
    required this.amount,
    required this.sourceType,
    required this.sourceId,
    required this.createdAt,
  });
  final String id;
  final String childId;
  final RewardTransactionType type;
  final int amount;
  final String sourceType;
  final String sourceId;
  final DateTime createdAt;
}

@immutable
class WorldProgress {
  const WorldProgress({
    required this.childId,
    required this.worldId,
    required this.completedMissions,
    required this.totalStars,
    required this.lastPlayedAt,
  });
  final String childId;
  final String worldId;
  final int completedMissions;
  final int totalStars;
  final DateTime? lastPlayedAt;

  double? completionPercent(int? missionCount) =>
      missionCount == null || missionCount <= 0
      ? null
      : (completedMissions / missionCount).clamp(0, 1);
}

enum AchievementId {
  firstGlow,
  starCollector,
  curiousExplorer,
  brightBeginning,
}

@immutable
class ChildAchievement {
  const ChildAchievement({
    required this.childId,
    required this.achievementId,
    required this.earnedAt,
  });
  final String childId;
  final AchievementId achievementId;
  final DateTime earnedAt;
}

@immutable
class ProgressionSnapshot {
  ProgressionSnapshot({
    required this.progress,
    required List<WorldProgress> worlds,
    required List<ChildAchievement> achievements,
    required List<RewardTransaction> transactions,
  }) : worlds = List.unmodifiable(worlds),
       achievements = List.unmodifiable(achievements),
       transactions = List.unmodifiable(transactions);

  final ChildProgress progress;
  final List<WorldProgress> worlds;
  final List<ChildAchievement> achievements;
  final List<RewardTransaction> transactions;

  WorldProgress world(String id) => worlds.firstWhere(
    (world) => world.worldId == id,
    orElse: () => WorldProgress(
      childId: progress.childId,
      worldId: id,
      completedMissions: 0,
      totalStars: 0,
      lastPlayedAt: null,
    ),
  );
}

@immutable
class ProgressionResult {
  ProgressionResult({
    required this.eventId,
    required this.duplicateEvent,
    required this.starsAwarded,
    required this.newStarsAdded,
    required this.coinsAwarded,
    required this.xpAwarded,
    required this.previousLevel,
    required this.newLevel,
    required List<AchievementId> newlyUnlockedAchievements,
  }) : newlyUnlockedAchievements = List.unmodifiable(newlyUnlockedAchievements);

  final String eventId;
  final bool duplicateEvent;
  final int starsAwarded;
  final int newStarsAdded;
  final int coinsAwarded;
  final int xpAwarded;
  final int previousLevel;
  final int newLevel;
  final List<AchievementId> newlyUnlockedAchievements;
  bool get levelUp => newLevel > previousLevel;
}

class ProgressionValidationException implements Exception {
  const ProgressionValidationException();
}

class InsufficientCoinsException implements Exception {
  const InsufficientCoinsException();
}

class ProgressionChildMissingException implements Exception {
  const ProgressionChildMissingException();
}
