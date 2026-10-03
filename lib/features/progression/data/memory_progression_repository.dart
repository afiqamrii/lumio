import 'package:uuid/uuid.dart';

import '../domain/progression_engine.dart';
import '../domain/progression_models.dart';
import '../domain/progression_repository.dart';

/// Lightweight deterministic repository used by tests whose profile repository
/// is overridden. Production uses [LocalProgressionRepository].
class MemoryProgressionRepository implements ProgressionRepository {
  MemoryProgressionRepository({
    DateTime Function()? clock,
    ProgressionEngine engine = const ProgressionEngine(),
  }) : _clock = clock ?? DateTime.now,
       _engine = engine;

  final DateTime Function() _clock;
  final ProgressionEngine _engine;
  static const _uuid = Uuid();
  final Map<String, ChildProgress> _progress = {};
  final Map<String, MissionCompletion> _events = {};
  final Map<String, int> _bestStars = {};
  final Map<String, String> _bestWorld = {};
  final Map<String, DateTime> _lastPlayed = {};
  final Map<String, List<ChildAchievement>> _achievements = {};
  final Map<String, List<RewardTransaction>> _transactions = {};

  String _missionKey(String childId, String missionId) =>
      '$childId::$missionId';
  String _worldKey(String childId, String worldId) => '$childId::$worldId';

  ChildProgress _child(String childId) => _progress.putIfAbsent(
    childId,
    () => ChildProgress.initial(childId, _clock()),
  );

  @override
  Future<ProgressionSnapshot> loadChild(String childId) async {
    final progress = _child(childId);
    final worlds = <WorldProgress>[];
    final worldIds = _bestWorld.entries
        .where((entry) => entry.key.startsWith('$childId::'))
        .map((entry) => entry.value)
        .toSet();
    for (final worldId in worldIds) {
      final missionKeys = _bestWorld.entries
          .where(
            (entry) =>
                entry.key.startsWith('$childId::') && entry.value == worldId,
          )
          .map((entry) => entry.key);
      worlds.add(
        WorldProgress(
          childId: childId,
          worldId: worldId,
          completedMissions: missionKeys.length,
          totalStars: missionKeys.fold(
            0,
            (sum, key) => sum + (_bestStars[key] ?? 0),
          ),
          lastPlayedAt: _lastPlayed[_worldKey(childId, worldId)],
        ),
      );
    }
    return ProgressionSnapshot(
      progress: progress,
      worlds: worlds,
      achievements: _achievements[childId] ?? const [],
      transactions: List.of(_transactions[childId] ?? const []),
    );
  }

  @override
  Future<ProgressionResult> completeMission(
    MissionCompletion completion,
  ) async {
    completion.validate();
    final duplicate = _events[completion.eventId];
    if (duplicate != null) {
      if (duplicate.childId != completion.childId) {
        throw const ProgressionValidationException();
      }
      final current = _child(completion.childId);
      return ProgressionResult(
        eventId: completion.eventId,
        duplicateEvent: true,
        starsAwarded: completion.starsEarned,
        newStarsAdded: 0,
        coinsAwarded: 0,
        xpAwarded: 0,
        previousLevel: current.level,
        newLevel: current.level,
        newlyUnlockedAchievements: const [],
      );
    }
    final current = _child(completion.childId);
    final key = _missionKey(completion.childId, completion.missionId);
    final plan = _engine.planMission(
      completion: completion,
      previousBestStars: _bestStars[key],
    );
    _events[completion.eventId] = completion;
    if (_bestStars[key] == null || completion.starsEarned > _bestStars[key]!) {
      _bestStars[key] = completion.starsEarned;
      _bestWorld[key] = completion.worldId;
    }
    _lastPlayed[_worldKey(completion.childId, completion.worldId)] = completion
        .completedAt
        .toUtc();
    final updated = current.copyWith(
      experiencePoints: current.experiencePoints + plan.xp,
      stars: current.stars + plan.newStars,
      coins: current.coins + plan.coins,
      totalLearningActivitiesCompleted:
          current.totalLearningActivitiesCompleted +
          (plan.uniqueMissionCompleted ? 1 : 0),
      updatedAt: _clock().toUtc(),
    );
    _progress[completion.childId] = updated;
    if (plan.coins > 0) {
      (_transactions[completion.childId] ??= []).insert(
        0,
        RewardTransaction(
          id: _uuid.v4(),
          childId: completion.childId,
          type: RewardTransactionType.coinEarned,
          amount: plan.coins,
          sourceType: 'mission',
          sourceId: completion.eventId,
          createdAt: completion.completedAt.toUtc(),
        ),
      );
    }
    final already = (_achievements[completion.childId] ?? const [])
        .map((item) => item.achievementId)
        .toSet();
    final explored = _bestWorld.entries
        .where((entry) => entry.key.startsWith('${completion.childId}::'))
        .map((entry) => entry.value)
        .toSet()
        .length;
    final newlyEarned = _engine.newlyEarned(
      progress: updated,
      exploredWorldCount: explored,
      alreadyEarned: already,
    );
    final earned = _achievements[completion.childId] ??= [];
    earned.addAll(
      newlyEarned.map(
        (id) => ChildAchievement(
          childId: completion.childId,
          achievementId: id,
          earnedAt: completion.completedAt.toUtc(),
        ),
      ),
    );
    return ProgressionResult(
      eventId: completion.eventId,
      duplicateEvent: false,
      starsAwarded: completion.starsEarned,
      newStarsAdded: plan.newStars,
      coinsAwarded: plan.coins,
      xpAwarded: plan.xp,
      previousLevel: current.level,
      newLevel: updated.level,
      newlyUnlockedAchievements: newlyEarned,
    );
  }

  @override
  Future<RewardTransaction> spendCoins({
    required String childId,
    required int amount,
    required String sourceType,
    required String sourceId,
  }) async {
    if (amount <= 0 || sourceType.isEmpty || sourceId.isEmpty) {
      throw const ProgressionValidationException();
    }
    final transactions = _transactions[childId] ??= [];
    for (final item in transactions) {
      if (item.type == RewardTransactionType.coinSpent &&
          item.sourceType == sourceType &&
          item.sourceId == sourceId) {
        return item;
      }
    }
    final current = _child(childId);
    if (current.coins < amount) throw const InsufficientCoinsException();
    final now = _clock().toUtc();
    final transaction = RewardTransaction(
      id: _uuid.v4(),
      childId: childId,
      type: RewardTransactionType.coinSpent,
      amount: amount,
      sourceType: sourceType,
      sourceId: sourceId,
      createdAt: now,
    );
    transactions.insert(0, transaction);
    _progress[childId] = current.copyWith(
      coins: current.coins - amount,
      updatedAt: now,
    );
    return transaction;
  }

  @override
  Future<void> resetChild(String childId) async {
    _progress.remove(childId);
    _events.removeWhere((_, value) => value.childId == childId);
    _bestStars.removeWhere((key, _) => key.startsWith('$childId::'));
    _bestWorld.removeWhere((key, _) => key.startsWith('$childId::'));
    _lastPlayed.removeWhere((key, _) => key.startsWith('$childId::'));
    _achievements.remove(childId);
    _transactions.remove(childId);
  }

  @override
  Future<void> resetAll() async {
    _progress.clear();
    _events.clear();
    _bestStars.clear();
    _bestWorld.clear();
    _lastPlayed.clear();
    _achievements.clear();
    _transactions.clear();
  }
}
