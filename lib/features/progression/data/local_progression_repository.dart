import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../profiles/data/profile_database.dart';
import '../domain/progression_engine.dart';
import '../domain/progression_models.dart';
import '../domain/progression_repository.dart';

class LocalProgressionRepository implements ProgressionRepository {
  LocalProgressionRepository(
    this.database, {
    DateTime Function()? clock,
    ProgressionEngine engine = const ProgressionEngine(),
  }) : _clock = clock ?? DateTime.now,
       _engine = engine;

  final ProfileDatabase database;
  final DateTime Function() _clock;
  final ProgressionEngine _engine;
  static const _uuid = Uuid();

  Future<ChildProgressRow> _ensureProgress(String childId) async {
    final child = await (database.select(
      database.localChildren,
    )..where((table) => table.id.equals(childId))).getSingleOrNull();
    if (child == null) throw const ProgressionChildMissingException();
    final existing = await (database.select(
      database.childProgresses,
    )..where((table) => table.childId.equals(childId))).getSingleOrNull();
    if (existing != null) return existing;
    final now = _clock().toUtc();
    await database
        .into(database.childProgresses)
        .insert(
          ChildProgressesCompanion.insert(
            childId: childId,
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return (database.select(
      database.childProgresses,
    )..where((table) => table.childId.equals(childId))).getSingle();
  }

  ChildProgress _progress(ChildProgressRow row) => ChildProgress(
    childId: row.childId,
    experiencePoints: row.experiencePoints,
    stars: row.stars,
    coins: row.coins,
    totalLearningActivitiesCompleted: row.totalLearningActivitiesCompleted,
    createdAt: row.createdAt.toUtc(),
    updatedAt: row.updatedAt.toUtc(),
  );

  RewardTransaction _transaction(RewardTransactionRow row) => RewardTransaction(
    id: row.id,
    childId: row.childId,
    type: RewardTransactionType.values.byName(row.type),
    amount: row.amount,
    sourceType: row.sourceType,
    sourceId: row.sourceId,
    createdAt: row.createdAt.toUtc(),
  );

  Future<ProgressionSnapshot> _loadSnapshot(String childId) async {
    final progress = _progress(await _ensureProgress(childId));
    final bests = await (database.select(
      database.missionBestResults,
    )..where((table) => table.childId.equals(childId))).get();
    final attempts = await (database.select(
      database.missionAttempts,
    )..where((table) => table.childId.equals(childId))).get();
    final achievementRows = await (database.select(
      database.childAchievements,
    )..where((table) => table.childId.equals(childId))).get();
    final transactionRows =
        await (database.select(database.rewardTransactions)
              ..where((table) => table.childId.equals(childId))
              ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
            .get();

    final worldIds = <String>{
      ...bests.map((row) => row.worldId),
      ...attempts.map((row) => row.worldId),
    };
    final worlds = <WorldProgress>[];
    for (final worldId in worldIds) {
      final worldBests = bests.where((row) => row.worldId == worldId);
      final worldAttempts = attempts.where((row) => row.worldId == worldId);
      DateTime? lastPlayed;
      for (final attempt in worldAttempts) {
        if (lastPlayed == null || attempt.completedAt.isAfter(lastPlayed)) {
          lastPlayed = attempt.completedAt;
        }
      }
      worlds.add(
        WorldProgress(
          childId: childId,
          worldId: worldId,
          completedMissions: worldBests.length,
          totalStars: worldBests.fold(0, (sum, row) => sum + row.bestStars),
          lastPlayedAt: lastPlayed?.toUtc(),
        ),
      );
    }
    worlds.sort((a, b) => a.worldId.compareTo(b.worldId));
    return ProgressionSnapshot(
      progress: progress,
      worlds: worlds,
      achievements: [
        for (final row in achievementRows)
          ChildAchievement(
            childId: childId,
            achievementId: AchievementId.values.byName(row.achievementId),
            earnedAt: row.earnedAt.toUtc(),
          ),
      ],
      transactions: transactionRows.map(_transaction).toList(),
    );
  }

  @override
  Future<ProgressionSnapshot> loadChild(String childId) =>
      database.transaction(() => _loadSnapshot(childId));

  @override
  Future<ProgressionResult> completeMission(MissionCompletion completion) =>
      database.transaction(() async {
        completion.validate();
        final duplicate =
            await (database.select(database.missionAttempts)
                  ..where((table) => table.eventId.equals(completion.eventId)))
                .getSingleOrNull();
        if (duplicate != null) {
          if (duplicate.childId != completion.childId) {
            throw const ProgressionValidationException();
          }
          final current = _progress(await _ensureProgress(completion.childId));
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

        final current = _progress(await _ensureProgress(completion.childId));
        final best =
            await (database.select(database.missionBestResults)..where(
                  (table) =>
                      table.childId.equals(completion.childId) &
                      table.missionId.equals(completion.missionId),
                ))
                .getSingleOrNull();
        final plan = _engine.planMission(
          completion: completion,
          previousBestStars: best?.bestStars,
        );
        final attempts =
            await (database.select(database.missionAttempts)..where(
                  (table) =>
                      table.childId.equals(completion.childId) &
                      table.missionId.equals(completion.missionId),
                ))
                .get();
        await database
            .into(database.missionAttempts)
            .insert(
              MissionAttemptsCompanion.insert(
                eventId: completion.eventId,
                childId: completion.childId,
                missionId: completion.missionId,
                worldId: completion.worldId,
                score: Value(completion.score),
                starsEarned: completion.starsEarned,
                xpAwarded: plan.xp,
                coinsAwarded: plan.coins,
                attemptNumber: attempts.length + 1,
                completedAt: completion.completedAt.toUtc(),
              ),
            );

        final improvesScore =
            completion.score != null &&
            (best?.bestScore == null || completion.score! > best!.bestScore!);
        if (best == null) {
          await database
              .into(database.missionBestResults)
              .insert(
                MissionBestResultsCompanion.insert(
                  childId: completion.childId,
                  missionId: completion.missionId,
                  worldId: completion.worldId,
                  bestStars: completion.starsEarned,
                  bestScore: Value(completion.score),
                  firstCompletedAt: completion.completedAt.toUtc(),
                  lastImprovedAt: completion.completedAt.toUtc(),
                ),
              );
        } else if (plan.newStars > 0 || improvesScore) {
          await (database.update(database.missionBestResults)..where(
                (table) =>
                    table.childId.equals(completion.childId) &
                    table.missionId.equals(completion.missionId),
              ))
              .write(
                MissionBestResultsCompanion(
                  worldId: Value(completion.worldId),
                  bestStars: Value(
                    completion.starsEarned > best.bestStars
                        ? completion.starsEarned
                        : best.bestStars,
                  ),
                  bestScore: Value(
                    improvesScore ? completion.score : best.bestScore,
                  ),
                  lastImprovedAt: Value(completion.completedAt.toUtc()),
                ),
              );
        }

        final updated = current.copyWith(
          experiencePoints: current.experiencePoints + plan.xp,
          stars: current.stars + plan.newStars,
          coins: current.coins + plan.coins,
          totalLearningActivitiesCompleted:
              current.totalLearningActivitiesCompleted +
              (plan.uniqueMissionCompleted ? 1 : 0),
          updatedAt: _clock().toUtc(),
        );
        await (database.update(
          database.childProgresses,
        )..where((table) => table.childId.equals(completion.childId))).write(
          ChildProgressesCompanion(
            experiencePoints: Value(updated.experiencePoints),
            stars: Value(updated.stars),
            coins: Value(updated.coins),
            totalLearningActivitiesCompleted: Value(
              updated.totalLearningActivitiesCompleted,
            ),
            updatedAt: Value(updated.updatedAt),
          ),
        );

        if (plan.coins > 0) {
          await database
              .into(database.rewardTransactions)
              .insert(
                RewardTransactionsCompanion.insert(
                  id: _uuid.v4(),
                  childId: completion.childId,
                  type: RewardTransactionType.coinEarned.name,
                  amount: plan.coins,
                  sourceType: 'mission',
                  sourceId: completion.eventId,
                  createdAt: completion.completedAt.toUtc(),
                ),
              );
        }

        final worldRows = await (database.select(
          database.missionBestResults,
        )..where((table) => table.childId.equals(completion.childId))).get();
        final earnedRows = await (database.select(
          database.childAchievements,
        )..where((table) => table.childId.equals(completion.childId))).get();
        final earned = earnedRows
            .map((row) => AchievementId.values.byName(row.achievementId))
            .toSet();
        final newlyEarned = _engine.newlyEarned(
          progress: updated,
          exploredWorldCount: worldRows
              .map((row) => row.worldId)
              .toSet()
              .length,
          alreadyEarned: earned,
        );
        for (final achievement in newlyEarned) {
          await database
              .into(database.childAchievements)
              .insert(
                ChildAchievementsCompanion.insert(
                  childId: completion.childId,
                  achievementId: achievement.name,
                  earnedAt: completion.completedAt.toUtc(),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }

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
      });

  @override
  Future<RewardTransaction> spendCoins({
    required String childId,
    required int amount,
    required String sourceType,
    required String sourceId,
  }) => database.transaction(() async {
    if (amount <= 0 || sourceType.isEmpty || sourceId.isEmpty) {
      throw const ProgressionValidationException();
    }
    final existing =
        await (database.select(database.rewardTransactions)..where(
              (table) =>
                  table.childId.equals(childId) &
                  table.type.equals(RewardTransactionType.coinSpent.name) &
                  table.sourceType.equals(sourceType) &
                  table.sourceId.equals(sourceId),
            ))
            .getSingleOrNull();
    if (existing != null) return _transaction(existing);
    final current = _progress(await _ensureProgress(childId));
    if (current.coins < amount) throw const InsufficientCoinsException();
    final now = _clock().toUtc();
    final row = RewardTransactionsCompanion.insert(
      id: _uuid.v4(),
      childId: childId,
      type: RewardTransactionType.coinSpent.name,
      amount: amount,
      sourceType: sourceType,
      sourceId: sourceId,
      createdAt: now,
    );
    await database.into(database.rewardTransactions).insert(row);
    await (database.update(
      database.childProgresses,
    )..where((table) => table.childId.equals(childId))).write(
      ChildProgressesCompanion(
        coins: Value(current.coins - amount),
        updatedAt: Value(now),
      ),
    );
    return RewardTransaction(
      id: row.id.value,
      childId: childId,
      type: RewardTransactionType.coinSpent,
      amount: amount,
      sourceType: sourceType,
      sourceId: sourceId,
      createdAt: now,
    );
  });

  @override
  Future<void> resetChild(String childId) => database.transaction(() async {
    await (database.delete(
      database.childAchievements,
    )..where((table) => table.childId.equals(childId))).go();
    await (database.delete(
      database.rewardTransactions,
    )..where((table) => table.childId.equals(childId))).go();
    await (database.delete(
      database.missionBestResults,
    )..where((table) => table.childId.equals(childId))).go();
    await (database.delete(
      database.missionAttempts,
    )..where((table) => table.childId.equals(childId))).go();
    await (database.delete(
      database.childProgresses,
    )..where((table) => table.childId.equals(childId))).go();
  });

  @override
  Future<void> resetAll() => database.transaction(() async {
    await database.delete(database.childAchievements).go();
    await database.delete(database.rewardTransactions).go();
    await database.delete(database.missionBestResults).go();
    await database.delete(database.missionAttempts).go();
    await database.delete(database.childProgresses).go();
  });
}
