import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/features/progression/data/memory_progression_repository.dart';
import 'package:lumio/features/progression/domain/progression_models.dart';

MissionCompletion completion({
  required String event,
  required String child,
  required String mission,
  String world = 'number-kingdom',
  int stars = 1,
}) => MissionCompletion(
  eventId: event,
  childId: child,
  missionId: mission,
  worldId: world,
  starsEarned: stars,
  score: stars * 30,
  completedAt: DateTime.utc(2026, 9, 27),
);

void main() {
  test('new child starts with clean, level-one progression', () async {
    final repo = MemoryProgressionRepository();
    final snapshot = await repo.loadChild('a');
    expect(snapshot.progress.level, 1);
    expect(snapshot.progress.experiencePoints, 0);
    expect(snapshot.progress.stars, 0);
    expect(snapshot.progress.coins, 0);
    expect(snapshot.achievements, isEmpty);
  });

  test(
    'documented XP curve and multiple-level calculation are deterministic',
    () {
      expect(
        [
          for (var level = 1; level <= 4; level++)
            ProgressionConfig.xpRequiredForLevel(level),
        ],
        [0, 100, 250, 450],
      );
      expect(ProgressionConfig.levelForXp(99), 1);
      expect(ProgressionConfig.levelForXp(100), 2);
      expect(ProgressionConfig.levelForXp(449), 3);
      expect(ProgressionConfig.levelForXp(700), 5);
    },
  );

  test(
    'first completion awards XP, stars, coins and crosses threshold',
    () async {
      final repo = MemoryProgressionRepository();
      ProgressionResult? last;
      for (var index = 0; index < 5; index++) {
        last = await repo.completeMission(
          completion(event: 'e$index', child: 'a', mission: 'm$index'),
        );
      }
      final progress = (await repo.loadChild('a')).progress;
      expect(progress.experiencePoints, 100);
      expect(progress.level, 2);
      expect(last!.levelUp, isTrue);
      expect(last.previousLevel, 1);
      expect(last.newLevel, 2);
    },
  );

  test(
    'mission replay adds only best-star improvement and cannot farm',
    () async {
      final repo = MemoryProgressionRepository();
      final first = await repo.completeMission(
        completion(event: 'one', child: 'a', mission: 'math-1'),
      );
      expect(first.newStarsAdded, 1);
      expect(first.xpAwarded, ProgressionConfig.missionXp);
      expect(first.coinsAwarded, 3);

      final sameResult = await repo.completeMission(
        completion(event: 'two', child: 'a', mission: 'math-1'),
      );
      expect(sameResult.newStarsAdded, 0);
      expect(sameResult.xpAwarded, 0);
      expect(sameResult.coinsAwarded, 0);

      final improved = await repo.completeMission(
        completion(event: 'three', child: 'a', mission: 'math-1', stars: 3),
      );
      expect(improved.newStarsAdded, 2);
      expect(improved.xpAwarded, 0);
      expect(improved.coinsAwarded, 0);

      final worse = await repo.completeMission(
        completion(event: 'four', child: 'a', mission: 'math-1', stars: 2),
      );
      expect(worse.newStarsAdded, 0);
      expect((await repo.loadChild('a')).progress.stars, 3);
    },
  );

  test(
    'duplicate event is idempotent and coin spending cannot go negative',
    () async {
      final repo = MemoryProgressionRepository();
      final event = completion(event: 'same', child: 'a', mission: 'math-1');
      await repo.completeMission(event);
      final duplicate = await repo.completeMission(event);
      expect(duplicate.duplicateEvent, isTrue);
      expect(duplicate.xpAwarded, 0);
      expect(duplicate.coinsAwarded, 0);
      expect((await repo.loadChild('a')).transactions, hasLength(1));

      await expectLater(
        repo.spendCoins(
          childId: 'a',
          amount: 4,
          sourceType: 'cosmetic',
          sourceId: 'future-item',
        ),
        throwsA(isA<InsufficientCoinsException>()),
      );
      expect((await repo.loadChild('a')).progress.coins, 3);
    },
  );

  test('achievements unlock once and world progress is summarized', () async {
    final repo = MemoryProgressionRepository();
    final results = <ProgressionResult>[];
    for (var index = 0; index < 5; index++) {
      results.add(
        await repo.completeMission(
          completion(
            event: 'e$index',
            child: 'a',
            mission: 'm$index',
            world: ['number-kingdom', 'word-woods', 'logic-lab'][index % 3],
            stars: index < 4 ? 3 : 1,
          ),
        ),
      );
    }
    final snapshot = await repo.loadChild('a');
    expect(snapshot.progress.stars, 13);
    expect(snapshot.progress.level, 2);
    expect(
      snapshot.achievements.map((item) => item.achievementId).toSet(),
      containsAll(AchievementId.values),
    );
    expect(
      results
          .expand((result) => result.newlyUnlockedAchievements)
          .where((id) => id == AchievementId.firstGlow),
      hasLength(1),
    );
    expect(snapshot.world('number-kingdom').completedMissions, 2);
    expect(snapshot.world('number-kingdom').totalStars, 6);
  });

  test(
    'progression and world records stay isolated between children',
    () async {
      final repo = MemoryProgressionRepository();
      for (var index = 0; index < 5; index++) {
        await repo.completeMission(
          completion(
            event: 'a$index',
            child: 'a',
            mission: 'm$index',
            stars: 3,
          ),
        );
      }
      final a = await repo.loadChild('a');
      final b = await repo.loadChild('b');
      expect(a.progress.level, 2);
      expect(a.progress.stars, 15);
      expect(a.progress.coins, 25);
      expect(a.world('number-kingdom').completedMissions, 5);
      expect(b.progress.level, 1);
      expect(b.progress.stars, 0);
      expect(b.progress.coins, 0);
      expect(b.world('number-kingdom').completedMissions, 0);
    },
  );
}
