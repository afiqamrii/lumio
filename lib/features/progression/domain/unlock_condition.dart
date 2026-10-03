import 'progression_models.dart';

class UnlockContext {
  const UnlockContext({required this.snapshot});
  final ProgressionSnapshot snapshot;
}

sealed class UnlockCondition {
  const UnlockCondition();
  bool isMet(UnlockContext context);
}

class AlwaysUnlocked extends UnlockCondition {
  const AlwaysUnlocked();
  @override
  bool isMet(UnlockContext context) => true;
}

class MinimumLevel extends UnlockCondition {
  const MinimumLevel(this.level);
  final int level;
  @override
  bool isMet(UnlockContext context) => context.snapshot.progress.level >= level;
}

class MinimumStars extends UnlockCondition {
  const MinimumStars(this.stars);
  final int stars;
  @override
  bool isMet(UnlockContext context) => context.snapshot.progress.stars >= stars;
}

class MissionCompleted extends UnlockCondition {
  const MissionCompleted(this.worldId);
  final String worldId;
  @override
  bool isMet(UnlockContext context) =>
      context.snapshot.world(worldId).completedMissions > 0;
}

class MinimumWorldMissions extends UnlockCondition {
  const MinimumWorldMissions(this.worldId, this.completedMissions);
  final String worldId;
  final int completedMissions;
  @override
  bool isMet(UnlockContext context) =>
      context.snapshot.world(worldId).completedMissions >= completedMissions;
}
