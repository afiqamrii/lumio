import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumio/features/profiles/data/local_profile_repository.dart';
import 'package:lumio/features/profiles/data/profile_database.dart';
import 'package:lumio/features/profiles/domain/profiles.dart';
import 'package:lumio/features/progression/data/local_progression_repository.dart';
import 'package:lumio/features/progression/domain/progression_models.dart';

const _childDraft = ChildDraft(
  displayName: 'Aiman',
  startingAge: 7,
  avatar: ProfileAvatar.spark,
  language: 'en',
);

void main() {
  test('progress, ledger and achievements survive repository reload', () async {
    final folder = await Directory.systemTemp.createTemp('lumio-progress-');
    final file = File('${folder.path}/lumio.sqlite');
    final firstDb = ProfileDatabase(NativeDatabase(file));
    final profiles = LocalProfileRepository(firstDb);
    await profiles.completeSetup('Parent', _childDraft);
    final child = (await profiles.load()).children.single;
    final firstProgression = LocalProgressionRepository(firstDb);
    await firstProgression.completeMission(
      MissionCompletion(
        eventId: 'persist-event',
        childId: child.id,
        missionId: 'debug-1',
        worldId: 'number-kingdom',
        starsEarned: 3,
        completedAt: DateTime.utc(2026, 9, 27),
      ),
    );
    await firstDb.close();

    final secondDb = ProfileDatabase(NativeDatabase(file));
    try {
      final restoredProfiles = await LocalProfileRepository(secondDb).load();
      final restored = await LocalProgressionRepository(
        secondDb,
      ).loadChild(child.id);
      expect(restoredProfiles.children.single.id, child.id);
      expect(restored.progress.stars, 3);
      expect(restored.progress.coins, 5);
      expect(restored.progress.experiencePoints, 20);
      expect(restored.transactions.single.sourceId, 'persist-event');
      expect(
        restored.achievements.single.achievementId,
        AchievementId.firstGlow,
      );
    } finally {
      await secondDb.close();
      await folder.delete(recursive: true);
    }
  });

  test('schema v1 profiles migrate to v2 without data loss', () async {
    final folder = await Directory.systemTemp.createTemp('lumio-migration-');
    final file = File('${folder.path}/lumio.sqlite');
    final legacy = NativeDatabase(file);
    await legacy.ensureOpen(_LegacyExecutorUser());
    await legacy.runCustom('PRAGMA foreign_keys = ON');
    await legacy.runCustom(
      'CREATE TABLE local_parents (id TEXT NOT NULL PRIMARY KEY, singleton INTEGER NOT NULL DEFAULT 1 UNIQUE, display_name TEXT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, CHECK (singleton = 1))',
    );
    await legacy.runCustom(
      'CREATE TABLE local_children (id TEXT NOT NULL PRIMARY KEY, parent_id TEXT NOT NULL REFERENCES local_parents(id), display_name TEXT NOT NULL, starting_age INTEGER NOT NULL, avatar_id TEXT NOT NULL, language TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, CHECK (starting_age BETWEEN 5 AND 9), CHECK (language IN (\'en\', \'ms\')), CHECK (avatar_id IN (\'spark\', \'sun\', \'moon\', \'leaf\')))',
    );
    await legacy.runCustom(
      'CREATE TABLE local_setup (id INTEGER NOT NULL PRIMARY KEY, completed INTEGER NOT NULL CHECK (id = 1))',
    );
    const parent = '00000000-0000-4000-8000-000000000001';
    const child = '00000000-0000-4000-8000-000000000002';
    final epoch = DateTime.utc(2026, 9, 26).millisecondsSinceEpoch ~/ 1000;
    await legacy.runCustom(
      "INSERT INTO local_parents VALUES ('$parent', 1, 'Parent', $epoch, $epoch)",
    );
    await legacy.runCustom(
      "INSERT INTO local_children VALUES ('$child', '$parent', 'Aiman', 7, 'spark', 'en', $epoch, $epoch)",
    );
    await legacy.runCustom('INSERT INTO local_setup VALUES (1, 1)');
    await legacy.runCustom('PRAGMA user_version = 1');
    await legacy.close();

    final migratedDb = ProfileDatabase(NativeDatabase(file));
    try {
      final snapshot = await LocalProfileRepository(migratedDb).load();
      final progress = await LocalProgressionRepository(
        migratedDb,
      ).loadChild(child);
      expect(snapshot.children.single.displayName, 'Aiman');
      expect(progress.progress.level, 1);
      expect(progress.progress.stars, 0);
    } finally {
      await migratedDb.close();
      await folder.delete(recursive: true);
    }
  });
}

class _LegacyExecutorUser implements QueryExecutorUser {
  @override
  int get schemaVersion => 1;

  @override
  Future<void> beforeOpen(
    QueryExecutor executor,
    OpeningDetails details,
  ) async {}
}
